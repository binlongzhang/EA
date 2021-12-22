function [newpop] = crossover(pop,pc)
%crossover 交叉操作
%   输入变量：pop 二进制的父种群数，pc：交叉概率
%   输出变量：交叉后的种群
    [px,py] = size(pop);
    newpop = ones(size(pop));
    % 两两交叉
    for i = 1:2:px-1
        if(rand<pc)
            % 交叉
            cpoint = round(rand*py); % 随机产生交叉的位置
            newpop(i,:) = [pop(i,1:cpoint),pop(i+1,cpoint+1:py)];
            newpop(i+1,:) = [pop(i+1,1:cpoint),pop(i,cpoint+1:py)];        
        else
            newpop(i,:) = pop(i,:);
            newpop(i+1,:) = pop(i+1,:);
        end
end

