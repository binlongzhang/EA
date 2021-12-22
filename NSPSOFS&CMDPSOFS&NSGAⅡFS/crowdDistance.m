function [CrowdDis] = crowdDistance(evaluate)
%CROWDDISTANCE 计算并返回拥挤距离
%   此处显示详细说明
    [N,M]    = size(evaluate);
    CrowdDis = zeros(1,N);
    Fmax     = max(evaluate,[],1);
    Fmin     = min(evaluate,[],1);
    for i = 1 : M
        [~,rank] = sortrows(evaluate(:,i));
        CrowdDis(rank(1))   = inf;
        CrowdDis(rank(end)) = inf;
        for j = 2 : N-1
            CrowdDis(rank(j)) = CrowdDis(rank(j))+(evaluate(rank(j+1),i)-evaluate(rank(j-1),i))/(Fmax(i)-Fmin(i));
        end
    end
end

