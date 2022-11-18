clc;clear;
%% 主函数
%   求出供货商的违约率和守约率



load comp_data;
load prov_data;




% 对于每个供应商，找出企业有订货但供应商无供货的次数；


% 得出订货量中为0的位置
[r1,c1]=find(comp_data==0);
index_company=[r1,c1];
% 得出供货量中0的位置
[r2,c2]=find(prov_data==0);

index_provider=[r2,c2];
[row_len,col_len]=size(index_provider);
flag=1;
for i=1:row_len
    flag_index=index_provider(i,:);    %   取出index_provider的i行数据
    %   判断对应位置的订货量是不是0,如果不是，证明失信，记录不是0的数据
    if comp_data(flag_index(1),flag_index(2))~=0
        recorder(flag,:)=flag_index;   
        flag=flag+1;
    end
    
end
%   recorder记录的是违约的位置
final_rec=recorder(:,1);
for j=1:402
    res(j)=length(find(final_rec==j));
end
res=res';   %   每个供货商违约的次数

%   下面求企业对下单了多少次

for x=1:402
    num_order(x)=length(find(comp_data(x,:)~=0));
end
num_order=num_order';
default_rate=res./num_order;    %违约率
promise_rate=1.-default_rate;   %守约率




