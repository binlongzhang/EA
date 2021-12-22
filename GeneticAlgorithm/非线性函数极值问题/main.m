clear;
clc;
%% ��������ѡ��
%�Ŵ�����
epoch = 125
%��Ⱥ��С
popsize=125
%�����Ʊ��볤��
chromlength=10
%�������
pc = 0.6
%�������
pm = 0.001
%��ʼ��Ⱥ
pop = InitPop(popsize,chromlength);  % ��Ⱥ��С

%% ��ʼ����
for i = 1:epoch
    
    x1 = binary2Decimal(pop);
    y1 = calculateObj(pop);
    subplot(2,3,1);
    fplot(@(x)10*sin(5*x)+7*abs(x-5)+10,[0 10]);
    hold on;
    plot(x1,y1,'*');
    title('��ʼֵ');
    
    
    %������Ӧ��
    objValue = calculateObj(pop);
    fitValue = objValue;
    
    %ѡ�񡢽��桢����
    newpop = selection(pop,fitValue);
    newpop = crossover(newpop,pc);
    newpop = mutation(newpop,pm);
    %����
    pop = newpop;
    


    x1 = binary2Decimal(newpop);
    y1 = calculateObj(newpop);
    
    if mod(i,25) == 0
        subplot(2,3,floor(i/25)+1);
        fplot(@(x)10*sin(5*x)+7*abs(x-5)+10,[0 10]);
        hold on;
        plot(x1,y1,'*');
        title(['��������Ϊn=' num2str(i)]);
    end
end

%% Ѱ�����Ž�
[bestindividual,bestfit] = best(pop,fitValue);
x2 = binary2Decimal(bestindividual);
fprintf('The best X is --->>%5.2f\n',x2);
fprintf('The best Y is --->>%5.2f\n',bestfit);

    