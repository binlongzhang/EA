function [fit] = fitnessLOO(particle,dataX,dataY,threshold,lambda)
%FITNESSLOO 此处显示有关此函数的摘要
%   此处显示详细说明
    
    index = particle.position > threshold;
    if (sum(index) ~=0 )
        dataX = dataX(:,index);
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

        % 计算距离
        minDim = min(dataX);
        maxDim = max(dataX);
        sacleInstance=(dataX-minDim)./(maxDim-minDim);
        dis = pdist2(sacleInstance,sacleInstance, 'minkowski', 1);
        dis = dis/max(max(dis));
        Db = 0;
        Dw = 0;
        M = size(dataY,1);
        for j = 1:M
            DbIndex = dataY(j)~=dataY;
            DwIndex = dataY(j)==dataY;
            DbIndex(j) = false;
            DwIndex(j) = false;
            Db = Db + min(dis(j,DbIndex));
            Dw = Dw + max(dis(j,DwIndex));
        end
        Db = Db/M;
        Dw = Dw/M;
        distance = 1/(1+exp(-5*(Db-Dw)));

        fit = lambda*balance + (1-lambda)*distance;    
    else
        fit = 0;
    end
 end

