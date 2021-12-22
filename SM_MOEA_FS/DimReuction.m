function [pop] = DimReuction(SM,pop,gamma,iter,elites)
%DIMREUCTION 此处显示有关此函数的摘要
%   此处显示详细说明
    [popSize,featureNum] = size(pop);
    for i = 1:popSize
       if(~elites(i))
          SMMeanI = mean(SM(i,:)); 
          for j = 1:featureNum
              fp = exp(-iter*gamma)/(1+ exp(SM(i,j)-SMMeanI) );
              if (pop(i,j)==1 && fp>=rand())
                  pop(i,j) = 0;
              end
          end
       end
    end      
end

