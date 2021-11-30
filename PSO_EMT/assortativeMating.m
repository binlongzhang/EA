function [V] = assortativeMating(V,pos,skillFactor,pbest,gbest,c1,c2,c3,w,rmp)
%ASSORTATIVEMATING 此处显示有关此函数的摘要
%   此处显示详细说明
    select = (rand(size(V,1),1)<rmp);
    index = select & skillFactor==1;
    V(index,:) = w*V(index,:) + c1*rand*( pbest.task1.pos(index,:)- pos(index,:)) + ...
        c2*rand*(gbest.task1.pos - pos(index,:)) + c3*rand*(gbest.task2.pos-pos(index,:));
    
    index = select & skillFactor==2;
    V(index,:) = w*V(index,:) + c1*rand*( pbest.task2.pos(index,:)- pos(index,:)) + ...
        c2*rand*(gbest.task2.pos - pos(index,:)) + c3*rand*(gbest.task1.pos-pos(index,:));

    index = ~select & skillFactor==1;
    V(index,:) = w*V(index,:) + c1*rand*( pbest.task1.pos(index,:)- pos(index,:)) + ...
        c2*rand*(gbest.task1.pos - pos(index,:));
    
    index = ~select & skillFactor==2;
    V(index,:) = w*V(index,:) + c1*rand*( pbest.task2.pos(index,:)- pos(index,:)) + ...
        c2*rand*(gbest.task2.pos - pos(index,:));
end

