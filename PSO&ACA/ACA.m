clc;
clear;
close all;
%% 数据初始化
citys= [[1304,2312];[3639,1315];[4177,2244];[3712,1399];[3488,1535];[3326,1556];[3238,1229];[4196,1004];[4312,790];[4386,570];[3007,1970];[2562,1756];[2788,1491];[2381,1676];[1332,695];[3715,1678];[3918,2179];[4061,2370];[3780,2212];[3676,2578];[4029,2838];[4263,2931];[3429,1908];[3507,2367];[3394,2643];[3439,3201];[2935,3240];[3140,3550];[2545,2357];[2778,2826];[2370,2975]];

% 初始化距离矩阵
cityNum = size(citys,1);
Dis = zeros(cityNum,cityNum);  
for i = 1:cityNum
    for j = 1:cityNum
        if i ~= j
            Dis(i,j) = sqrt(((citys(i,1) - citys(j,1))^2)+((citys(i,2) - citys(j,2))^2));
        else
            Dis(i,j) = 0;
        end
    end
end

%% 初始化参数
popNum = 50;                            % 蚂蚁数量
alpha = 1;                              % 信息素重要程度因子
beta = 5;                               % 启发函数重要程度因子
rho = 0.1;                              % 信息素挥发因子
Q = 1;                                  % 常系数（信息素释放量）
Eta = 1./Dis;                           % 启发函数
Tau = ones(cityNum,cityNum);            % 信息素矩阵
Table = zeros(popNum,cityNum);          % 路径记录表
iter = 1;                               % 迭代次数初值
iter_max = 200;                         % 最大迭代次数
Route_best = zeros(iter_max,cityNum);   % 各代最佳路径
Length_best = zeros(iter_max,1);        % 各代最佳路径的长度
Length_ave = zeros(iter_max,1);         % 各代路径的平均长度

%% 开始迭代
for iter = 1:iter_max
    %随机产生各个蚂蚁的起点城市
    start = ceil( rand(popNum,1) * cityNum );
    Table(:,1) = start;
    % 构建解空间
    citys_index = 1:cityNum;
    % 逐个蚂蚁路径选择
    for i = 1:popNum
        % 逐个城市路径选择
        for j = 2:cityNum
            tabu = Table(i,1:(j-1));  %禁忌表
            allow_index = ~ismember(citys_index,tabu);
            allow = citys_index(allow_index); %允许访问集合
            P = allow;
            for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Eta(tabu(end),allow(k))^beta;
            end
            % 轮盘赌选择下一个访问城市
            P = P/sum(P);
            Pc = cumsum(P);
            target_index = find(Pc >= rand);
            target = allow(target_index(1));
            Table(i,j) = target;
        end
    end
    
    % 计算各个蚂蚁的路径距离
    Length = zeros(popNum,1);
    for i = 1:popNum
        Route = Table(i,:);
        for j = 1:(cityNum-1)
            Length(i) = Length(i) + Dis(Route(j),Route(j+1));
        end
        % 终点到起点
        Length(i) = Length(i) + Dis(Route(cityNum),Route(1));
    end
    
    % 计算最短路径及平均距离
    if iter == 1
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min_Length;
        Length_ave(iter) = mean(Length);
        Route_best(iter,:) = Table(min_index,:);
    else
        [min_Length,min_index] = min(Length);
        Length_best(iter) = min(Length_best(iter - 1),min_Length);
        Length_ave(iter) = mean(Length);
        if Length_best(iter) == min_Length
             Route_best(iter,:) = Table(min_index,:);
        else
             Route_best(iter,:) = Route_best((iter-1),:);
        end
    end
    
    % 更新信息素
    Delta_Tau = zeros(cityNum,cityNum);
    % 逐个蚂蚁计算残留的信息素
    for i = 1:popNum   
       % 逐个城市计算
       for j = 1:(cityNum-1)
           %在道路上均匀的释放信息素
           Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);
       end
       % 终点到起点的信息素
       Delta_Tau(Table(i,cityNum),Table(i,1)) = Delta_Tau(Table(i,cityNum),Table(i,1)) + Q/Length(i);
    end
    %更新
    Tau = (1-rho) * Tau + Delta_Tau;
    %清空路径表
    Table = zeros(popNum,cityNum);
end

%% 结果可视化

[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
disp(['最短距离:' num2str(Shortest_Length)]);
disp(['最短路径:' num2str([Shortest_Route Shortest_Route(1)])]);

figure(1)
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...
     [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       起点');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       终点');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['蚁群算法优化路径(最短距离:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b',1:iter_max,Length_ave,'r:')
legend('最短距离','平均距离')
xlabel('迭代次数')
ylabel('距离')
title('各代最短距离与平均距离对比')








