function [ obj ] = calculateObj( pop )
%calculateObj ���㺯����Ŀ��ֵ
%   ��������� pop����������
%   ��������� obj��Ŀ�꺯��ֵ
    x = binary2Decimal(pop);
    obj = 10*sin(5*x)+7*abs(x-5)+10;
end

