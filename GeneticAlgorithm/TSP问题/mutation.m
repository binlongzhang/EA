function [ chromosome ] = mutation( chromosome )
%MUTATION ����������λ���,ʵ��Ⱦɫ�����
%   chromosome:Ⱦɫ��
    %�����������
    randSequence = randperm(size(chromosome,2));
    index1 = randSequence(1);
    index2 = randSequence(2);
    % ��������
    temp = chromosome(index1);
    chromosome(index1) = chromosome(index2);
    chromosome(index2) = temp;
end

