clc;
clear;
close all;
rng(10)
%% K折KNN
load fisheriris;
x = meas;
y = species;
Mdl = fitcknn(x,y,NumNeighbors=4);
CVMdl = crossval(Mdl,KFold=10);


rloss = resubLoss(Mdl)
kloss = kfoldLoss(CVMdl)

% pre = predict(Mdl,x);
% loss(mdl,x,y)


%% k折交叉验证

load fisheriris
indices = crossvalind('Kfold',species,10);
cp = classperf(species);

for i = 1:10
    test = (indices == i); 
    train = ~test;
    %分别取第1、2、...、10份为测试集，其余为训练集

    class = classify(meas(test,:),meas(train,:),species(train,:));
    classperf(cp,class,test);

end