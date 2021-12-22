function [ len ] = myLength( distance, chromosome )
%myLength 求解对应路径的距离
%   distance: 图的距离矩阵--无向赋权图
%   chromesome:对于单个染色体，里面存储了所有城市的随机排序
    [~,N] = size(distance);
    len = distance(chromosome(1,N),chromosome(1,1));
    for i = 1:(N-1)
        len = len + distance(chromosome(1,i),chromosome(1,i+1));
    end
end

