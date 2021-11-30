function [featureNum,Acc] = test(trainX,trainY,testX,testY,result)
%TEST 此处显示有关此函数的摘要
%   此处显示详细说明
    feature = (result.gbest.task1.pos  .* result.gbest.task1.mask)>0.6;
    Mdl = fitcknn(trainX(:,feature),trainY,NumNeighbors=1);
    pre = predict(Mdl,testX(:,feature));
    featureNum = sum(feature);
    Acc = sum(pre==testY)/size(testY,1);
end

