clc;
clear;
close all;
%% 设置fitness函数
fit= @(x)x .* sin(x) .* cos(2 * x) - 2 * x .* sin(3 * x); % 函数表达式
figure(1);
fplot(fit,[0,20]);
%% 超参数设置
N = 50;                         % 初始种群个数
dim = 1;                        % 空间维数
epoches = 100;                  % 最大迭代次数     
limit = [0, 20];                % 设置位置参数限制
vlimit = [-1, 1];               % 设置速度限制
w = 0.8;                        % 惯性权重
c1 = 0.5;                       % 自我学习因子
c2 = 0.5;                       % 群体学习因子 
%% 种群初始化
for i = 1:dim
    % 随机分布
    x = limit(i, 1) + (limit(i, 2) - limit(i, 1)) * rand(N, dim);%初始种群的位置
end

v = rand(N, dim);                  % 初始种群的速度,随机产生
xMax = x;                          % 每个个体的历史最佳位置
gBestX = zeros(1, dim);              % 种群的历史最佳位置
fitnessXMax = zeros(N, 1);         % 每个个体的历史最佳适应度
gBestFitness = -inf;                % 种群历史最佳适应度
hold on
plot(x, fit(x), 'ro');title('初始状态图');
figure(2)
%% 群体更新
record = zeros(epoches, 1);          % 记录器，用于记录收敛情况
for iter =1:epoches
     fx = fit(x) ; % 个体当前适应度   
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
    % 种群动态调整可视化
     x0 = 0 : 0.01 : 20;
     plot(x0, fit(x0), 'b-', x, fit(x), 'ro');title('状态位置变化')
     pause(0.1)
end

%% 结果可视化
figure(3);
plot(record);
title('收敛过程')

x0 = 0 : 0.01 : 20;
figure(4);
plot(x0, fit(x0), 'b-', x, fit(x), 'ro');title('最终状态位置')

disp(['最大值：',num2str(gBestFitness)]);
disp(['变量取值：',num2str(gBestX)]);

