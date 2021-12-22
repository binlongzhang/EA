function [nondomIndex] = nondominateSolution(functionValue)
%NONDOMINATESOLUTION 此处显示有关此函数的摘要
%   此处显示详细说明
    functionValueLen = size(functionValue,1);
    nondomFlag = false(functionValueLen,1);
    for i = 1 :functionValueLen
        domFlag1 = functionValue(i,:) <= functionValue;
        domFlag2 = functionValue(i,:) < functionValue;
        domFlag1 = prod(domFlag1,2);
        domFlag2 = sum(domFlag2,2);
        nondomFlag = nondomFlag | (domFlag1 & domFlag2);
    end
    nondomIndex = find(nondomFlag==0);
end

