function [su] = SU(X,Y,divideNum)
%SU 此处显示有关此函数的摘要
%   此处显示详细说明
    HF = entropy(X,divideNum);
    tdl = tabulate(Y);
    pc = tdl(:,2) / sum(tdl(:,2));
    HC = -sum(log2(pc)./pc);
    IG = HF - conditionEntropy(X,Y,divideNum);
    su = IG/(HF+HC);
end

