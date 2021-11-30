function [idx,KN_point,weights] = featureSelect(dataX,dataY)
%FEATURESELECT 此处显示有关此函数的摘要
%   此处显示详细说明
    featureNum = size(dataX,2);

    [idx,weights] = relieff(dataX,dataY,10);
    weights(isnan(weights))=0;

    point = [1:featureNum;sort(weights,'des')];

    dis = zeros(1,featureNum);
    for i = 1:featureNum
        dis(i) = abs(det([point(:,featureNum)-point(:,1),point(:,i)-point(:,1)]))/norm(point(:,featureNum)-point(:,1));
    end
    [~,KN_point] = max(dis);    
end

