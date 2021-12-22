function [flag] = getElites(fitness)
%NON_DOMINATED_SORT 此处显示有关此函数的摘要
%   此处显示详细说明
    popSize = size(fitness,1);                                                                    
    flag = true(popSize,1);
    for i = 1:popSize
       if(flag(i)==true)
           for j = i+1:popSize
               if(~all(fitness(i,:)==fitness(j,:)))
                  if(all(fitness(i,:)<=fitness(j,:))) 
                        flag(j) = false;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                  elseif ( all(fitness(i,:)>=fitness(j,:)) )
                        flag(i) = false;
                        break;
                  end
               else
                   flag(j) = false;
               end
           end
       end
    end
end

