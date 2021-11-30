function [skillFactor,fitness,fit1,fit2] = getSkillFactorFit(dataX,dataY,pos,subset)
%SKILLFACTOR 此处显示有关此函数的摘要
%   此处显示详细说明

    alpha1 = 0.999999;
    alpha2 = 0.9;
    mask = repmat(subset,size(subset,1),1);

    [featureNum1,error1] = knn5foldFast(dataX,dataY,(pos.*mask)>0.6);
    [featureNum2,error2] = knn5foldFast(dataX,dataY,pos>0.6);
    
    fit1 = alpha1 * error1 + (1-alpha1)*(featureNum1./sum(mask));
    fit2 = alpha2 * error2 + (1-alpha2)*(featureNum2./size(dataX,2));

    [~,idx1] = sort(fit1,'des');
    [~,rank1] = sort(idx1);
    
    [~,idx2] = sort(fit2,'des');
    [~,rank2] = sort(idx2);
    [fitness,skillFactor] = min([rank1 rank2],[],2);
end

