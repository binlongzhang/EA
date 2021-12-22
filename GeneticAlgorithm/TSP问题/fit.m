function [ fitness ] = fit( len,m,maxlen,minlen )
%FIT 计算适应度
%   output：fitness对应的适应度
%   input:
%       len：对应种群的长度矩阵；
%       m：应值归一化淘汰加速指数，大的更大， 小的更小；
%       maxlen：最大长度;
%       minlen：最小长度;
    fitness = len;
    for i = 1:length(len)
        fitness(i, 1) = (1 - (len(i)-minlen)/(maxlen-minlen+0.0001)).^m;
    end
end

