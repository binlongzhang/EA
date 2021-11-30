clear
clc
tic
dataList = {'Brain_Tumor_2','11_Tumor','Lung_Cancer'};
for name = 1:numel(dataList)

    dataName = dataList{name};
    load(['data/' dataName]);
    dataX = mapminmax(X',0,1)';
    dataY = Y;
    clear X Y;
    foldNum = 10;

    [newIDX,promisingFeature.KN_point,promisingFeature.weights] = featureSelect(dataX,dataY);
    promisingFeature.subset = false(1,size(dataX,2));
    promisingFeature.subset(1:promisingFeature.KN_point) = true;
    dataX = dataX(:,newIDX);
    promisingFeature.weights = promisingFeature.weights(newIDX);

    result = {};
    for i = 1:10
        indices = crossvalind('Kfold',dataY,foldNum);
        depen = {};
        for fold = 1:foldNum
            trainX = dataX(indices ~= fold,:);
            trainY = dataY(indices ~= fold,:); 
            testX = dataX(indices == fold,:);
            testY = dataY(indices == fold,:); 
            res = PSO_EMT(trainX, trainY, dataName,fold,promisingFeature);
            [res.featureNum,res.acc] = test(trainX,trainY,testX,testY,res);
            depen{fold} = res;
            disp(strcat("PSO_EMT on, ", dataName,'run == ',num2str(i)," fold ==", num2str(fold),' ,feature num ==',num2str(res.featureNum),' ,test Acc ==',num2str(res.acc),' ,time==',num2str(toc)));
        end
        result{i} = depen;
    end

    save(['result\' dataName]);
end
