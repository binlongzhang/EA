function [subset] = subsetUpdating(subset,scaleFactor)
%UPDATESUBSET 此处显示有关此函数的摘要
%   此处显示详细说明
    numSelect = sum(subset);
    numChange = floor(numSelect * scaleFactor);
    selectIndex = find(subset==1);
    notSelectIndex = find(subset==0);
    noSelect = selectIndex(randperm(numel(selectIndex),numChange));
    select = notSelectIndex(randperm(numel(notSelectIndex),numChange));
    subset(noSelect) = false;
    subset(select) = true;
end

