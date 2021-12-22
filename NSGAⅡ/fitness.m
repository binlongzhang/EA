function [functionValue] = fitness(population)
%FITNESS 根据输入种群计算对应的目标函数，即可以理解为适应度，此处针对的是ZDT1
%   输入：population 输出：functionValue第一列存储存储f1的值，第二列存储f2的值
[~,popLength] = size(population);
functionValue = zeros(size(population,1),2);
functionValue(:,1) = population(:,1);
%计算临时值
g = 1+9*sum(population(:,2:popLength),2)./(popLength-1);
%计算第二维目标函数值
functionValue(:,2)=g.*(1-(population(:,1)./g).^0.5); 
end

