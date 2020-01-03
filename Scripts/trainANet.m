function [bestnet,besttr,besthsi] = trainANet(net,input,target,n)
%cette fonction fais N train a partir d'une architecture net
net=init(net);
[ne,tr]=train(net,input,target);
bestn=ne;
bestt=tr;

%besthsi=1-tr.best_perf;
besthsi=1-(tr.best_perf+(2*abs(tr.best_perf-tr.best_tperf)));
%besthsi=1/(tr.best_vperf*(abs(tr.best_vperf-tr.best_tperf)));
for i=1:(n-1)
    net=init(net);
    [ne,tr]=train(net,input,target);
   
    hsi=1-(tr.best_perf+(2*abs(tr.best_perf-tr.best_tperf)));
   
    if(besthsi<hsi)
       
       bestn=ne;
       bestt=tr;
       besthsi=hsi;
       
    end
end
bestnet=bestn;
besttr=bestt;

end


