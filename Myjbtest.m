function [comment] = Myjbtest(wet)
%级比检验
new_wet=zeros(length(wet)-1,1);
for i=1:(length(wet)-1)
    new_wet(i)=wet(i)/(wet(i)+1);
end
%判定new_wet中所有元素在(exp(-2/(n+1)),exp(2/(n+1)));
n1=length(wet);
flag1=0;
for i=1:length(new_wet)
    if new_wet(i)>exp(-2/(n1+1))&&new_wet(i)<exp(2/(n1+1))
        flag1=flag1+1;
    end
end
if flag1==length(new_wet)
    comment='通过检验';
else
    comment='不通过检验';
end
end

