function [ len ] = myLength( distance, chromosome )
%myLength ����Ӧ·���ľ���
%   distance: ͼ�ľ������--����Ȩͼ
%   chromesome:���ڵ���Ⱦɫ�壬����洢�����г��е��������
    [~,N] = size(distance);
    len = distance(chromosome(1,N),chromosome(1,1));
    for i = 1:(N-1)
        len = len + distance(chromosome(1,i),chromosome(1,i+1));
    end
end

