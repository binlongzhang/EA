function [ chromosome ] = reverse( chromosome,distance )
%REVERSE 染色体部分基因随机反转
%  Input： chromosome:对应个体的染色体，distance:对应的距离矩阵
%  output：chromosome随机反转后的染色体
    [row, col] = size(chromosome);
    ObjV = myLength(distance, chromosome);
    chromosome1 = chromosome;
    for i = 1: row
        r1 = randsrc(1, 1, 1:col);
        r2 = randsrc(1, 1, 1:col);
        mininverse = min([r1, r2]);
        maxinverse = max([r1, r2]);
        chromosome1(1, mininverse:maxinverse) = chromosome1(i, maxinverse:-1:mininverse);
    end
    if myLength(distance, chromosome1) < ObjV
        chromosome = chromosome1;
    end
end

