function [proFeatures,remFeatures,taskGenerateP] = kneePointSelectStrategy(dataX,dataY,ReliefFParms)
%KNEEPOINTSELECTSTRATEGY 此处显示有关此函数的摘要
%   此处显示详细说明
    featureNum = size(dataX,2);

    % 这里没有专门验证对比，直接使用matlab封装的Relieff
    [idx,weights] = relieff(dataX,dataY,ReliefFParms);
    % 这里weights权重会出现负数影响后续操作，没有详细研究，暂时做了如下处理,该处理对结果影响应该是相对较小的
    if min(weights) < 0
        weights = weights - min(weights);
    end
    point = [1:featureNum;sort(weights,'des')];

    % 计算点到L的距离
    dis = zeros(1,featureNum);
    for i = 1:featureNum
        dis(i) = abs(det([point(:,featureNum)-point(:,1),point(:,i)-point(:,1)]))/norm(point(:,featureNum)-point(:,1));
    end
    [~,KN_pointIndex] = max(dis);
    proFeatures = idx(1:KN_pointIndex);
    remFeatures = idx(KN_pointIndex+1:end);
    
    meanWeightPro = mean(weights(proFeatures),2);
    meanWeightRem = mean(weights(remFeatures),2);
    p = meanWeightPro / (meanWeightPro+meanWeightRem);
    taskGenerateP = ones(1,featureNum);
    taskGenerateP(proFeatures) = p;
    taskGenerateP(remFeatures) = 1 - p;

end

