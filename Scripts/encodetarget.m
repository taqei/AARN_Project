function [y]=encodetarget(x)
d=size(x,1);
    y=zeros(d,1);
    for i=1:d
        v=x(i,1);
        if(v>=0)&&(v<=3.4)
            y(i,1)=6;
        elseif (v>3.5) && (v<=9.4)
            y(i,1)=5;
        elseif (v>9.5) && (v<=13.4)
            y(i,1)=4;
        elseif (v>13.5) && (v<=15.4)
            y(i,1)=3;
        elseif (v>15.5) && (v<=17.4)
            y(i,1)=2;
        elseif (v>17.5) && (v<=20)
            y(i,1)=1;
        end
        
    end
end