function [featureNum,trainError,testError] = calResult(train,test,pop,theta,numNeighbor,KFold)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明    
    [popNum,dimNum] = size(pop);
    index = pop > theta;
    trainData = train(:,2:end);
    trainLabel = train(:,1);
    testData = test(:,2:end);
    testLabel = test(:,1);
    featureNum = sum(index,2);
    trainError = ones(popNum,1);
    testError = ones(popNum,1);
    for i = 1:popNum
        if featureNum(i)==0
            continue;
        else
            Mdl = fitcknn(trainData(:,index(i,:)),trainLabel,NumNeighbors=numNeighbor);
            CVMdl = crossval(Mdl,KFold=KFold);
            trainError(i) = kfoldLoss(CVMdl);
            testError(i) = loss(Mdl,testData(:,index(i,:)),testLabel);
        end
    end
end

