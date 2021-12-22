clc;clear;close all;
format compact;
tic;
% hold on;

%% 加载数据
data = load('wine.data');
disp('原始数据分类分布')
tabulate(data(:,1));
[train,test] = divideData(data,0.7);
disp('训练数据分类分布')
tabulate(train(:,1))
disp('测试数据分类分布')
tabulate(test(:,1))
%% 设定超参数
generations = 100;                   % 迭代轮数
popnum = 30;                         % 种群大小
poplength = 13;                      % 个体长度
theta = 0.6;
neighborNum = 5;                     % 邻居数量
kFold = 10;                          % k折交叉验证
%%  初始化
minvalue=repmat(zeros(1,poplength),popnum,1);   %个体最小值
maxvalue=repmat(ones(1,poplength),popnum,1);    %个体最大值 
population=rand(popnum,poplength).*(maxvalue-minvalue)+minvalue;    %产生新的初始种群

%% 开始迭代进化
for epoch = 1:generations
    disp(['iter == '  int2str(epoch)]);

    % 算术交叉-正态交叉
    newpopulation = SBXCross(population);
    % 变异操作-多项式变异
    newpopulation = PloyMutation(newpopulation);

    %检查越界操作
    % 子代越上届
    newpopulation(newpopulation>maxvalue) = maxvalue(newpopulation>maxvalue);
    % 子代越下届
    newpopulation(newpopulation<minvalue) = minvalue(newpopulation<minvalue); 
    % 合并子代和父代
    newpopulation=[population;newpopulation];

    % 计算目标函数的值
    functionvalue = fitness(train(:,2:end),train(:,1),newpopulation,theta,neighborNum,kFold);

    % 非直配排序
    frontvalue = NondominateSort(functionvalue);

    % 计算拥挤距离并选出下一代
    population = nextGenerate(newpopulation,frontvalue,functionvalue,popnum,poplength);
end

functionvalue = fitness(train(:,2:end),train(:,1),population,theta,neighborNum,kFold);
solutionIndex = nondominateSolution(functionvalue);
solution = population(solutionIndex,:);
solutionFlag = solution > theta;
[solutionFlag,solutionIndex] = unique(solutionFlag,'row');
solution = solution(solutionIndex,:);

[solutionNum,solutionTrainErr,solutionTestErr] = calResult(train,test,solution,theta,neighborNum,kFold);


