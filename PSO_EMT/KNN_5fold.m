function [featureNum,error] = KNN_5fold(dataX,dataY,Pop)

%KNN_5FOLD 此处显示有关此函数的摘要
%   此处显示详细说明
    fold = 5;
    popSize = size(flag,1);
    featureNum = sum(flag,2);
    maxFeatureNum = max(featureNum);
    error = ones(popSize,1);            
    indices = crossvalind('Kfold',dataY,fold);

    for j = 1:popSize
        if featureNum(j)~=0
            RD = 0;
            for i = 1:fold
                dataX_train = dataX(indices ~= i,:);
                dataY_train = dataY(indices ~= i,:); 
                dataX_test = dataX(indices == i,:);
                dataY_test = dataY(indices == i,:); 
                Mdl = fitcknn(dataX_train(:,flag(j,:)),dataY_train,NumNeighbors=1);
                pre = predict(Mdl,dataX_test(:,flag(j,:)));
                tbl = tabulate(dataY_test);
                tbl(tbl(:,2)==0,:) = [];
                TPR = 0;
                for k = tbl(:,1)'
                    index = k==dataY_test;
                    TPR = TPR + sum(pre(index)==dataY_test(index))/sum(index);
                end
                RD = 1-TPR/size(tbl,1) + RD;
            end
            error(j) = RD/fold;
        else
            featureNum(j) = maxFeatureNum;
        end
    end
end

