clc
clear
%% 超参数
% SRBCT DLBCL 9Tumor Leukemia1
dataName = 'Leukemia1';
load(['data1/' dataName])
dataX = data;
dataY = label;

SUDivideNum = 10;
featureNum = size(dataX,2);
popSize = min(ceil(featureNum/20),300);
c1 = 1.49445;
c2 = 1.49445;
maxIters = 100;
alpha = 7;
beta = 9;
lambda = 0.9;
vMin = -0.6;
vMax = 0.6;
fitnessFun = @fitnessKfold;

%% 初始化filter
%基于SU排序
su = zeros(1,size(dataX,2));
for i = 1:size(dataX,2)
   su(i) = SU(dataX(:,i),dataY,SUDivideNum);
end
[~,dataIndex] = sort(su,'des');
dataX = dataX(:,dataIndex);

%% 装载训练好的种群
load(['result/' dataName])
full = zeros(size(swarms));
result = zeros(2,size(swarms,2));
for i = 1:size(swarms,2)
    full(i) = balanceAcc(dataX,dataY);
    index = swarms{i}.gBest.pos > swarms{i}.threshold;
    result(1,i) = sum(index);
    result(2,i) = balanceAcc(dataX(:,index),dataY);
end
resultSize = mean(result(1,:))
reultBestAcc = max(result(2,:))
resultAccMean = mean(result(2,:))
resultAccSTD = std(result(2,:))
resultFullMax = max(full)