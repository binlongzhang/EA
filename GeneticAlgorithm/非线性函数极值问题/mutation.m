function [ newpop ] = mutation( pop,mutationRate )
%mutation GA�㷨�ı������
%   ���������pop����������Ⱥ��mutationRate���������
%   ���������newpop����������Ⱥ
    [px,py] = size(pop);
    newpop = ones(size(pop));

    for i = 1:px
        if(rand<=mutationRate)
            %����λ��
            mutationPoint = ceil(rand*py);
            newpop(i,:) = pop(i,:);
            %�������
            newpop(i,mutationPoint) = ~ newpop(i,mutationPoint);
        else
            newpop(i,:) = pop(i,:);
        end

    end
end

