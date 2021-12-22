function [SM] = SMInit(DR,su)
%SMINIT 此处显示有关此函数的摘要
%   此处显示详细说明
    tempSU = su/sum(su);
    tempDR = DR/size(DR,1);
    SM = tempDR * tempSU;
end

