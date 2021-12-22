function [fitness] = getFitness(dataX,dataY,pop)
%UPDATEFITNESS 此处显示有关此函数的摘要
%   此处显示详细说明
%     global record;
    PopLogical = logical(pop);
    [popSize,featureNum] = size(PopLogical);
    choiceFeatureNum = sum(PopLogical,2);
    error = zeros(popSize,1);
    for i = 1:popSize
        if(choiceFeatureNum(i)~=0)
            error(i) = LOOCV_KNN(dataX(:,PopLogical(i,:)),dataY);
%             [right,index] = ismember(pop(i,:),record.pop,'rows');
%             if(right)
%                 error(i) = record.fitness(index,2);
%             else
%                 error(i) = LOOCV_KNN(dataX(:,PopLogical(i,:)),dataY);
%                 %记录
%                 record.pop = [record.pop;pop(i,:)];
%                 record.fitness = [record.fitness;[choiceFeatureNum(i) error(i)]];
%             end
        else
            error(i) = 1;
            choiceFeatureNum(i) = featureNum;
        end
    end
    fitness = [choiceFeatureNum,error];
end

