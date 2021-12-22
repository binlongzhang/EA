function [ A,B ] = cross( A,B )
%CROSS ����Ⱦɫ�彻��
%   input:A,BΪ����Ⱦɫ��
%   output��A��BΪ������Ⱦɫ��
    L = length(A);
    r1 = randsrc(1,1,1:L);
    r2 = randsrc(1,1,1:L);
    
    % ����
    if r1~=r2
        % ����ԭʼ������
        a0=A;
        b0=B;
        for i = min(r1,r2):max(r1,r2)
            % ���Ƶ�ǰ����,�����ڽ��淢���ظ�ʱ����ԭʼ����ŵ��ظ���ԭʼλ��
            a1 = A;
            b1 = B;
            A(i) = b0(i);
            B(i) = a0(i);
            x = find(A==A(i));
            y = find(B==B(i));
            index1 = x(x~=i);
            index2 = y(y~=i);
            if ~isempty(index1)
                A(index1) = a1(i);
            end
            if ~isempty(index2)
                B(index2) = b1(i);
            end
        end
    end
end

