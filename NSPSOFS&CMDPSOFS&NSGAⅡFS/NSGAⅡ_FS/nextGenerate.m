function [newPopulation] = nextGenerate(population,frontValue,functionValue,popNum,popLength)
%NEXTGENERATE 利用帕罗托排序和拥挤距离计算下一代个体
%   输入：population:交叉变异后的种群；frontValue：各个物种分配的前沿面序号；functionValue：函数值；popNum:种群数量；popLength：个体长度；
%   输出：newPopulation：挑选后的种群

% 寻找前n个前沿面
frontNum = 0;
while numel(frontValue,frontValue<=frontNum+1)<=popNum
    frontNum = frontNum + 1;
end
newNum =  numel(frontValue,frontValue<=frontNum);

newPopulation = zeros(popNum,popLength);    % 用于存储新生代种群
newPopulation(1:newNum,:) = population(frontValue<=frontNum,:);
popNFrontIndex = find(frontValue == frontNum+1);
distance = zeros(size(popNFrontIndex));

%寻找每个维度的最大最小值
fmax=max(functionValue(popNFrontIndex,:),[],1);                                  
fmin=min(functionValue(popNFrontIndex,:),[],1);
%计算拥挤距离
for i = 1:size(functionValue,2)
    [~,newPos] = sortrows(functionValue(popNFrontIndex,i));
    distance(newPos(1)) = inf;
    distance(newPos(end)) = inf;
    for j  = 2:length(popNFrontIndex)-1
        distance(newPos(j)) = distance(newPos(j))+ (functionValue(popNFrontIndex(newPos(j+1)),i)-functionValue(popNFrontIndex(newPos(j-1)),i))/(fmax(i)-fmin(i));
    end
end
%按照拥挤距离倒序排列第frontNum个前沿面上的个体
popNFrontIndex = -sortrows(-[distance;popNFrontIndex]')';  
%补充新个体
newPopulation(newNum+1:popNum,:) = population(popNFrontIndex(2,1:popNum-newNum),:);

end

