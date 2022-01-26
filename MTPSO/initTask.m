function [taskSet] = initTask(proVec,taskNum,popNum,Vlimit)
%INITTASK 此处显示有关此函数的摘要
%   此处显示详细说明
    taskSet{taskNum} = {};
    featureNum = size(proVec,2);
    for i = 1:taskNum
        taskSet{i}.searchSpace = rand(1,featureNum)<proVec;
        taskSet{i}.position = rand(popNum,featureNum).*taskSet{i}.searchSpace;
        taskSet{i}.velocity  = (rand(size(taskSet{i}.position)) - 0.5) * Vlimit(2)*2;
        taskSet{i}.velocity = taskSet{i}.velocity.*taskSet{i}.searchSpace;
    end
    
end

