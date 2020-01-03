function m = courbeLearn(sol,input,target)
t=size(input,2);
z=fix(t/100);
z=z+1;
m=zeros(z,2);
for i=1:z
    card=i*100;
    if card>t
        card=t;
    end
    in=input(:,1:card);
    te=target(:,1:card);
    [net,tr,h]=trainASol(sol,in,te,50,'a');
    o=output(net,input);
    e = calculateExactitude(o,target);
    m(i,1)=card;
    m(i,2)=e;
end
m=[[0,0];m];
plot(m(:,1),m(:,2));
xlabel('Sample Size')
ylabel('Accuracy')
end

