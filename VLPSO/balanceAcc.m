function [accruacy] = balanceAcc(dataX,dataY)
%BALANCEACC 此处显示有关此函数的摘要
%   此处显示详细说明
    Kfold = 10;
    indices = crossvalind('Kfold',dataY,Kfold);
    balance = zeros(1,Kfold);
    for i = 1:10
        % 计算平衡准确率
        test = dataX(indices == i,:); 
        train = dataX(indices ~= i,:);
        testLabel = dataY(indices == i,:); 
        trainLabel = dataY(indices ~= i,:);    
        Mdl = fitcknn(train,trainLabel,'Standardize',1,NumNeighbors=5); 
    %             'Distance','minkowski','Exponent',1,...);
        pre = predict(Mdl,test);
        tbl = tabulate(testLabel);
        right = testLabel==pre;
        acc = zeros(1,size(tbl,1));
        for j = 1:size(tbl,1)
            temp = sum(tbl(j,1)==pre & right);
            if (temp~=0)
                acc(j) = temp/tbl(j,2);
            end
        end
        balance(i) = mean(acc);
    end
    accruacy = mean(balance);
end

