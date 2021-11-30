function [featureNum,error] = LOOCV_KNN(dataX,dataY,flag)
%LOOCV_KNN 1NN with LOOCV
%   此处显示详细说明    
    popSize = size(flag,1);
    featureNum = sum(flag,2);
    maxFeatureNum = max(featureNum);
    error = ones(popSize,1);
    for j = 1:popSize
        if featureNum(j)~=0
            Dis = pdist2(dataX(:,flag(j,:)),dataX(:,flag(j,:)));
            % 对角线设置为无穷
            Dis(logical(eye(size(Dis)))) = inf;

            [~, minIndex] = min(Dis, [], 2);
            y = dataY(minIndex);
            className = max(dataY);
            TPR = zeros(className,1);
            for i = 1: className
                idx = dataY == i;
                TPR(i) = sum(dataY(idx)==y(idx)) / sum(idx);
            end
            error(j) = 1-mean(TPR);
        else
            featureNum(j) = maxFeatureNum;
        end
    end
end

