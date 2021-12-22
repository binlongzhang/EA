function [population] = mutation(population,maxvalue,minvalue)
%mutation 变异操作-多项式变异
%   输入：pop种群
%   输出：newPop新种群

[~,popLength] = size(population);
k=rand(size(population)); 
miu=rand(size(population));
temp=k<1/popLength & miu<0.5;   %要变异的基因位
population(temp)=population(temp)+(maxvalue(temp)-minvalue(temp)).*((2.*miu(temp)+(1-2.*miu(temp)).*(1-(population(temp)-minvalue(temp))./(maxvalue(temp)-minvalue(temp))).^21).^(1/21)-1);        %变异情况一
population(temp)=population(temp)+(maxvalue(temp)-minvalue(temp)).*(1-(2.*(1-miu(temp))+2.*(miu(temp)-0.5).*(1-(maxvalue(temp)-population(temp))./(maxvalue(temp)-minvalue(temp))).^21).^(1/21));  %变异情况二

end

