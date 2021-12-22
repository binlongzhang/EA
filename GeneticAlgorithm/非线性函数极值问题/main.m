clear;
clc;
%% 超参数的选择
%遗传轮数
epoch = 125
%种群大小
popsize=125
%二进制编码长度
chromlength=10
%交叉概率
pc = 0.6
%变异概率
pm = 0.001
%初始种群
pop = InitPop(popsize,chromlength);  % 种群大小

%% 开始繁衍
for i = 1:epoch
    
    x1 = binary2Decimal(pop);
    y1 = calculateObj(pop);
    subplot(2,3,1);
    fplot(@(x)10*sin(5*x)+7*abs(x-5)+10,[0 10]);
    hold on;
    plot(x1,y1,'*');
    title('初始值');
    
    
    %计算适应度
    objValue = calculateObj(pop);
    fitValue = objValue;
    
    %选择、交叉、变异
    newpop = selection(pop,fitValue);
    newpop = crossover(newpop,pc);
    newpop = mutation(newpop,pm);
    %更新
    pop = newpop;
    


    x1 = binary2Decimal(newpop);
    y1 = calculateObj(newpop);
    
    if mod(i,25) == 0
        subplot(2,3,floor(i/25)+1);
        fplot(@(x)10*sin(5*x)+7*abs(x-5)+10,[0 10]);
        hold on;
        plot(x1,y1,'*');
        title(['迭代次数为n=' num2str(i)]);
    end
end

%% 寻找最优解
[bestindividual,bestfit] = best(pop,fitValue);
x2 = binary2Decimal(bestindividual);
fprintf('The best X is --->>%5.2f\n',x2);
fprintf('The best Y is --->>%5.2f\n',bestfit);

    