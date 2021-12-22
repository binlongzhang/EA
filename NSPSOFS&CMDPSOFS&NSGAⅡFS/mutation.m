function [pop] = mutation(pop,G,T)
%MUTATION 此处显示有关此函数的摘要
%   此处显示详细说明
    [popNum,dimNum] = size(pop);
    divide1 = ceil(popNum/3);
    divide2 = ceil((popNum/3)*2);
    
    index1 = false(size(pop));
    index1(divide1+1:divide2,:) = rand(divide2-divide1,dimNum)<(1/dimNum);
    
    unMutation =  rand(size(pop));
    pop(index1) = unMutation(index1);
    
        
    index2 = false(size(pop));
    index2(divide2+1:end,:) = rand(popNum-divide2,dimNum)<(1/dimNum);
    sign = randsrc(popNum,dimNum,[0,1]);
    pop(index2) = pop(index2) +( abs(pop(index2)-sign(index2))).*unMutation(index2).^(1-G/T);
end

