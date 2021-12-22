function [swarm] = updatePc(swarm)
%UPDATEPC 此处显示有关此函数的摘要
%   此处显示详细说明
    for i = 1:swarm.popSize
        temp = (find(swarm.fitSortIndex==i)-1)/(swarm.popSize-1);
        Pc = 0.05+0.45*( (exp(10*temp)) / (exp(10)-1) );
        swarm.pc(i) = Pc;
    end
end

