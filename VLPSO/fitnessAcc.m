function fitness = fitnessAcc(particle,dataX,dataY,threshold,lambda)
%FITNESS 此处显示有关此函数的摘要
%   此处显示详细说明
    index = particle.position > threshold;
    Mdl = fitcknn(dataX(:,index),dataY,NumNeighbors=10);
    CVMdl = crossval(Mdl,KFold=10);
    fitness = 1-kfoldLoss(CVMdl);
end
