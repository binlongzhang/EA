function [pop] = initPop(popSize,featureNum,dataX,dataY)
%INITPOP 
    D = featureNum;
    % 对决策变量打分
    Dec = ones(D);
    mask = eye(D);
    Q = mask.*Dec;
    fitness = getFitness(dataX,dataY,Q);
    score = NondominateSort(fitness);

    % 初始化种群
    Dec = ones(popSize,featureNum);
    mask = zeros(popSize,featureNum);
    for i = 1:popSize
       index = randi(featureNum,floor(rand()*featureNum),2);
       for j = 1:size(index,1)
            m = index(j,1);
            n = index(j,2);
            if(score(m)  < score(n) )
               mask(i,m) = 1; 
            else
               mask(i,n) = 1;
            end
       end
    end
    pop = Dec.*mask;
end

