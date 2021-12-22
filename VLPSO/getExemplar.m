function [exemplar] = getExemplar(swarm,pIndex)
%UPDATEEXEMPLAR 此处显示有关此函数的摘要
%   此处显示详细说明
    exemplar = zeros(1,swarm.particleLen(pIndex));
    for d = 1:swarm.particleLen(pIndex)
        if (rand>=swarm.pc(pIndex))
            exemplar(d) = pIndex;
        else
            index = find(swarm.particleLen>=d);
            index( find(index==pIndex)) = [];
            p = randperm(size(index,1),2);
            p1 = index(p(1));
            p2 = index(p(2));
            if(swarm.fitness(p1) > swarm.fitness(p2))
                exemplar(d) = p1;
            else
                exemplar(d) = p2;
            end
        end
    end

end

