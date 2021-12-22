clc;clear;close all;
format compact;
tic;
hold on;
%% 设定超参数
generations = 250;      % 迭代轮数
popnum = 500;           % 种群大小
poplength = 30;         % 个体长度

%%  初始化
minvalue=repmat(zeros(1,poplength),popnum,1);   %个体最小值
maxvalue=repmat(ones(1,poplength),popnum,1);    %个体最大值 
population=rand(popnum,poplength).*(maxvalue-minvalue)+minvalue;    %产生新的初始种群

%% 开始迭代进化
for epoch = 1:generations
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
    functionvalue = fitness(newpopulation);

    % 非直配排序
    frontvalue = NondominateSort(functionvalue);

    % 计算拥挤距离并选出下一代
    population = nextGenerate(newpopulation,frontvalue,functionvalue,popnum,poplength);
end

real_x = 0:0.01:1;
real_y = 1-real_x.^(1/2);
%% 结果可视化
fprintf('已完成,耗时%4s秒\n',num2str(toc));          %程序最终耗时
output=sortrows(functionvalue(frontvalue==1,:));    %最终结果:种群中非支配解的函数值
plot(output(:,1),output(:,2),'x',real_x,real_y,'r');                 %作图
axis([0,1,0,1]);xlabel('F_1');ylabel('F_2');title('ZDT1')
