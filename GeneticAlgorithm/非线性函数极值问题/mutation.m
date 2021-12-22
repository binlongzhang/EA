function [ newpop ] = mutation( pop,mutationRate )
%mutation GA算法的变异操作
%   输入变量：pop：二进制种群，mutationRate：变异概率
%   输出变量：newpop：变异后的种群
    [px,py] = size(pop);
    newpop = ones(size(pop));

    for i = 1:px
        if(rand<=mutationRate)
            %变异位置
            mutationPoint = ceil(rand*py);
            newpop(i,:) = pop(i,:);
            %变异操作
            newpop(i,mutationPoint) = ~ newpop(i,mutationPoint);
        else
            newpop(i,:) = pop(i,:);
        end

    end
end

