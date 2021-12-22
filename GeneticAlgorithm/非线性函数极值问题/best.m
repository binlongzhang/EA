function [ bestIndividual bestFit ] = best( pop,fitValue )
%best 寻找最优个体和最佳适应度
%   输入变量：pop：种群，fitvalue：种群适应度
%   输出变量：bestIndividual:最佳个体，bestFit:最佳适应值
    [px,py] = size(pop);
    
    % 设置默认值
    bestIndividual = pop(1,:);
    bestFit = fitValue(1);
    
    for i=2:px
        if fitValue(i)>bestFit
            bestIndividual = pop(i,:);
            bestFit = fitValue(i);
        end
    end

end

