clc;clear;
%% 主函数




% C:\Users\Chiefham\Desktop
A_data=xlsread('C:\Users\Chiefham\Desktop\abc分类原始数据','Sheet1','D2:II147');
B_data=xlsread('C:\Users\Chiefham\Desktop\abc分类原始数据','Sheet2','D2:II135');
C_data=xlsread('C:\Users\Chiefham\Desktop\abc分类原始数据','Sheet3','D2:II123');

%%   找出A，B，C类板材各个供货商的最大供货量
% 找出A中每个供货商的最大供货量

[r1,c1]=size(A_data);
for i=1:r1
    a_res(i)=max(A_data(i,:));
end
%   找B的
[r2,c2]=size(B_data);
for j=1:r2
    b_res(j)=max(B_data(j,:));
end

% 找C的

[r3,c3]=size(C_data);
for k=1:r3
    c_res(k)=max(C_data(k,:));
end
a_res=a_res';
b_res=b_res';
c_res=c_res';


%%  求ABC板材的各个供货商的供货平均数
% [r1,c1]=size(A_data);[r2,c2]=size(B_data);[r3,c3]=size(C_data);
% for i=1:r1
%     a_mean(i)=sum(A_data(i,:))/length(find(A_data(i,:)~=0));
% end
% for j=1:r2
%     b_mean(j)=sum(B_data(j,:))/length(find(B_data(j,:)~=0));
% end
% 
% for k=1:r3
%     c_mean(k)=sum(C_data(k,:))/length(find(C_data(k,:)~=0));
% end
% 
% a_mean=a_mean';
% b_mean=b_mean';
% c_mean=c_mean';

%% 求ABC板材每周的供货商的数量

% [r1,c1]=size(A_data);[r2,c2]=size(B_data);[r3,c3]=size(C_data);
% 
% for i=1:c1
%     d1=A_data(:,i);  % 取出第i列的数据
%     a_week_non_0(i)=length(find(d1>0));
%     a_week_above_10(i)=length(find(d1>=10));
% end
% 
% for j=1:c2
%     d2=B_data(:,j);  % 取出第i列的数据
%     b_week_non_0(j)=length(find(d2>0));
%     b_week_above_10(j)=length(find(d2>=10));
% end
% 
% 
% for k=1:c3
%     d3=C_data(:,k);  % 取出第i列的数据
%     c_week_non_0(k)=length(find(d3>0));
%     c_week_above_10(k)=length(find(d3>=10));
% end
% 
% tot_non_0=a_week_non_0+b_week_non_0+c_week_non_0;
% tot_above_10=a_week_above_10+b_week_above_10+c_week_above_10;

%%  求ABC供货商剔除异常值之后的平均值


% % A_data,B_data,C_data
% 
% [r1,c1]=size(A_data);[r2,c2]=size(B_data);[r3,c3]=size(C_data);
% res1=zeros(1,240);res2=zeros(1,240);res3=zeros(1,240);
% for i=1:r1
%     
%     tar1=A_data(i,:);
%     tar1(tar1==0)=[];
%     min_mid1=sort(tar1);
%     min1=min_mid1(1,1:5);
%     tar1(tar1==min1(1))=[];tar1(tar1==min1(2))=[];tar1(tar1==min1(3))=[];tar1(tar1==min1(4))=[];
%     tar1(tar1==min1(5))=[];
%     max_mid1=sort(tar1,'descend');
%     max1=max_mid1(1:5);
%     tar1(tar1==max1(1))=[];tar1(tar1==max1(2))=[];tar1(tar1==max1(3))=[];tar1(tar1==max1(4))=[];
%     tar1(tar1==max1(5))=[];
%     res1(i,1:length(tar1))=tar1;
% end
% 
% 
% for j=1:r2
%     
%     tar2=B_data(j,:);
%     tar2(tar2==0)=[];
%     min_mid2=sort(tar2);
%     min2=min_mid2(1,1:5);
%     tar2(tar2==min2(1))=[];tar2(tar2==min2(2))=[];tar2(tar2==min2(3))=[];tar2(tar2==min2(4))=[];
%     tar2(tar2==min2(5))=[];
%     max_mid2=sort(tar2,'descend');
%     max2=max_mid2(1:5);
%     tar2(tar2==max2(1))=[];tar2(tar2==max2(2))=[];tar2(tar2==max2(3))=[];tar2(tar2==max2(4))=[];
%     tar2(tar2==max2(5))=[];
%     res2(j,1:length(tar2))=tar2;
% end
% 
% 
% 
% 
% for k=1:r3
%     
%     tar3=C_data(k,:);
%     tar3(tar3==0)=[];
%     min_mid3=sort(tar3);
%     min3=min_mid3(1,1:5);
%     tar3(tar3==min3(1))=[];tar3(tar3==min3(2))=[];tar3(tar3==min3(3))=[];tar3(tar3==min3(4))=[];
%     tar3(tar3==min3(5))=[];
%     max_mid3=sort(tar3,'descend');
%     max3=max_mid3(1:5);
%     tar3(tar3==max3(1))=[];tar3(tar3==max3(2))=[];tar3(tar3==max3(3))=[];tar3(tar3==max3(4))=[];
%     tar3(tar3==max3(5))=[];
%     res3(k,1:length(tar3))=tar3;
% end
% 




















