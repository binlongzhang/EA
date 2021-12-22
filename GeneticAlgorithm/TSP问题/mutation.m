function [ chromosome ] = mutation( chromosome )
%MUTATION 随机交叉两段基因,实现染色体变异
%   chromosome:染色体
    %生成随机序列
    randSequence = randperm(size(chromosome,2));
    index1 = randSequence(1);
    index2 = randSequence(2);
    % 交换基因
    temp = chromosome(index1);
    chromosome(index1) = chromosome(index2);
    chromosome(index2) = temp;
end

