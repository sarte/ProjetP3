function [] = syntheseRe(T,T2,p,pu,M)
P=p;
xi=(M*(10^6))/(17.031)/2;

% valeurs de reference utilisees dans les calculs
N2 = [19.50583 19.88705 -8.598535 1.369784 0.527601	212.3900];
H2 = [33.066178 -11.363417 11.432816 -2.772874 -0.158558 172.707974]; 
NH3 = [19.99563 49.77119 -15.37599 1.921168	0.189174 203.8591];
R = [0 0 0 0 0 0]; %3e element nul
deltaHref1 = [0 0 0 -45.90];

% calcul des differentes valeurs en fonction des arguments
deltaSS1 = deltaS(N2,H2,R,NH3,[1 3 0 2],T2);
deltaHH1 = deltaH(N2,H2,R,NH3,[1 3 0 2],T2, deltaHref1);
format long
Kc = K(deltaSS1,deltaHH1,T2);

syms X Ar N2 H2 positive
[solAr,solN2,solH2,solX]=solve(Ar+pu*(X-pu*(X-xi))/(78*(1-pu))==(X-pu*(X-xi))/(78*(1-pu)),N2+pu*(X-xi)==X,H2+pu*(3*X-3*xi)==3*X,Kc==((4*xi^2)*(4*X-2*xi+(X-pu*(X-xi))/(78*(1-pu)))^2)/((P^2)*(X-xi)*(3*X-3*xi)^3),Ar,N2,H2,X);
nh3=[solAr,solN2,solH2,solX];

% valeurs de reference utilisees dans les calculs
CH4 = [-0.703029 108.4773 -42.52157 5.862788 0.678565 158.7163];
H2O = [30.09200 6.832514 6.793435 -2.534480	0.082139 223.3967];
H2 = [33.066178 -11.363417 11.432816 -2.772874 -0.158558 172.707974]; 
CO = [25.56759 6.096130 4.054656 -2.671301 0.131021 227.3665] ;
CO2 = [24.99735 55.18696 -33.69137 7.948387 -0.136638 228.2431];
O2 = [30.03235 8.772972 -3.988133 0.788313 -0.741599 236.1663];
deltaHref1 = [-74.810 -241.820 0 -110.530];
deltaHref2 = [-110.530 -241.820 0 -393.510];
deltaHref3 = [-74.810 0 -393.510 -241.820];

% calcul des differentes valeurs en fonction des arguments
deltaSS1 = deltaS(CH4,H2O,H2,CO,[1 1 3 1],T);
deltaHH1 = deltaH(CH4,H2O,H2,CO,[1 1 3 1],T, deltaHref1);
K1 = K(deltaSS1,deltaHH1,T);
deltaSS2 = deltaS(CO,H2O,H2,CO2,[1 1 1 1],T);
deltaHH2 = deltaH(CO,H2O,H2,CO2,[1 1 1 1],T, deltaHref2);
K2 = K(deltaSS2,deltaHH2,T);
DHfour = deltaH(CH4,O2,CO2,H2O, [1 2 1 2],T, deltaHref3);
nummol= (M*(10^6))/(17.031);
format long
a =  nummol/(2*0.78);

%resolution de l'eq
syms x m n b positive 
[solx, solm, soln, solb] = solve(x - m - 0.42*a == 0, b == a, -K1/900 + (((3*m + n)^3) * (m - n))/(((x + 2*m + solH2(2))^2) * (solH2(2) - n - m) * (x - m)) , -K2 + ((3*m + n) * n)/((m - n) * (solH2(2) - n - m)) ,x,m,n,b,'Real',true);
B=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*16);
D=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*32);
disp ('REFORMAGE PRIMAIRE')
disp ('Flux entrant')
disp (['CH4',solx/1000000*16])
disp (['H2O',solH2(2)/1000000*18])
disp ('Flux sortant')
disp (['CH4',(solx-solm)/1000000*16])
disp (['H2O',(solH2(2)-solm-soln)/1000000*18])
disp (['CO',(solm-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp (['H2', (3*solm+soln)/1000000*2])
disp ('FOUR')
disp (['CH4', B])
disp (['O2', D])
disp ('REFORMAGE SECONDAIRE')
disp ('Flux entrant')
disp (['CH4',(solx-solm)/1000000*16])
disp (['H2O',(solH2(2)-solm+soln)/1000000*18])
disp (['CO',(solm-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp (['H2', (3*solm+soln)/1000000*2])
disp(['O2', 0.21*solb/1000000*32])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('Flux sortant')
disp (['H2O',(solH2(2)-solm+soln)/1000000*18])
disp (['CO',(solx-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp (['H2',(solm+soln)/1000000*2+2*solx])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('REACTEURS WATER GAS SHIFT')
disp ('Flux entrant')
disp (['CO',(solx-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp(['N2', 0.78*solb/1000000*28])
disp (['H2',(solm+soln+2*solx)/1000000*2])
disp(['Ar', 0.01*solb/1000000*40])
disp (['H2O',(solH2(2)-solm-soln)/1000000*18])
disp ('Flux sortant')
disp (['H2O',(solH2(2)-solm-solx)/1000000*18])
disp (['CO2',solx/1000000*44])
disp (['H2',(solm+3*solx)/1000000*2])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('ABSORPTION DE CO2 & COMPRESSION')
disp ('Flux entrant')
disp (['CO2',solx/1000000*44])
disp(['N2', 0.78*solb/1000000*28]) 
disp (['H2',(solm+3*solx)/1000000*2])
disp(['Ar', 0.01*solb/1000000*40])
disp (['H2O',(solH2(2)-solm-solx)/1000000*18])
disp ('Flux sortant')
disp (['H2',(solm+3*solx)/1000000*2])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('SYNTHESE DE NH3 & SEPARATION')
disp ('Flux entrant')
disp(['N2', 0.78*solb/1000000*28])
disp (['H2',(solm+3*solx)/1000000*2])
disp(['Ar', 0.01*solb/1000000*40])
disp ('Flux sortant')
disp(['Ar', 0.01*solb/1000000*40])
disp(['NH3', 1.56*solb/1000000*17])

end