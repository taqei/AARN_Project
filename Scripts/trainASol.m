function [bestnet,besttr,besthsi] = trainASol(solution,input,target,n,f)
i=solution(1:3);
cs=solution(4:(3+solution(3)));
cs=num2str(cs,'%03.f');
i=num2str(i);
i= i(find(~isspace(i)));
i=strcat(i,cs);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
actfcts=["trainrp" "trainscg" "traincgp"];

fctActiv=char(actfcts(solution(1)));

trnsfcts=["logsig" "tansig" "purelin"];
fctTransfert=char(trnsfcts(solution(2)));

nbCouches=solution(3);
c1=solution(4);
c2=solution(5);
c3=solution(6);
c4=solution(7);


switch nbCouches
    case 1
        couches=c1;
    case 2
        couches=[c1,c2];
    case 3
       couches=[c1,c2,c3];
    case 4
       couches=[c1,c2,c3,c4];
    otherwise 
       couches=c1;
end



net=feedforwardnet(couches,fctActiv);



net.layers{nbCouches+1}.transferFcn=fctTransfert;
[bestnet,besttr,besthsi]=trainANet(net,input,target,n);

mkdir (f,['network',i]);
save([f,'/network',i,'/net',i,'.mat'],'bestnet');
save([f,'/network',i,'/tr',i,'.mat'],'besttr');
save([f,'/network',i,'/hsi',i,'.mat'],'besthsi');
network=decodeSolution(solution);
network(5,1)="Perf";
network(5,2)=besttr.best_perf;
a=input(:,besttr.valInd);
t=target(:,besttr.valInd);
y=bestnet(a);
Cyt= corrcoef(y,t);
R = Cyt(2,1) ;
network(6,1)="Reg";
network(6,2)=R;
network(7,1)="HSI";
network(7,2)=besthsi;
save([f,'/network',i,'/solution',i,'.mat'],'network');

end

function e=decodeSolution(s)
actfcts=["trainrp" "trainscg" "traincgp"];
trnsfcts=["logsig" "tansig" "purelin"];
e(1,1)="FctActiv";
e(1,2)=actfcts(s(1));
e(2,1)="FctTrns";
e(2,2)=trnsfcts(s(2));
e(3,1)="NombreCouches";
e(3,2)=s(3);
e(4,1)="Couches";

e(4,2)=num2str(s(4:(3+s(3))));
end

