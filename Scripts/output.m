function [out] = output(net,input)
%Cette fonction ameliore le resultat d'une prediction
%=> retourne la classe dont la prob est max (softmax)
    a=net(input);
    card=size(a,2);
    out=zeros(6,card);
    for j=1:card
        for i=1:6
            a(i,j)=a(i,j)/sum(abs(a(:,j)));
        end
        [m,indMax]=max(a(:,j));
        out(indMax,j)=1;
    end
    
end

