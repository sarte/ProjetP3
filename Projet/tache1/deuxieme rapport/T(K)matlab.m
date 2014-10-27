function [n] = K(deltaS, deltaH, T)
%K Calculates the equilibrum constant in fuction of the 
%temperature
R=8.31451; %universal gas constant
n = exp ((deltaS*T-deltaH*1000)/(R*T)); %definition of K(T)
end
---------------------------------------------------------------
function [n] = deltaH(vec1,vec2,vec3,vec4,coef,T,deltaHref)
%deltaS calculates the deltaH (in kJ) of a reaction in function of the temperature
%The reaction must involve 4 elements,and vec1,2,3,4 are associated to these elements.
%The vec1,2,3,4 must be vectors of order 4, and containing gas phase
%thermochemistry data (see nist.gov).
%coef is a 4-order vector containing the stoechiometric coefficients of the
%reaction.
%The temperature must be expressed in Kelvin.

elem1 = deltaHref(1)+Cp(vec1,T)-Cp(vec1,298.15); %deltaH of the first element
elem2 = deltaHref(2)+Cp(vec2,T)-Cp(vec2,298.15); %deltaH of the second element
elem3 = deltaHref(3)+Cp(vec3,T)-Cp(vec3,298.15); %deltaH of the third element
elem4 = deltaHref(4)+Cp(vec4,T)-Cp(vec4,298.15); %deltaH of the fourth element

n = coef*[-elem1 -elem2 elem3 elem4]';
end
---------------------------------------------------------------
function [n] = deltaS(vec1,vec2,vec3,vec4,coef,T)
%deltaS calculates the deltaS (in J) of a reaction in function of the temperature
%The reaction must involve 4 elements,and vec1,2,3,4 are associated to these elements.
%The vec1,2,3,4 must be vectors of order 6, and containing gas phase
%thermochemistry data (see nist.gov).
%coef is a 4-order vector containing the stoechiometric coefficients of the
%reaction.
%The temperature must be expressed in Kelvin.

elem1 = deltaSelem(vec1,T); %deltaS of the first element
elem2 = deltaSelem(vec2,T); %deltaS of the second element
elem3 = deltaSelem(vec3,T); %deltaS of the third element
elem4 = deltaSelem(vec4,T); %deltaS of the fourth element

n = coef*[-elem1 -elem2 elem3 elem4]'; %deltaS of the whole reaction
end
----------------------------------------------------------------
function [n] = Cp(vec,T)
%Cp calculates the integral of Cp from 298.15 to T
%from the expression A + B*t + C*t^2 + D*t^3 + E/t^2.
%vec1 must be a 6-order vector (A,B,C,D,E,G) associated to this element, and containing gas phase
%thermochemistry data (see nist.gov).
%The temperature must be expressed in Kelvin.
t = T./1000;
n = vec(1).*t + vec(2).*(t.^2)./2 + vec(3).*(t.^3)./3 + vec(4).*(t.^4)./4 - vec(5)./t;
end
----------------------------------------------------------------
function [n] = deltaSelem(vec, T)
%deltaSelem calculates the deltaS (in J) of an element in function of the temperature
%vec1 must be a 6-order vector (A,B,C,D,E,G) associated to this element, and containing gas phase
%thermochemistry data (see nist.gov).
%The temperature must be expressed in Kelvin.
%deltaSelem uses the following formula: 
%S° = A*log(t) + B*t + C*t2/2 +D*t3/3 ? E/(2*t2) + G.
t = T./1000;
n = vec(1).*log(t) + vec(2).*t + vec(3).*(t.^2)./2 + vec(4).*(t.^3)./3 - vec(5)./(2.*t.^2)+ vec(6);
end
----------------------------------------------------------------
function [Sol] = Findxymn(T,M)
% Findxymn calculates the amount of methane [T], water [T] and air [T] needed to produce M
% [T] of ammoniac, in fuction of the temperature [K]. Calculates also the amount of methane
% needed to supply the oven.
% x corresponds to the number of moles of methane needed per day.
% y corresponds to the number of moles of water needed per day.
% m represents the first stage of completion of the reaction 
% n represents the second stage of completion of the reaction 
% a corresponds to the number of moles of air needed per day.
% B corresponds to the number of moles of methane needed in the oven.


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
a = nummol/(2*0.78);

%resolution de l'eq
syms x y m n b positive 
[solx, soly, solm, soln, solb] = solve(x - m - 0.42*a == 0 , 3*x + m - 2.34*a == 0 , b == a, -K1/900 + (((3*m + n)^3) * (m - n))/(((x + 2*m + y)^2) * (y - n - m) * (x - m)) , -K2 + ((3*m + n) * n)/((m - n) * (y - n - m)) ,x,y,m,n,b,'Real',true);
B=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*16);
D=(abs((solm*deltaHH1+soln*deltaHH2)/DHfour)/1000000*32);

disp ('REFORMAGE PRIMAIRE')
disp ('Flux entrant')
disp (['CH4',solx/1000000*16])
disp (['H2O',soly/1000000*18])
disp ('Flux sortant')
disp (['CH4',(solx-solm)/1000000*16])
disp (['H2O',(soly-solm-soln)/1000000*18])
disp (['CO',(solm-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp (['H2', (3*solm+soln)/1000000*2])
disp ('FOUR')
disp (['CH4', B])
disp (['O2', D])
disp ('REFORMAGE SECONDAIRE')
disp ('Flux entrant')
disp (['CH4',(solx-solm)/1000000*16])
disp (['H2O',(soly-solm+soln)/1000000*18])
disp (['CO',(solm-soln)/1000000*28])
disp (['CO2',soln/1000000*44])
disp (['H2', (3*solm+soln)/1000000*2])
disp(['O2', 0.21*solb/1000000*32])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('Flux sortant')
disp (['H2O',(soly-solm+soln)/1000000*18])
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
disp (['H2O',(soly-solm-soln)/1000000*18])
disp ('Flux sortant')
disp (['H2O',(soly-solm)/1000000*18-solx])
disp (['CO2',solx/1000000*44])
disp (['H2',(solm+3*solx)/1000000*2])
disp(['N2', 0.78*solb/1000000*28])
disp(['Ar', 0.01*solb/1000000*40])
disp ('ABSORPTION DE CO2 & COMPRESSION')
disp ('Flux entrant')
disp (['CO2',solx/1000000*44])
disp(['N2', 0.78*solb/1000000*28]) %%%%
disp (['H2',(solm+3*solx)/1000000*2])
disp(['Ar', 0.01*solb/1000000*40])
disp (['H2O',(soly-solm-solx)/1000000*18])
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

--------------------------------------------------------------------------------------------
GUIDE D'UTILISATION DE L'OUTIL MATLAB

Rappelons tout d'abord que cet outil a été conçu dans le but d'avoir un aperçu des flux de matière 
lors de chaque étape du procédé de conception d'ammoniac.

Le fonction principale est "Findxymn", les autres sont des sous-fonctions appelées dans Findxymn.
Ce guide ne traite que la fonction principale. Pour plus d'informations sur les sous-fonctions, se
rapporter aux codes commentés.

Findxymn prend en arguments la température de sortie du reformage primaire, en Kelvin, ainsi que le 
flux final d'ammoniac voulu, en tonnes par jour. Cette fonction, lorsqu'elle est appelée, affiche
la valeur de chaque flux de matière à l'entrée et à la sortie de chaque "bloc".
Toutes les données de sortie sont exprimées en tonnes par jour.

