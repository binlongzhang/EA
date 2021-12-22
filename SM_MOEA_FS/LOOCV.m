function [errorRate] = LOOCV(dataX,dataY)
% 留一交叉验证
%   此处显示详细说明
    popSize = size(dataX,1);
    acc = 0;
    for i = 1:popSize
        index = 1:popSize;
        index(i) = [];
        Mdl = fitcknn(dataX(index,:),dataY(index,:)); 
        pre = predict(Mdl,dataX(i,:));
        acc = acc + (pre==dataY(i));
    end
    errorRate = (popSize-acc)/popSize;
end

