clc;clear;
%%
bitpath='E:\竞赛\数学建模大赛\2022MCM&ICM\2022_Problem_C_DATA\第一问比特币计算过程数据.xlsx';
bitcoin=xlsread(bitpath,'比特币','A2:D1825');
bit_value=bitcoin(:,1); weight=0.98;
[brow,bcol]=size(bitcoin);
moneyforbit=1;bitcoin_num=moneyforbit/610.92; total_money=999;total_invest=1;
profit=0;
%%
for i=1:brow-1
    if bit_value(i+1)-bit_value(i)>0
        profit=bit_value(i)*bitcoin_num*weight;
        moneyforbit=1;
        total_money=total_money+profit-moneyforbit-total_invest;
        bitcoin_num=moneyforbit/bit_value(i);
        total_invest=moneyforbit;
        
    end
    if bit_value(i+1)-bit_value(i)<0
        moneyforbit=moneyforbit*2;
        total_invest=moneyforbit;
        bitcoin_num=bitcoin_num+moneyforbit/bit_value(i);
    end
   
end
if bitcoin_num>0
    total_money=total_money+bit_value(end)*bitcoin_num*weight-total_invest;
    bitcoin_num=0;
    total_invest=0;
end

