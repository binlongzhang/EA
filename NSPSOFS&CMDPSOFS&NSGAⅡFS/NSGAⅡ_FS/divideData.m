function [train,test] = divideData(data,trainRate)
%DIVIDEDATA 将数据划分成训练集和测试集
%   data为输入数据集，trainRate为训练集所占比例
    [dataNum,~ ]= size(data);
    randIndex = randperm(dataNum);
    train = data( randIndex(1:round(dataNum*trainRate))   ,:);
    test =  data( randIndex(round(dataNum*trainRate):end) ,:);
end

