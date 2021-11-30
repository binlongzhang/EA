function [error] = NB(trainX,trainY,testX,testY)
%NB 此处显示有关此函数的摘要
%   此处显示详细说明

    %% 分类器
    Dis = pdist2(data,data);
    % 对角线设置为无穷
    Dis(logical(eye(size(Dis)))) = inf;

    [~, minIndex] = min(Dis, [], 2);
    y = label(minIndex);

    %% 输出结果 
    className = max(label);
    TPR = ones(className,1)+1;
    for i = 1: className
        idx = label == i;
        total = sum(idx);
        if total == 0 
            break;
        end
        TPR(i) = sum(label(idx)==y(idx)) / total;
    end
    error(j) = 1-mean(TPR(TPR<=1));
end

