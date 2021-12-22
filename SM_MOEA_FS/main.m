clc
clear
tic
%% 超参数
dataName = 'DLBCL';
load(['data/' dataName])
dataX = data;
dataY = label;
[popSize,featureNum] = size(dataX);
Kfold = 10;
epoches = 30;
%% 处理数据集
% 数据归一化
len=size(dataX,1);
maxV = max(dataX);
minV = min(dataX);
range = maxV-minV;
dataX = (dataX-repmat(minV,[len,1]))./(repmat(range,[len,1]));
% 划分数据集
indices = crossvalind('Kfold',dataY,Kfold);
result = {};
result.aveFitness = zeros(epoches,2);
result.record{epoches} = {};

for epoch = 1:epoches
    %% 10折叠交叉验证
    record{10} = {};
    for foldNum = 1:Kfold
        disp( ['第 ' num2str(epoch) ' 论,第 ' num2str(foldNum) ' 折验证, Time == ' num2str(toc)])
        dataX_train = dataX(indices ~= foldNum,:);
        dataY_train = dataY(indices ~= foldNum,:); 
        dataX_test = dataX(indices == foldNum,:);
        dataY_test = dataY(indices == foldNum,:); 
        [paretoSolutions,paretoFitness] = SM_MOEA(dataX_train,dataY_train);
        testFitness = test(dataX_train,dataY_train,dataX_test,dataY_test,paretoSolutions);
        record{foldNum}.solution = paretoSolutions;
        record{foldNum}.trainFitness = paretoFitness;
        record{foldNum}.testFitness = testFitness;

        record{foldNum}.ave.meanTrainFit = mean(paretoFitness);
        record{foldNum}.ave.meanTestFit = mean(testFitness);
        disp( ['Average Feature Number:'  num2str(record{foldNum}.ave.meanTrainFit(1))])
        disp( ['Average Train ErrorRate:' num2str(record{foldNum}.ave.meanTrainFit(2))])
        disp( ['Average Test ErrorRate:'  num2str(record{foldNum}.ave.meanTestFit(2)) ]) 
    end
    %% 结果统计
    unionPF = [];
    unionPFfit = [];
    aveFeatureNum = [];
    aveTestErrorRate = [];
    for i = 1:Kfold
        unionPF = [unionPF;record{i}.solution];
        unionPFfit = [unionPFfit;record{i}.testFitness];
        aveFeatureNum = [aveFeatureNum;record{i}.ave.meanTestFit(1)];
        aveTestErrorRate = [aveTestErrorRate;record{i}.ave.meanTestFit(2)];
    end
    
    result.aveFitness(epoch,1) = mean(aveFeatureNum);
    result.aveFitness(epoch,2) = mean(aveTestErrorRate);
    result.record{epoch} = record;
    % disp('Pareto Average:')
    % frontValue = NondominateSort(unionPFfit);
    % paretoIndex = find(frontValue ==1); 
    % unionPFfit(paretoIndex,:)
    % avePareto  = mean(unionPFfit(paretoIndex,:))
    
    clear record
    
end

save(['result/' num2str(dataName) '.mat'],'result')
mean(result.aveFitness)
std(result.aveFitness)
toc
