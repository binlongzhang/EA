function [fitness] = getFitness(dataX,dataY,position,theta,alpha)
%GETFITNESS 此处显示有关此函数的摘要
%   此处显示详细说明

    [featureNum,error] = KNN_5fold(dataX,dataY,position>theta);
    fitness = alpha*error + (1-alpha)*featureNum/size(dataX,2);
end

