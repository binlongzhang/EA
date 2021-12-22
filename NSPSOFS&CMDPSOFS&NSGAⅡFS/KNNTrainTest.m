function [error] = KNNTrainTest(train,test,numNeighbor,KFold)
%KNNFLODVAL 此处显示有关此函数的摘要
%   此处显示详细说明
    Mdl = fitcknn(train(:,2:end),train(:,1),NumNeighbors=numNeighbor);
    CVMdl = crossval(Mdl,KFold=KFold);
    trainError = kfoldLoss(CVMdl);
    testError = loss(Mdl,test(:,2:end),test(:,1));
    error = [trainError,testError];
end

