function [fitness] = test(dataX_train,dataY_train,dataX_test,dataY_test,pop)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    logPop = logical(pop);
    [popSize,featureNum] = size(logPop);
    features = sum(logPop,2);
    error = zeros(popSize,1);
    testNum = size(dataY_test,1);
    for i = 1:popSize                
        if(features(i)~=0)
            Mdl = fitcknn(dataX_train(:,logPop(i,:)),dataY_train,NumNeighbors=5);
            pre = predict(Mdl,dataX_test(:,logPop(i,:)));
            error(i) = sum(pre~=dataY_test)/testNum;
        else
            error(i) = 1;
            features(i) = featureNum;
        end
    end
    fitness = [features,error];
end

