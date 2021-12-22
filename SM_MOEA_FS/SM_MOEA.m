function [paretoSolutions,paretoFitness] = SM_MOEA(dataX_train,dataY_train)
%SM_MOEA 此处显示有关此函数的摘要
%   此处显示详细说明
    %% 变量初始化
    [popSize,featureNum] = size(dataX_train);
    gamma = 0.1;
    epoches = 100;
    divisionNum = 100;
    %% 初始化
    % 初始化SU
    su = zeros(1,featureNum);
    for i = 1:featureNum
%         su(i) = SU(dataX_train(:,i),dataY_train,divisionNum);
        su(i) = MItest(dataX_train(:,i),dataY_train);
    end
    disp(['SU finish!!!' '  time==' num2str(toc)]);

    % 初始化pop
    newPop = initPop(popSize,featureNum,dataX_train,dataY_train);
    disp(['初始化种群完成!!!' '  time==' num2str(toc)]);
    % 初始化fitness
    newFitness = getFitness(dataX_train,dataY_train,newPop);
    % 非支配排序,获取精英个体
    newFrontValue = NondominateSort(newFitness)';
    newElites = (newFrontValue==1);
    % 初始化引导矩阵
    newSM = SMInit(getDR(newFrontValue),su);


    %% 开始迭代
    for iter = 1:epoches
        
        pop = newPop;
        fitness = newFitness;
        elites = newElites;
        frontValue = newFrontValue;
        SM  = newSM;

        newPop = DimReuction(SM,pop,gamma,iter,elites);
        newPop = IndividualRepair(SM,newPop,pop,elites);

        newFitness = getFitness(dataX_train,dataY_train,newPop);
        newFrontValue = NondominateSort(newFitness)';
        newElites = (newFrontValue==1);
        newSM = SMupdate(SM,pop,newPop,elites,newElites,fitness,newFitness,su,newFrontValue);
        temp  = mean(newFitness(newElites,:));
%         disp([ 'iter == ' int2str(iter) ',feature Num ==' num2str(temp(1)) ',Error==' num2str(temp(2)) ',time == '  num2str(toc)]);

    end
    %% 返回pareto面
    paretoSolutionsIndex = find(newElites);
    paretoSolutions = newPop(paretoSolutionsIndex,:);
    paretoFitness = newFitness(paretoSolutionsIndex,:);
end

