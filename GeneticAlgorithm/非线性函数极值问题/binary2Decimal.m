function pop2  = binary2Decimal( pop )
%bin2Decimal ������תʮ����
%   pop������Ķ�������Ⱥ
%   
    [px,py] = size(pop);
    for i = 1:py
        pop1(:,i) = 2.^(py-i).*pop(:,i);
    end
    
    temp = sum(pop1,2);
    pop2 = temp*10/1023;

end

