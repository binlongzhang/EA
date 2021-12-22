function [ A,B ] = cross( A,B )
%CROSS 两段染色体交叉
%   input:A,B为两段染色体
%   output：A，B为交叉后的染色体
    L = length(A);
    r1 = randsrc(1,1,1:L);
    r2 = randsrc(1,1,1:L);
    
    % 交叉
    if r1~=r2
        % 备份原始基因型
        a0=A;
        b0=B;
        for i = min(r1,r2):max(r1,r2)
            % 复制当前基因,用于在交叉发生重复时，将原始基因放到重复的原始位置
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

