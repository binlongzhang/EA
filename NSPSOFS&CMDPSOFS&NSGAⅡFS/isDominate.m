function [dominate] = isDominate(data1,data2)
%ISDOMINATE 此处显示有关此函数的摘要
%   此处显示详细说明
    domFlag1 = data1 <= data2;
    domFlag2 = data1 < data2;
    domFlag1 = prod(domFlag1);
    domFlag2 = sum(domFlag2);
    dominate = domFlag1 & domFlag2;
end

