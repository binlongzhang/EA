function loss = KNNFlodVal(data,label,numNeighbor,KFold)
%KNNFLODVAL 此处显示有关此函数的摘要
%   此处显示详细说明
    Mdl = fitcknn(data,label,NumNeighbors=numNeighbor);
    CVMdl = crossval(Mdl,KFold=KFold);
    loss = kfoldLoss(CVMdl);
end

