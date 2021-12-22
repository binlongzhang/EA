function [newPop] = IndividualRepair(SM,newPop,pop,elites)
%INDIVIDUALREPAIR 此处显示有关此函数的摘要
%   此处显示详细说明
    [popSize,featureNum] = size(pop);
    eliteIndex = find(elites);
    for i = 1:popSize
        if (~elites(i))
            e = eliteIndex(randperm(size(eliteIndex,1),1));
            for j = 1:featureNum
               if(SM(i,j) >= SM(e,j) && pop(e,j)==1)
                   %发现新的比精英更重要，则回退之前的减少 
                   newPop(i,j) = pop(i,j);
               else
                   rho = abs(SM(e,j)-SM(i,j))/SM(e,j);
                   if (rho >= rand() )
                        newPop(i,j) = newPop(e,j);
                   end
               end
            end
        end
    end
end

