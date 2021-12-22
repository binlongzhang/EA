function [ x, y ] = exchange( x, y )
%EXCHANGE 交换两个值
    temp = x;
    x = y;
    y = temp;
end


