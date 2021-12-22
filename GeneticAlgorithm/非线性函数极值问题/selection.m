function [ newpop ] = selection( pop,fitValue )
%selection �¸����ѡ��--ת��
%   ���������pop����������Ⱥ��fitValue����Ӧ��ֵ
%   ���������newpop��ѡ������Ⱥ
    [px,py] = size(pop);
    totalfit = sum(fitValue);
    p_fitValue = fitValue/totalfit;
    p_fitValue = cumsum(p_fitValue); % ��������ۼ�ֵ(����ת������)
    ms = sort(rand(px,1));%��С��������ָ��
    
    fitin = 1;
    newin = 1;
    while newin<=px
        if ms(newin)<p_fitValue(fitin)
            newpop(newin,:) = pop(fitin,:);
            newin = newin + 1;
        else
            fitin = fitin + 1;
        end
    end
    
end

