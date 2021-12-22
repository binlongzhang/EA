clc;
clear;
close all;

dataName = 'DLBCL';
load(['data/' dataName])
featureNum = size(dataX,2);
%% 超参数设置
N = min(ceil(featureNum/20),300);       % 初始种群个数
dim = featureNum;                       % 空间维数
epoches = 100;                          % 最大迭代次数     
limit = [0, 1];                         % 设置位置参数限制
vlimit = [-0.6, 0.6];                   % 设置速度限制
w = 0.8;                                % 惯性权重
c1 = 1.49445;                           % 自我学习因子
c2 = 1.49445;                           % 群体学习因子
threshold = 0.6;
%% 种群初始化

% 随机分布
x = rand(N, dim);                   % 初始种群的位置
v = rand(N, dim);                   % 初始种群的速度,随机产生
fx = zeros(N,1);                    % 种群适应度
xMax = x;                           % 每个个体的历史最佳位置
gBestX = zeros(1, dim);             % 种群的历史最佳位置
fitnessXMax = zeros(N, 1);          % 每个个体的历史最佳适应度
gBestFitness = -inf;                % 种群历史最佳适应度
tic
%% 群体更新
recordTime = zeros(epoches, 1);     % 记录时间 
record = zeros(epoches, 1);         % 记录器，用于记录收敛情况
for iter =1:epoches
     index = x > threshold;
     for i = 1:N
        Mdl = fitcknn(dataX(:,index(i,:)),dataY,NumNeighbors=10);
        CVMdl = crossval(Mdl,KFold=10);
        fx(i) = 1-kfoldLoss(CVMdl);
     end
     for i = 1:N      
        if fitnessXMax(i) < fx(i)
            fitnessXMax(i) = fx(i);     % 更新个体历史最佳适应度
            xMax(i,:) = x(i,:);         % 更新个体历史最佳位置
        end 
     end
     
    if gBestFitness < max(fitnessXMax)
            [gBestFitness, nmax] = max(fitnessXMax);   % 更新群体历史最佳适应度
            gBestX = xMax(nmax, :);      % 更新群体历史最佳位置
    end
    % 速度更新，新速度 = 原始速度 + 个体自学习 + 群体学习
    v = v * w + c1 * rand * (xMax - x) + c2 * rand * (repmat(gBestX, N, 1) - x);% 速度更新
    
    % 边界速度处理
    v(v > vlimit(2)) = vlimit(2);
    v(v < vlimit(1)) = vlimit(1);
    x = x + v;% 位置更新
    % 边界位置处理
    x(x > limit(2)) = limit(2);
    x(x < limit(1)) = limit(1);
    
    record(iter) = gBestFitness;%最大值记录
    recordTime(iter) = toc;
    % 种群动态调整可视化
    disp(['iter == ' num2str(iter) '   |  gBestFitness == ' num2str(gBestFitness) '   |  time == ' num2str(toc)])
    if(gBestFitness == 1)
        break;
    end
end

%% 结果可视化
plot(record);
title('收敛过程')



