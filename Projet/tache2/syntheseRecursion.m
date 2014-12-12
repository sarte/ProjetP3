function  [NH3Pf] = SyntheseRecursion(N,H,A,T,p,Iv,It,Nit,x,y)
% SyntheseRecursion, calculates the molar flow of NH3 produced in function of the following parameters:
%
% N = molar flow of N2 entering the reactor [mol/day]
% H = molar flow of H2 entering the reactor [mol/day]
% A = molar flow of Ar entering the reactor [mol/day]
% T = temperature of the reactor [K]
% p = pressure in the reactor [bar]
% Iv = accumulator. 
% It = iterator. Must begin with 1.
% Nit = requested number of iterations
% x = x-axis vector for the plot
% y = y-axis vector for the plot
% Calls the function synthese, who calcuates the NH3 molar flow in function
% of the reagents, in function of the equilibrum constant. (not provided)

if It==Nit
    plot(x,y);
    NH3Pf=Iv; 
else
    newN = real(N-((10^6)*((synthese(N,H,A,T,p))/(2*17))));
    newH = real(H-(3*(10^6)*(synthese(N,H,A,T,p))/(2*17)));
    newIv=real(Iv+(synthese(N,H,A,T,p)));
    y(It)=Iv;
    x(It)=It;
    NH3Pf=syntheseRecursion(newN, newH,A,T,p,newIv,It+1,Nit,x,y);
end
end


