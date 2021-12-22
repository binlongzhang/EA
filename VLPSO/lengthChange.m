function [swarm] = lengthChange(swarm,dataX,dataY,fitnessFun)
%LENGTHCHANGE 此处显示有关此函数的摘要
%   此处显示详细说明
    oldMaxLength = swarm.maxLength;
    nbrDiv = swarm.divisionNum;
    %计算各个division的平均fitness
    for i = 1:nbrDiv
        swarm.meanFitness(i) = mean(swarm.fitness(swarm.division{i}.start:swarm.division{i}.end));
    end
    [~,index] = max(swarm.meanFitness);
    newMaxLength = swarm.division{index}.len;
    swarm.maxLength = newMaxLength;
    changeIndex = 1:swarm.divisionNum;
    changeIndex(index) = [];
    if(newMaxLength~=oldMaxLength)
        for k = 1:swarm.divisionNum-1
                newLen = ceil(newMaxLength*k/swarm.divisionNum);
                currentIndex = changeIndex(k);
                currentLen = swarm.division{currentIndex}.len;
                swarm.division{currentIndex}.len = newLen;
                if currentLen < newLen
                    for i = swarm.division{currentIndex}.start :swarm.division{currentIndex}.end
                       swarm.particle{i}.position =  [swarm.particle{i}.position , rand(1,newLen-currentLen)];
                       swarm.particle{i}.velocity =  [swarm.particle{i}.velocity , rand(1,newLen-currentLen)];
                       swarm.particle{i}.exemplar =  [swarm.particle{i}.exemplar , zeros(1,newLen-currentLen)+i];
                       swarm.particle{i}.fitness = fitnessFun(swarm.particle{i},dataX,dataY,swarm.threshold,swarm.lambda);
                       swarm.fitness(i) = swarm.particle{i}.fitness;
                       swarm.particleLen(i) = newLen;
                    end
                elseif(currentLen > newLen)
                    for i = swarm.division{currentIndex}.start :swarm.division{currentIndex}.end
                       swarm.particle{i}.position(:,newLen+1:end)  =  [];
                       swarm.particle{i}.velocity(:,newLen+1:end)  =  [];
                       swarm.particle{i}.exemplar(:,newLen+1:end) =  [];
                       swarm.particle{i}.fitness = fitnessFun(swarm.particle{i},dataX,dataY,swarm.threshold,swarm.lambda);
                       swarm.fitness(i) = swarm.particle{i}.fitness;
                       swarm.particleLen(i) = newLen;
                    end
                end
        end
    end
    %更新fitness排序
    [~,swarm.fitSortIndex]=sort(swarm.fitness,'descend');
    %更新pBest
    for i = 1:swarm.popSize
        swarm.particle{i}.exemplar = getExemplar(swarm,i);
    end
    
    
end

