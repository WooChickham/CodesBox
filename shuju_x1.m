clc;clear;

tot=xlsread('data\第二问.xlsx','Sheet1','K5:K19');
time=xlsread('data\第二问.xlsx','Sheet1','I5:I19');
wet=tot.*0.5578;
paper=tot.*0.1544;
plastic=tot.*0.1262;
oth=tot.*0.1616;
x0=wet;

% jibitest=Myjbtest(x0);                 %自定义函数 

new_x0=zeros(length(x0)-1,1);
for i=1:(length(x0)-1)
    new_x0(i)=x0(i)/(x0(i)+1);
end



x1=zeros(length(x0),1);
for i=1:length(x0)
    x1(i)=sum(x0(1:i,1));
end

z1=zeros(length(x0)-1,1);
for i=1:(length(x0)-1)
    z1(i)=1/2*(x1(i)+x1(i+1));
end
y=x0(2:end,1);
sig1=ones(length(y),1);
b=[-z1,sig1];

u=(b'*b)^(-1)*b'*y;
a_bar=u(1);b_bar=u(2);

PredVal_future1=zeros(15,1);
for k=1:length(PredVal_future1)-1
    PredVal_future1(k+1)=(x0(1)-b_bar/a_bar)*exp(-a_bar*k)+b_bar/a_bar;
end

PredVal_f2=zeros(15,1);
for k=2:14
    PredVal_f2(k+1)=PredVal_future1(k+1)-PredVal_future1(k);
end

%残差检验
emu=zeros(15,1);
for k=1:15
    emu(k)=abs((x0(k)-PredVal_f2(k))/x0(k));
end
%已证明通过残差检验


f1=zeros(38,1);
f2=f1;
f1(1:15,1)=PredVal_future1;
f2(1:15,1)=PredVal_f2;

for k=14:37
    f1(k+1)=(x0(1)-b_bar/a_bar)*exp(-a_bar*k)+b_bar/a_bar;
end
for k=14:37
    f2(k+1)=f1(k+1)-f1(k);
end

%f2为输出的最后结果