tic;
x=linspace(275.15,2000);
y=zeros(1,100);
for p=1:5
for i=1:length(x);
    y(i)=(synthese(44037343.66743,132112031.00229,564581.329,x(i),50+(p*20)))/1497;
end
hold on;
if(p==1)
    plot(x,y,'r','MarkerSize',8);
elseif (p==2)
    plot(x,y,'b','MarkerSize',8);
elseif (p==3)
    plot(x,y,'g','MarkerSize',8);
elseif (p==4)
    plot(x,y,'c','MarkerSize',8);
elseif (p==5)
    plot(x,y,'m','MarkerSize',8);
end
xlabel('Température[K]');
ylabel('Rendement NH3 produit (t)');
title('Ammoniac produit en fonction de la température')
legend('P=70[bars]','P=90[bars]','P=110[bars]','P=130[bars]','P=150[bars]');
%ylim([500 1500]);
end
toc


