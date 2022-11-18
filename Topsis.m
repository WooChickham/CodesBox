clc;clear;
bas=xlsread('AEXAM\data\数据x','mat','D5:H7');
wei=xlsread('AEXAM\data\数据x','U权重','D16:H16');
[row,col]=size(bas);


for n=1:col
    he=sum(bas(:,n));
    bas(:,n)=bas(:,n)./he;
end

%wjk Standardization
% Z = bas ./ repmat(sum(bas.*bas) .^ 0.5, row, 1);
% bas=Z;


bas=round(bas,4);

% Forward transformation
bas(:,3)=Tminus(bas(:,3));
Dplus=zeros(3,1); Dminus=zeros(3,1);

dmax=max(bas);dmin=min(bas);
d1=zeros(1,col);d2=zeros(1,col);
for m=1:row
    for n=1:col
    d1(n)=(bas(m,n)-dmax(n)).^2.*wei(n);
    d2(n)=(bas(m,n)-dmin(n)).^2.*wei(n);
    end
    Dplus(m)=sqrt(sum(d1));
    Dminus(m)=sqrt(sum(d2));
end


Si=Dminus./(Dminus+Dplus);
Si=Si/sum(Si);

% 
% for m=1:row
%     for n=1:col
%     d1(n)=(bas(m,n)-dmax(n)).^2;
%     d2(n)=(bas(m,n)-dmin(n)).^2;
%     end
%     Dplus(m)=sqrt(sum(d1));
%     Dminus(m)=sqrt(sum(d2));
% end
% 
% Si=zeros(3,1);
% Si=Dminus./(Dminus+Dplus);
% Si=Si/sum(Si);




