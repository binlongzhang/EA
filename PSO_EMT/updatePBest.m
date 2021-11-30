function [pBest] = updatePBest(pBest,pos,fitness,subset,skillFactor)
%UPDATEPBEST 此处显示有关此函数的摘要
%   此处显示详细说明
    for i = 1:numel(fitness)
        if skillFactor == 1
            if fitness(i) < pBest.task1.fit(i)
                pBest.task1.pos(i,:) = pos(i,:);
                pBest.task1.fit(i) = fitness(i);
                pBest.task1.mask(i,:) = subset;
            end
        else
             if fitness(i) < pBest.task2.fit(i)
                pBest.task2.pos(i,:) = pos(i,:);
                pBest.task2.fit(i) = fitness(i);
            end
        end
    end

end

