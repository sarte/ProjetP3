function [] = outil(T1,M,T,p,mu)
% outil calculates the amount of methane [t/day], water [t/day] 
% and air [t/day] needed to produce M [t/day] of ammonia, 
% in function of differents parameters:
% T1[K] Primary Reformer temperature.
% T[K] Synthesis Reactor temperature.
% p[bar], Synthesis Reactor pressure.
% mu, the purge split fraction.
%
% xi represents the stage of completion of the synthesis reaction
% x corresponds to the number of moles of methane needed per day.
% y corresponds to the number of moles of water needed per day.
% m represents the first stage of completion of the reaction in the Primary Reformer
% n represents the second stage of completion of the reaction in the Primary Reformer
% a corresponds to the number of moles of air needed per day.
% B corresponds to the number of moles of methane needed in the oven.
%
% Uses a bottom-up strategy: it first calculates everything for the
% Synthesis Reactor, and then goes back to the Primary Reformer.

global OUT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Synthesis Reactor     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reference values used in the calculations
CH4 = [-0.703029 108.4773 -42.52157 5.862788 0.678565 158.7163];
H2O = [30.09200 6.832514 6.793435 -2.534480	0.082139 223.3967];
CO = [25.56759 6.096130 4.054656 -2.671301 0.131021 227.3665] ;
CO2 = [24.99735 55.18696 -33.69137 7.948387 -0.136638 228.2431];
O2 = [30.03235 8.772972 -3.988133 0.788313 -0.741599 236.1663];
N2 = [19.50583 19.88705 -8.598535 1.369784 0.527601	212.3900];
H2 = [33.066178 -11.363417 11.432816 -2.772874 -0.158558 172.707974]; 
NH3 = [19.99563 49.77119 -15.37599 1.921168	0.189174 203.8591];
Re = [0 0 0 0 0 0];
deltaHref = [0 0 0 -45.90];
deltaHref1 = [-74.810 -241.820 0 -110.530];
deltaHref2 = [-110.530 -241.820 0 -393.510];
deltaHref3 = [-74.810 0 -393.510 -241.820];

% calculation of the different values for K
deltaS1 = deltaS(N2,H2,Re,NH3,[1 3 0 2],T);
deltaH1 = deltaH(N2,H2,Re,NH3,[1 3 0 2],T, deltaHref);
K1 = K(deltaS1,deltaH1,T);

%resolution of the equations
xi=1/2*(M*(10^6))/(17.031);
syms N positive
[solN] = double(solve(K1 * p^2 == (1 - mu)^2 * (2 * xi * (4*N - 2 * xi + 1/78*N - mu*(2*xi + 1/78)))^2 / ( 27 * (N - xi)^4), xi<=N,N, 'Real', true));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Primary Reformer      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculation of the different values for K
deltaSS1 = deltaS(CH4,H2O,H2,CO,[1 1 3 1],T1);
deltaHH1 = deltaH(CH4,H2O,H2,CO,[1 1 3 1],T1, deltaHref1);
K11 = K(deltaSS1,deltaHH1,T1);
deltaSS2 = deltaS(CO,H2O,H2,CO2,[1 1 1 1],T1);
deltaHH2 = deltaH(CO,H2O,H2,CO2,[1 1 1 1],T1, deltaHref2);
DHfour = deltaH(CH4,O2,CO2,H2O, [1 2 1 2],T, deltaHref3);
K2 = K(deltaSS2,deltaHH2,T1);

%resolution of the equations
syms x y n m MM positive
[solx, soly, soln, solm, MM] = solve(3 * x + m - 3 * solN == 0, 4 * x - (0.42/0.78 + 3)*solN == 0,-K11/900 + (((3*m + n)^3) * (m - n))/(((x + 2*m + y)^2) * (y - n - m) * (x - m)) == 0, -K2 + ((3*m + n) * n)/((m - n) * (y - n - m)) == 0,MM == M,x,y,n,m,MM,'Real',true);
B=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*16);
D=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*32);
E=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*44);
F=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*18);


% These flows are displayed by RUN
% I: to primary reformer
% CH4 H2O
OUT.I = double([solx/1000000*16,soly/1000000*18]);
% II: from primary to secondary reformer
% CH4 H2 CO2 CO H2O
OUT.II = double([(solx-solm)/1000000*16,(3*solm+soln)/1000000*2,soln/1000000*44,(solm-soln)/1000000*28,(soly-solm-soln)/1000000*18]);
% III: Air flow to secondary flow
% N2 O2 Ar
OUT.III = double([(solm+3*solx)/3/1000000*28,0.21*(solm+3*solx)/3/0.78/1000000*32,0.01*(solm+3*solx)/3/0.78/1000000*40]);
% IV: from secondary reformer to Water-Gas-Shift reactor
% N2 H2 H2O Ar CO2 CO
OUT.IV = double([(solm+3*solx)/3/1000000*28,(solm+soln+2*solx)/1000000*2,(soly-solm-soln)/1000000*18,0.01*(solm+3*solx)/3/0.78/1000000*40,soln/1000000*44,(solx-soln)/1000000*28]);
% V: from Water-Gas-Shift reactor to CO2 absortion & compression
% N2 H2 H2O Ar CO2
OUT.V = double([(solm+3*solx)/3/1000000*28,(solm+3*solx)/1000000*2,(soly-solm-solx)/1000000*18,0.01*(solm+3*solx)/3/0.78/1000000*40,solx/1000000*44]);
% VI: out from CO2 absortion & compression
% H2O CO2
OUT.VI = double([(soly-solm-solx)/1000000*18,solx/1000000*44]);
% VII: from CO2 absortion & compression to NH3 synthesis reactor
% N2 H2 Ar
OUT.VII = double([(solm+3*solx)/3/1000000*28,(solm+3*solx)/1000000*2,0.01*(solm+3*solx)/3/0.78/1000000*40]);
% VIII: out from NH3 synthesis reactor
% N2 H2 Ar %%%%%%%%%%%% N2 et H2 a faire
OUT.VIII = double([0,0,0.01*(solm+3*solx)/3/0.78/1000000*40]);
% XI: Final NH3 (out from synthesis reactor)
% NH3
OUT.IX = double(MM);
% H: All the flows in the primary reformer heater
%Heater CH4 O2 H2O CO2  %%%%%%%%%%%%%%%%%%%% E et F a verifier
OUT.H = double([B,D,E,F]);


end
