% Md = fitcknn(dataX,dataY,'Standardize',1,'Distance',...
%     'minkowski','Exponent',1,'Crossval','on');
% % Mdl = fitcknn(dataX,dataY,NumNeighbors=4);
% 
% % CVMdl = crossval(Mdl,KFold=10);
% % kloss = kfoldLoss(CVMdl)
% % rloss = resubLoss(Mdl)
%  kloss = kfoldLoss(CVMdl)
Kfold = 10
lambda = 0.8
indices = crossvalind('Kfold',dataY,Kfold);
fitness = zeros(1,Kfold);
for i = 1:10
    % 计算平衡准确率
    test = dataX(indices == i,:); 
    train = dataX(indices ~= i,:);
    testLabel = dataY(indices == i,:); 
    trainLabel = dataY(indices ~= i,:);    
    Mdl = fitcknn(train,trainLabel,'Standardize',1,'Distance',...
        'minkowski','Exponent',1,'NumNeighbors',5);
    pre = predict(Mdl,test);
    tbl = tabulate(testLabel);
    right = testLabel==pre;
    acc = zeros(1,size(tbl,1));
    for j = tbl'
        acc(j(1)) = sum(j(1)==pre & right)/j(2);
    end
    balance = mean(acc);
    
    % 计算距离
    minDim = min(train);
    maxDim = max(train);
    sacleInstance=(train-minDim)./(maxDim-minDim);
    dis = pdist2(sacleInstance,sacleInstance, 'minkowski', 1);
    dis = dis/max(max(dis));
    Db = 0;
    Dw = 0;
    M = size(trainLabel,1);
    for j = 1:M
        DbIndex = trainLabel(j)~=trainLabel;
        DwIndex = trainLabel(j)==trainLabel;
        DbIndex(j) = false;
        DwIndex(j) = false;
        Db = Db + min(dis(j,DbIndex));
        Dw = Dw + max(dis(j,DwIndex));
    end
    Db = Db/M;
    Dw = Dw/M;
    distance = 1/(1+exp(-5*(Db-Dw)));
    fitness(i) = lambda*balance + (1-lambda)*distance;    
end
fit = mean(fitness);