function [evaluate] = fitness(data,label,pop,theta,neighborNum,kflod)
%CRITICAL 此处显示有关此函数的摘要
%   此处显示详细说明
    [popNum,dimNum] = size(pop);
    index = pop > theta;
    featureNum = sum(index,2);
    errors = inf(popNum,1);
    for i = 1:popNum
        if featureNum(i)~=0
            errors(i) = KNNFlodVal(data(:,index(i,:)),label,neighborNum,kflod);
        end
    end
    featureNum(featureNum==0) = inf;
    evaluate = [featureNum,errors];
end


