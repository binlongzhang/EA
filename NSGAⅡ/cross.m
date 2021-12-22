function [newpopulation] = cross(pop)
%  交叉操作-算术交叉，此处采用正态交叉
%  指由两个个体的线性组合而产生的两个新的个体，交叉操作的对象一般是由浮点数编码所表示的个体，其定义为两个向量/染色体的组合
%   Input：pop-当前种群   output：newpopulation-交叉后的种群
    [popNum,popLength] = size(pop);
    newpopulation=zeros(popNum,popLength);  
    for i=1:popNum/2                        %交叉产生子代
        k=randperm(popNum);                 %从种群中随机选出两个父母,不采用二进制联赛方法
        beta=(-1).^round(rand(1,popLength)).*abs(randn(1,popLength))*1.481; %采用正态分布交叉产生两个子代
        newpopulation(i*2-1,:)=(pop(k(1),:)+pop(k(2),:))./2+beta.*(pop(k(1),:)-pop(k(2),:))./2;    %产生第一个子代           
        newpopulation(i*2,:)=(pop(k(1),:)+pop(k(2),:))./2-beta.*(pop(k(1),:)-pop(k(2),:))./2;      %产生第二个子代
    end
end

