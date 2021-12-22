function [population] = PloyMutation(population)
%mutation 变异操作-多项式变异
%   输入：pop种群
%   输出：newPop新种群
eta = 1;
[~,popLength] = size(population);
k=rand(size(population)); 
u=rand(size(population));
delta = zeros(size(population));
index1 = k<1/popLength & u<0.5;   %要变异的基因位
index2 = k<1/popLength & u>=0.5;

delta(index1) = (2.*u(index1)).^(1./(1+eta)) - 1;
delta(index2) = (1 - 2.*(1-u(index2))).^(1./(1+eta));
population = population + delta;
end

