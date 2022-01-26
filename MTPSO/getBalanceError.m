function [error] = getBalanceError(predict,label)
%BALANCEERROR 此处显示有关此函数的摘要
%   此处显示详细说明
    flag = predict==label;
    
    tbl = tabulate(label);
    labelClass = tbl(:,1);
    classNum = size(tbl,1);
    classAcc = ones(classNum,1);
    for i = 1: classNum
        idx = label == labelClass(i);
        right = sum(flag(idx));
        classAcc(i) = right/tbl(i,2);
    end
    error =1 - mean(classAcc(~isnan(classAcc)));
end

