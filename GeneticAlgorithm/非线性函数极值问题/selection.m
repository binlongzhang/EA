function [ newpop ] = selection( pop,fitValue )
%selection 新个体的选择--转盘
%   输入变量：pop：二进制种群，fitValue：适应度值
%   输出变量：newpop：选择后的种群
    [px,py] = size(pop);
    totalfit = sum(fitValue);
    p_fitValue = fitValue/totalfit;
    p_fitValue = cumsum(p_fitValue); % 数组各行累加值(构造转盘数组)
    ms = sort(rand(px,1));%从小到大排列指针
    
    fitin = 1;
    newin = 1;
    while newin<=px
        if ms(newin)<p_fitValue(fitin)
            newpop(newin,:) = pop(fitin,:);
            newin = newin + 1;
        else
            fitin = fitin + 1;
        end
    end
    
end

