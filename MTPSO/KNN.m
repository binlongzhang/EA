function [preLabel] = KNN(trainX,trainY,testX)
%KNN 比fitcknn快1/3,事实上还能更快
%   此处显示详细说明
    neighborNum = 5;
    
    Dis = pdist2(testX,trainX,'cityblock');
    
    testNum = size(testX,1);
    neighborPosition = zeros(testNum,neighborNum); 
    
    for i= 1:neighborNum
        [~,minPos]  = min(Dis,[],2);
        neighborPosition(:,i) = minPos;
        for j = 1:testNum
           Dis(j,minPos(j)) = inf; 
        end
    end
    y = trainY(neighborPosition);
    
    
    preLabel = mode(y,2);
    
%     NumNeighbors = 10;
%     Mdl = fitcknn(trainX,trainY,NumNeighbors=NumNeighbors);
%     label = predict(Mdl,testX);
end
