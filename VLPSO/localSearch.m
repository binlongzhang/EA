function [returnParticle] = localSearch(particle,dataX,dataY,alpha,beta,fitnessFun,SUC,SUF)
%LOCALSEARCH 此处显示有关此函数的摘要
%   此处显示详细说明
    returnParticle = particle;
%     disp(['local search start'])
    for t = 1 :beta
        index = returnParticle.position > 0.6;
        m = floor(sum(index)*alpha);
        selectIndex = find(index==1);
        notSelectIndex = find(index==0);
        tempIndex1 = selectIndex(randperm( size(selectIndex,2) , m ));
        tempIndex2 = notSelectIndex(randperm( size(notSelectIndex,2) , m ));
        newParticle = returnParticle;
        [~,sortIndex] = sort(SUC(tempIndex1),'des');
        tempIndex1 = tempIndex1(sortIndex);
        for i  = 1:size(tempIndex1,2)
            for j = i+1:size(tempIndex1,2)
                if( (index(tempIndex1(i))==1) & (index(tempIndex1(j))==1) ...
                     &  ( SUF(tempIndex1(i),tempIndex1(j)) > SUC(tempIndex1(j)) )...
                 )
                    index(tempIndex1(j)) = false;
                    newParticle.position(tempIndex1(j)) = 0;
                end     
            end
        end
        avgSU = mean(SUC(tempIndex1));
        for i = tempIndex2
            if (SUC(i)>avgSU)
                newParticle.position(i) = 1;
            end
        end
        newParticle.fitness = fitnessFun(newParticle,dataX,dataY,0.6,0.9);
        if(newParticle.fitness > returnParticle.fitness)
            returnParticle = newParticle;
        end
    end
%     disp(['local search End'])
    returnParticle.pBest.pos = returnParticle.position;
    returnParticle.pBest.fitness = returnParticle.fitness;


end

