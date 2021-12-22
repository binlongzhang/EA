function pop = InitPop( popSize,chromLength )
%InitPop 初始化种群
%  popSize 种群大小
%  chromlength：染色体长度/编码后的长度
    pop = round(rand(popSize,chromLength));
end

