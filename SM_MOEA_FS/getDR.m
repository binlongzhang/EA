function [DR] = getDR(frontValue)
%GETDR 此处显示有关此函数的摘要
%   此处显示详细说明
    popSize = size(frontValue,1);
    DR = zeros(popSize,1);
    for i = 1:popSize
        DR(i) = sum(frontValue>frontValue(i));
    end
end

