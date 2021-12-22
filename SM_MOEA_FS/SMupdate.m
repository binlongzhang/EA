function [SM] = SMupdate(SM,pop,newPop,elites,newElites,fitness,newFitness,su,newFrontValue)
%SMUPDATE 此处显示有关此函数的摘要
%   此处显示详细说明
    [popSize,featureNum] = size(pop);
    if(mean(newFitness(newElites,2)) < mean(fitness(elites,2)) )
        for i = 1:popSize
            if(newElites(i))
               for j = 1:featureNum
                   if(pop(i,j)~=newPop(i,j))
                       indicatorNoEquals = 1;
                   else
                       indicatorNoEquals = 0;
                   end
                   
                  if(newPop(i,j)>pop(i,j))
                       indicatorYLargeX = 1;
                   else
                       indicatorYLargeX = 0;
                   end

                   SM(i,j) = SM(i,j)*exp( (1/sqrt(2)) * (indicatorNoEquals*(indicatorYLargeX - 1/5)) );
               end
            end
        end
    else
       SM =  SMInit(getDR(newFrontValue),su);
    end
end

