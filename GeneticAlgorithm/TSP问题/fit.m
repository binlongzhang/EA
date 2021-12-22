function [ fitness ] = fit( len,m,maxlen,minlen )
%FIT ������Ӧ��
%   output��fitness��Ӧ����Ӧ��
%   input:
%       len����Ӧ��Ⱥ�ĳ��Ⱦ���
%       m��Ӧֵ��һ����̭����ָ������ĸ��� С�ĸ�С��
%       maxlen����󳤶�;
%       minlen����С����;
    fitness = len;
    for i = 1:length(len)
        fitness(i, 1) = (1 - (len(i)-minlen)/(maxlen-minlen+0.0001)).^m;
    end
end

