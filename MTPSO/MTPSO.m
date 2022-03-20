clc
clear

%% 超参数
ReliefFParms = 10;
rmp = 0.6;
% 文中说在补充文件中有关于这个超参的设置，没有细看，暂时设置一个简单的做示例
taskNum = 4;
c1 = 1.49445;
c2 = 1.49445;
popNum = 50;
Vlimit = [-0.6,0.6];
% 平衡错误率和特征数
alpha = 0.9;
% 决定特征是否选择的阈值
theta = 0.6;
global knn_neighborsNum;
knn_neighborsNum  = 5;
global errorType;
errorType = @getBalanceError;
max_iter = 100;
maxIterUpdateVelocity = 6;
%% 装载数据
load('data/DLBCL');
dataX = mapminmax(X',0,1)';
dataY = Y;
clear X Y;
[insNum,featureNum] = size(dataX); 


%% 初始化种群
[proFeatures,remFeatures,taskGenerateProVec] = kneePointSelectStrategy(dataX,dataY,ReliefFParms);
taskSet = initTask(taskGenerateProVec,taskNum,popNum,Vlimit);
for task=1:taskNum
    taskSet{task}.fitness = getFitness(dataX,dataY,taskSet{task}.position,theta,alpha);
    taskSet{task}.pBest.pos = taskSet{task}.position;
    taskSet{task}.pBest.fit = taskSet{task}.fitness;
    [~,index] = min(taskSet{task}.fitness);
    taskSet{task}.gBest.pos = taskSet{task}.position(index,:);
    taskSet{task}.gBest.fit = taskSet{task}.fitness(index,:);
    taskSet{task}.notChangeIters = 0;
end

%% 开始迭代
for iter = 1:max_iter
    
    disp(['*******************run for: ' num2str(iter) '****************']);
    w = 0.9-0.5*iter/max_iter;
    
    % 更新速度
    for task = 1:taskNum
        % 这里究竟是每个子种群产生一次随机数,还是产生一次随机数之后所有子种群都做相应操作,文中没说清楚
        % 几种gbest修正机制的顺序是按照文中描述自己理解的
        % 这里迁移的时候对于不同搜索空间的迁移方式文中也没有交代清楚，在此按照自己对该算法的理解选择了只迁移重叠部分
        if rand()< rmp
            if taskSet{task}.notChangeIters >= maxIterUpdateVelocity
                % 这里因为只考虑重叠部分的平均，所以实现的相对繁琐一点
                    gBest = zeros(1,featureNum);
                    for i = 1:featureNum
                        if taskSet{task}.searchSpace(1,i)
                           posList = [];
                           for j = 1:taskNum
                               if taskSet{j}.searchSpace(1,i) 
                                    posList(end+1) = taskSet{j}.gBest.pos(1,i);
                               end
                           end
                           gBest(1,i) = mean(posList);
                        end
                    end
            else
                    %这里文中锦标赛排序的参数没有交代，设置成2
                    TSNum = 2;
                    gBestList = zeros(1,taskNum);
                    for i = 1:taskNum
                       gBestList(i) = taskSet{i}.gBest.fit; 
                    end
                    % 防止锦标赛选择选到自己
                    index = 0;
                    while index ~= task
                        index = TournamentSelection(TSNum,1,gBestList);
                    end
                    overlapSpace = taskSet{task}.searchSpace & taskSet{index}.searchSpace;
                    gBest = taskSet{task}.gBest.pos;
                    cr = rand(1,sum(overlapSpace));
                    gBest(overlapSpace) = cr.*taskSet{task}.gBest.pos(overlapSpace) + (1-cr).*taskSet{index}.gBest.pos(overlapSpace);
            end
        else
            gBest = taskSet{task}.gBest.pos;
        end
        % 更新速度
        taskSet{task}.velocity = w*taskSet{task}.velocity + c1*rand(popNum,featureNum).*(taskSet{task}.pBest.pos-taskSet{task}.position) + ... 
                c2*rand(popNum,featureNum).*(gBest-taskSet{task}.position);
        taskSet{task}.velocity(taskSet{task}.velocity<Vlimit(1)) = Vlimit(1);
        taskSet{task}.velocity(taskSet{task}.velocity>Vlimit(2)) = Vlimit(2);
    end
    
    
    % 更新位置,pBest,gBest
    for task = 1:taskNum
        taskSet{task}.position = taskSet{task}.position + taskSet{task}.velocity;
        taskSet{task}.position(taskSet{task}.position>1) = 1;
        taskSet{task}.position(taskSet{task}.position<0) = 0;
        % 获取fitness
        taskSet{task}.fitness = getFitness(dataX,dataY,taskSet{task}.position,theta,alpha);
        % 更新pBest
        tempIndex = (taskSet{task}.fitness<taskSet{task}.pBest.fit);
        taskSet{task}.pBest.pos(tempIndex,:) = taskSet{task}.position(tempIndex,:);
        taskSet{task}.pBest.fit(tempIndex,:) = taskSet{task}.fitness(tempIndex,:);
        % 更新gBest
        [fitValue,index] = min(taskSet{task}.fitness);
        if fitValue < taskSet{task}.gBest.fit
            taskSet{task}.notChangeIters = 0;
            taskSet{task}.gBest.fit = fitValue;
            taskSet{task}.gBest.pos =  taskSet{task}.position(index,:);
        else
            taskSet{task}.notChangeIters = taskSet{task}.notChangeIters + 1;
        end
    end

end

%% 提取每个子种群的gbest & fitness
finGBest{taskNum} = {};
for task = 1:taskNum
    finGBest{task}.solution = taskSet{task}.gBest.pos > theta;
    finGBest{task}.fit = taskSet{task}.gBest.fit;
end
