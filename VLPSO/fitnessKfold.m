function [fit] = fitnessKfold(particle,dataX,dataY,threshold,lambda)
%FITNESSFUN 此处显示有关此函数的摘要
    index = particle.position > threshold;
    if(sum(index)~=0)
        dataX = dataX(:,index);
        Kfold = 10;
        indices = crossvalind('Kfold',dataY,Kfold);
        fitness = zeros(1,Kfold);
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
                acc(j) = sum(tbl(j,1)==pre & right)/tbl(j,2);
            end
            balance = mean(acc);

            % 计算距离
            minDim = min(train);
            maxDim = max(train);
            sacleInstance=(train-minDim)./(maxDim-minDim);
            dis = pdist2(sacleInstance,sacleInstance, 'minkowski', 1);
            dis = dis/max(max(dis));
            M = size(trainLabel,1);
            Db = zeros(1,M);
            Dw = zeros(1,M);
            for j = 1:M
                DbIndex = trainLabel(j)~=trainLabel;
                DwIndex = trainLabel(j)==trainLabel;
                DbIndex(j) = false;
                DwIndex(j) = false;
                if(sum(DbIndex)~=0)
                    Db(j) = min(dis(j,DbIndex));
                end
                if(sum(DwIndex)~=0)
                    Dw(j) = max(dis(j,DwIndex));
                end
            end
            distance = 1/(1+exp(-5*( mean(Db(Db>0))-mean(Dw(Dw>0)) )));
            fitness(i) = lambda*balance + (1-lambda)*distance;    
        end
        fit = mean(fitness);
    else
        fit = 0;
    end
end

