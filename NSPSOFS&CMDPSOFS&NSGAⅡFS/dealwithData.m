% % 加载数据 wine
% data = load('data/wine/wine.data');
% disp('原始数据分类分布')
% tabulate(data(:,1));
% [train,test] = divideData(data,0.7);
% disp('训练数据分类分布')
% tabulate(train(:,1))
% disp('测试数据分类分布')
% tabulate(test(:,1))
% trainData = data(:,2:14);
% trainLabel = data(:,1);
%%
data =  importdata('data/zoo/zoo.data').data(:,[17 1:16]);
[train,test] = divideData(data,0.7);
disp('原始数据分类分布')
tabulate(data(:,17));
[train,test] = divideData(data,0.7);
disp('训练数据分类分布')
tabulate(train(:,17))
disp('测试数据分类分布')
tabulate(test(:,17))

% trainData = data(:,2:14);
% trainLabel = data(:,1);
% trainData = train(:,1:16);
% trainLabel = train(:,17);
% 
% Mdl = fitcknn(trainData,trainLabel,NumNeighbors=5);
% CVMdl = crossval(Mdl,KFold=10);
% loss = kfoldLoss(CVMdl);

allError = KNNTrainTest(train,test,5,10)