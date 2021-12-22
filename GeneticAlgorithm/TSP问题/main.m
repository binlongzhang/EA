clear;
clc;
close all;
% origin变量用于存储原始生成的路线，population为最后进化epoches代之后的种群
%% 超参数
county_size = 20;
countys_size = 40; %初试的种群数
epoches = 200;
m = 2;      % 适应值归一化淘汰加速指数
cross_rate = 0.4;
mutation_rate = 0.02;
%% 生成测试数据
% 生成城市坐标
position = randn(county_size, 2);
% 生成城市之间的距离矩阵
distance = zeros(county_size, county_size);
for i = 1:county_size
    for j = i+1:county_size
        dis = (position(i, 1) - position(j, 1))^2 + (position(i, 2) - position(j, 2))^2;
        distance(i, j) = dis^0.5;
        distance(j, i) = distance(i, j);
    end
end
%% 生成初始种群
population = zeros(countys_size, county_size);
for i = 1: countys_size
    population(i, :) = randperm(county_size);
end
% 用于保存原始数据
origin = population;
%% 初始化种群对应的长度及其自适应函数
fitness = zeros(countys_size,1);
len = zeros(countys_size,1);
for i = 1: countys_size
    len(i, 1) = myLength(distance, population(i, :));
end
maxlen = max(len);
minlen = min(len);
fitness = fit(len, m, maxlen, minlen);
%% 查询初始种群的最短路径
rr = find(len == minlen);  % 调试查询结果
pop = population(rr(1, 1), :);
fprintf('初试最短路径为%d \n路径为', minlen);
for i = 1: county_size
    fprintf('%d  ', pop(i));
end
fprintf('\n');

%% 绘制示意图像
figure(1);
scatter(position(:, 1), position(:, 2), 'k.');
xlabel('x');
ylabel('y');
title('随机城市分布情况');
axis([-3, 3, -3, 3]);
figure(2);
plot_route(position, pop);
xlabel('x');
ylabel('y');
title('初始种群最短TSP路径');
axis([-3, 3, -3, 3]);
%% 初始化存储变量
fitness = fitness/sum(fitness);  % 适应度
distance_min = zeros(epoches + 1, 1);  % 每个cpoch的最小值路径
population_sel = zeros(countys_size + 1, county_size); % 每次最优种群

%% 开始繁衍
for epoch = 1:epoches+1
    p_fitness = cumsum(fitness);
    nn = 0;
    for i = 1:size(population,1)
        len_1(i,1) = myLength(distance,population(i,:));
        jc = rand;
        for j = 1:size(population,1)
            if p_fitness(j,1) > jc
                nn = nn+1;
                population_sel(nn,:) = population(j,:);
                break;
            end
        end
    end
    
    % 保存选择之后的最优物种，增加收敛速率
    population_sel = population_sel(1:nn, :);
    [len_m, len_index_min] = min(len_1);
    [len_max, len_index_max] = max(len_1);
    population_sel(len_index_max, :) = population_sel(len_index_min, :);%淘汰最劣物种
    
    % 交叉操作
    rand_rank = randperm(nn);
    A = population_sel(rand_rank(1), :);
    B = population_sel(rand_rank(2), :);
    for i = 1 : nn * cross_rate
        [A, B] = cross(A, B);
        population_sel(rand_rank(1), :) = A;
        population_sel(rand_rank(2), :) = B;
    end
    
    % 变异操作
    for i = 1: nn
        pick = rand;
        if pick <= mutation_rate
            population_sel(i, :) = mutation(population_sel(i, :));
        end
    end
    
    % 随机逆转部分基因片段，若更优则更新，可以理解为基因重组
    for i = 1: nn
        population_sel(i,:) = reverse(population_sel(i,:), distance);
    end
    
    %适应度函数更新
    NN = size(population_sel,1);
    len = zeros(NN,1);
    for i = 1: NN
        len(i, 1) = myLength(distance, population_sel(i, :));
    end
    maxlen = max(len);
    minlen = min(len);
    distance_min(epoch, 1) = minlen;
    fitness = fit(len, m, maxlen, minlen);
    
    % 显示结果
    if mod(epoch,50)==0
        disp('*****************************************************************')
        fprintf('迭代轮数： %d\n', epoch);
        rr = find(len == minlen);  
        fprintf('minlen： %d\n', minlen);
        disp('路径为：')
        disp(population_sel(rr(1, 1), :))
    end
    
    population = population_sel;

end

%% 展示最终优化后的结果
rr = find(len == minlen);
figure(3);
plot_route(position, population(rr(1, 1),:));
xlabel('x');
ylabel('y');
title('优化过后最短TSP路径');
axis([-3, 3, -3, 3]);   




