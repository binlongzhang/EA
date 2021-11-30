function [position,maxValue] = initPop(popSize,featureNum,weights,upperBound,KN_point)
%INITPOP 此处显示有关此函数的摘要
%   此处显示详细说明
    adjustNum = sum(weights>0)-KN_point;
    temp = (1-upperBound)/(adjustNum+1);
    changeSilce = [zeros(1,KN_point),1:adjustNum,ones(1,featureNum-adjustNum-KN_point)*adjustNum+1];
    maxValue = ones(size(weights)) - changeSilce*temp;
    maxValue = repmat(maxValue,100,1);
    position = rand(popSize,featureNum);
    position = position.*maxValue;
end

