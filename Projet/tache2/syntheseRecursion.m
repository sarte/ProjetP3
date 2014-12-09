function  [NH3Pf] = syntheseRecursion(N,H,A,T,p,NH3P,Iv,It,Nit,x,y)
if It==Nit
    plot(x,y);
    NH3Pf=Iv; 
else
    newN = real(N-((10^6)*((synthese(N,H,A,T,p))/(2*17))));
    newH = real(H-(3*(10^6)*(synthese(N,H,A,T,p))/(2*17)));
    newIv=real(Iv+(synthese(N,H,A,T,p)));
    y(It)=Iv;
    x(It)=It;
    NH3Pf=syntheseRe(newN, newH,A,T,p,NH3P,newIv,It+1,Nit,x,y);
end
end

