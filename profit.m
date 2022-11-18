% 根据bitcoin和gold的买入买出表来计算所获得的利润
%% 数据导入
clc;clear;
bitpath='E:\竞赛\数学建模大赛\2022MCM&ICM\2022_Problem_C_DATA\第一问比特币计算过程数据.xlsx';
goldpath='E:\竞赛\数学建模大赛\2022MCM&ICM\2022_Problem_C_DATA\第一问金子计算过程数据.xlsx';
bitcoin=xlsread(bitpath,'比特币','A2:D1825');
gold=xlsread(goldpath,'金子','A2:D1253');
bit_value=bitcoin(:,1);gold_value=gold(:,1);
bitchance1=bitcoin(:,2); bitchance2=bitcoin(:,3);
goldchance1=gold(:,2);goldchance2=gold(:,3);
moneyforgold_20=0;moenyforbit_20=900;bit_num_20=0; gold_num_20=0;
moneyforgold_45=0;moenyforbit_45=900;bit_num_45=0; gold_num_45=0;
[brow,bcol]=size(bitcoin);[grow,gcol]=size(gold);

%% 比特币的chance1计算

for i=1:brow-1
    if bitchance1(i+1)-bitchance1(i)==0     % 保持原状态，则无事发生
    end
    if bitchance1(i+1)-bitchance1(i)==1     % 0变1，买入
        bit_num_20=moenyforbit_20*0.98/bit_value(i);
        moenyforbit_20=0;
    end
    if bitchance1(i+1)-bitchance1(i)==-1    % 1变0，买出
        moenyforbit_20=bit_num_20*bit_value(i)*0.98;
        bit_num_20=0;
    end
end
if bit_num_20~=0
    moenyforbit_20=bit_num_20*bit_value(end)*0.98;
    bit_num_20=0;
end

%% 黄金的chance1计算
for i=1:grow-1
    if goldchance1(i+1)-goldchance1(i)==0     % 保持原状态，则无事发生
    end
    if goldchance1(i+1)-goldchance1(i)==1     % 0变1，买入
        gold_num_20=moneyforgold_20*0.98/gold_value(i);
        moneyforgold_20=0;
    end
    if goldchance1(i+1)-goldchance1(i)==-1    % 1变0，买出
        moneyforgold_20=gold_num_20*gold_value(i)*0.98;
        gold_num_20=0;
    end
end
if gold_num_20~=0
    moneyforgold_20=gold_num_20*gold_value(end)*0.98;
    gold_num_20=0;
end
%% 比特币的chance2计算
for i=1:brow-1
    if bitchance2(i+1)-bitchance2(i)==0     % 保持原状态，则无事发生
    end
    if bitchance2(i+1)-bitchance2(i)==1     % 0变1，买入
        bit_num_45=moenyforbit_45*0.98/bit_value(i);
        moenyforbit_45=0;
    end
    if bitchance2(i+1)-bitchance2(i)==-1    % 1变0，买出
        moenyforbit_45=bit_num_45*bit_value(i)*0.98;
        bit_num_45=0;
    end
end
if bit_num_45~=0
    moenyforbit_45=bit_num_45*bit_value(end)*0.98;
    bit_num_45=0;
end
%% 黄金的chance2计算
for i=1:grow-1
    if goldchance2(i+1)-goldchance2(i)==0     % 保持原状态，则无事发生
    end
    if goldchance2(i+1)-goldchance2(i)==1     % 0变1，买入
        gold_num_45=moneyforgold_45*0.98/gold_value(i);
        moneyforgold_45=0;
    end
    if goldchance2(i+1)-goldchance2(i)==-1    % 1变0，买出
        moneyforgold_45=gold_num_45*gold_value(i)*0.98;
        gold_num_45=0;
    end
end
if gold_num_45~=0
    moneyforgold_45=gold_num_45*gold_value(end)*0.98;
    gold_num_45=0;
end
%%
disp('运行完毕！！！')

