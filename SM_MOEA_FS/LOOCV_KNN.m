function [errorRate] = LOOCV_KNN(dataX,dataY)
%LOOCV_KNN 1NN with LOOCV
%   此处显示详细说明    
    Dis = pdist2(dataX,dataX);
    % 对角线设置为无穷
    Dis(logical(eye(size(Dis)))) = inf;
    
    error=0;
    dataNum =  size(dataX,1);
    for i = 1:dataNum
        [~,minIndex] =min(Dis(i,:));
        pre = dataY(minIndex);
        if(pre ~= dataY(i) )
            error= error+1;
        end
    end
    errorRate = error/dataNum;
end

