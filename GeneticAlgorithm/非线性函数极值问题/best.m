function [ bestIndividual bestFit ] = best( pop,fitValue )
%best Ѱ�����Ÿ���������Ӧ��
%   ���������pop����Ⱥ��fitvalue����Ⱥ��Ӧ��
%   ���������bestIndividual:��Ѹ��壬bestFit:�����Ӧֵ
    [px,py] = size(pop);
    
    % ����Ĭ��ֵ
    bestIndividual = pop(1,:);
    bestFit = fitValue(1);
    
    for i=2:px
        if fitValue(i)>bestFit
            bestIndividual = pop(i,:);
            bestFit = fitValue(i);
        end
    end

end

