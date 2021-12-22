function [ obj ] = calculateObj( pop )
%calculateObj 计算函数的目标值
%   输入变量： pop：二进制数
%   输出变量： obj：目标函数值
    x = binary2Decimal(pop);
    obj = 10*sin(5*x)+7*abs(x-5)+10;
end

