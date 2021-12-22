clc
clear
addpath('../../')
data =  importdata('wine.data');
[train,test] = divideData(data,0.7);
disp('原始数据分类分布')
tabulate(data(:,1));
disp('训练数据分类分布')
tabulate(train(:,1))
disp('测试数据分类分布')
tabulate(test(:,1))
allFeatureError = KNNTrainTest(train,test,5,10)
save('data')