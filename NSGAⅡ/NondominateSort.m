function [frontValue] = NondominateSort(functionValue)
%NONDOMINATESORT 实现非直配排序
%   此处显示详细说明

frontNum = 0;
functionValueLen = size(functionValue,1);
flag = false(1,functionValueLen);
frontValue = zeros(size(flag));
[functionvalue_sorted,originIndex]=sortrows(functionValue);    %对种群按第一维目标值大小进行排序

while ~all(flag)
    frontNum = frontNum + 1;
    temp = flag;
    for i = 1:functionValueLen
        if ~temp(i)
            for j = i+1:functionValueLen
                if ~temp(j)
                    % 检测支配关系
                    flagDominate = true;
                    for k = 2:size(functionValue,2)
                        if functionvalue_sorted(i,k)>functionvalue_sorted(j,k)
                            flagDominate = false;break;
                        end
                    end
                    if flagDominate
                        temp(j) = true;
                    end
                end
            end
            
            frontValue(originIndex(i))=frontNum;
            
            flag(i)=true;
        end
    end
end
    
end

