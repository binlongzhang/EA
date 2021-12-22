function [balance] = balanceAccLOO(dataX,dataY)
%BALANCEACC 此处显示有关此函数的摘要
%   此处显示详细说明
    particleNum = size(dataX,1);
    flag = false(1,particleNum);
    for i = 1:particleNum
        % 计算平衡准确率
        test = dataX(i,:); 
        train = dataX([1:i-1,i+1:end],:);
        testLabel = dataY(i,:);
        trainLabel = dataY([1:i-1,i+1:end],:);   
        Mdl = fitcknn(train,trainLabel,'Standardize',1,NumNeighbors=5); 
%             'Distance','minkowski','Exponent',1,...);
        pre = predict(Mdl,test);
        flag(i) = pre==testLabel;
    end
    tbl = tabulate(dataY);
    acc = zeros(1,size(tbl,1));
    for j = 1:size(tbl,1)
        acc(j) = sum( (tbl(j,1)==dataY )& flag') / tbl(j,2);
    end
    balance = mean(acc);
end

