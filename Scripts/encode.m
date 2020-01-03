function [input,target] = encode(mat)
input=horzcat(encodeschool(mat(:,1)),...
        encodegender(mat(:,2)),...
        cellfun(@str2num,(mat(:,3))),...
        encodeadresse(mat(:,4)),...
        encodefamsize(mat(:,5)),...
        encodepstatus(mat(:,6)),...
        cellfun(@str2num,(mat(:,7))),...
        cellfun(@str2num,(mat(:,8))),...
        encodejob(mat(:,9)),...
        encodejob(mat(:,10)),...
        encodereason(mat(:,11)),...
        encodeguard(mat(:,12)),...
        cellfun(@str2num,(mat(:,13))),...
        cellfun(@str2num,(mat(:,14))),...
        cellfun(@str2num,(mat(:,15))),...
        encodeyesno(mat(:,16)),...
        encodeyesno(mat(:,17)),...
        encodeyesno(mat(:,18)),...
        encodeyesno(mat(:,19)),...
        encodeyesno(mat(:,20)),...
        encodeyesno(mat(:,21)),...
        encodeyesno(mat(:,22)),...
        encodeyesno(mat(:,23)),...
        cellfun(@str2num,(mat(:,24))),...
        cellfun(@str2num,(mat(:,25))),...
        cellfun(@str2num,(mat(:,26))),...
        cellfun(@str2num,(mat(:,27))),...
        cellfun(@str2num,(mat(:,28))),...
        cellfun(@str2num,(mat(:,29))),...
        encodebinary(mat(:,30)),...
        encodeOneHot(mat(:,31)),...
        encodeOneHot(mat(:,32))...
       );
        
target=encodeTarget(mat(:,33));
input=input';
target=target';
end

function [y] = encodegender(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="M"
            y(i,1)=1;
        else
            y(i,1)=2;
        end
    end   
end

function [y]=encodeyesno(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="yes"
            y(i,1)=1;
        else
            y(i,1)=0;
        end
    end
end

function [y]=encodeschool(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="GP"
            y(i,1)=1;
        else
            y(i,1)=2;
        end
    end
end

function [y]=encodeadresse(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="U"
            y(i,1)=1;
        else
            y(i,1)=2;
        end
    end
end
function [y]=encodefamsize(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="LE3"
            y(i,1)=1;
        else
            y(i,1)=2;
        end
    end
end
function [y]=encodepstatus(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="T"
            y(i,1)=1;
        else
            y(i,1)=0;
        end
    end
end

function [y]=encodejob(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="teacher"
            y(i,1)=1;
        elseif x(i,1)=="health"
            y(i,1)=2;
        elseif x(i,1)=="services"
            y(i,1)=3;
        elseif x(i,1)=="at_home"
            y(i,1)=4;
        else
            y(i,1)=5;
        end
    end
end

function [y]=encodereason(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="home"
            y(i,1)=1;
        elseif x(i,1)=="reputation"
            y(i,1)=2;
        elseif x(i,1)=="course"
            y(i,1)=3;
        else
            y(i,1)=4;
        end
    end
end
function [y]=encodeguard(x)
    d=size(x,1);
    for i=1:d
        if x(i,1)=="mother"
            y(i,1)=1;
        elseif x(i,1)=="father"
            y(i,1)=2;
        else
            y(i,1)=3;
        end
    end
end

function [y]=encodebinary(x)
    x=cellfun(@str2num,x);
    d=size(x,1);
    y=zeros(d,7);
    for i=1:d
        a=dec2bin(x(i,1),7);
        y(i,1)=str2num(a(1));
        y(i,2)=str2num(a(2));
        y(i,3)=str2num(a(3));
        y(i,4)=str2num(a(4));
        y(i,5)=str2num(a(5));
        y(i,6)=str2num(a(6));
        y(i,7)=str2num(a(7));
    end
end

function [y]=encodeOneHot(x)
    x=cellfun(@str2num,x);
    d=size(x,1);
    y=zeros(d,21);
    %%y=y*0.1;
    for i=1:d
        y(i,21-x(i,1))=1;
    end
end

function [y]=encodeTarget(x)
    x=cellfun(@str2num,x);
    d=size(x,1);
    y=zeros(d,6);
    for i=1:d
        v=x(i,1);
        if(v>=0)&&(v<=3.4)
            y(i,6)=1;
        elseif (v>3.5) && (v<=9.4)
            y(i,5)=1;
        elseif (v>9.5) && (v<=13.4)
            y(i,4)=1;
        elseif (v>13.5) && (v<=15.4)
            y(i,3)=1;
        elseif (v>15.5) && (v<=17.4)
            y(i,2)=1;
        elseif (v>17.5) && (v<=20)
            y(i,1)=1;
        end
        
    end
end


