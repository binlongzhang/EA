clear;
clc;
close all;
% origin�������ڴ洢ԭʼ���ɵ�·�ߣ�populationΪ������epoches��֮�����Ⱥ
%% ������
county_size = 20;
countys_size = 40; %���Ե���Ⱥ��
epoches = 200;
m = 2;      % ��Ӧֵ��һ����̭����ָ��
cross_rate = 0.4;
mutation_rate = 0.02;
%% ���ɲ�������
% ���ɳ�������
position = randn(county_size, 2);
% ���ɳ���֮��ľ������
distance = zeros(county_size, county_size);
for i = 1:county_size
    for j = i+1:county_size
        dis = (position(i, 1) - position(j, 1))^2 + (position(i, 2) - position(j, 2))^2;
        distance(i, j) = dis^0.5;
        distance(j, i) = distance(i, j);
    end
end
%% ���ɳ�ʼ��Ⱥ
population = zeros(countys_size, county_size);
for i = 1: countys_size
    population(i, :) = randperm(county_size);
end
% ���ڱ���ԭʼ����
origin = population;
%% ��ʼ����Ⱥ��Ӧ�ĳ��ȼ�������Ӧ����
fitness = zeros(countys_size,1);
len = zeros(countys_size,1);
for i = 1: countys_size
    len(i, 1) = myLength(distance, population(i, :));
end
maxlen = max(len);
minlen = min(len);
fitness = fit(len, m, maxlen, minlen);
%% ��ѯ��ʼ��Ⱥ�����·��
rr = find(len == minlen);  % ���Բ�ѯ���
pop = population(rr(1, 1), :);
fprintf('�������·��Ϊ%d \n·��Ϊ', minlen);
for i = 1: county_size
    fprintf('%d  ', pop(i));
end
fprintf('\n');

%% ����ʾ��ͼ��
figure(1);
scatter(position(:, 1), position(:, 2), 'k.');
xlabel('x');
ylabel('y');
title('������зֲ����');
axis([-3, 3, -3, 3]);
figure(2);
plot_route(position, pop);
xlabel('x');
ylabel('y');
title('��ʼ��Ⱥ���TSP·��');
axis([-3, 3, -3, 3]);
%% ��ʼ���洢����
fitness = fitness/sum(fitness);  % ��Ӧ��
distance_min = zeros(epoches + 1, 1);  % ÿ��cpoch����Сֵ·��
population_sel = zeros(countys_size + 1, county_size); % ÿ��������Ⱥ

%% ��ʼ����
for epoch = 1:epoches+1
    p_fitness = cumsum(fitness);
    nn = 0;
    for i = 1:size(population,1)
        len_1(i,1) = myLength(distance,population(i,:));
        jc = rand;
        for j = 1:size(population,1)
            if p_fitness(j,1) > jc
                nn = nn+1;
                population_sel(nn,:) = population(j,:);
                break;
            end
        end
    end
    
    % ����ѡ��֮����������֣�������������
    population_sel = population_sel(1:nn, :);
    [len_m, len_index_min] = min(len_1);
    [len_max, len_index_max] = max(len_1);
    population_sel(len_index_max, :) = population_sel(len_index_min, :);%��̭��������
    
    % �������
    rand_rank = randperm(nn);
    A = population_sel(rand_rank(1), :);
    B = population_sel(rand_rank(2), :);
    for i = 1 : nn * cross_rate
        [A, B] = cross(A, B);
        population_sel(rand_rank(1), :) = A;
        population_sel(rand_rank(2), :) = B;
    end
    
    % �������
    for i = 1: nn
        pick = rand;
        if pick <= mutation_rate
            population_sel(i, :) = mutation(population_sel(i, :));
        end
    end
    
    % �����ת���ֻ���Ƭ�Σ�����������£��������Ϊ��������
    for i = 1: nn
        population_sel(i,:) = reverse(population_sel(i,:), distance);
    end
    
    %��Ӧ�Ⱥ�������
    NN = size(population_sel,1);
    len = zeros(NN,1);
    for i = 1: NN
        len(i, 1) = myLength(distance, population_sel(i, :));
    end
    maxlen = max(len);
    minlen = min(len);
    distance_min(epoch, 1) = minlen;
    fitness = fit(len, m, maxlen, minlen);
    
    % ��ʾ���
    if mod(epoch,50)==0
        disp('*****************************************************************')
        fprintf('���������� %d\n', epoch);
        rr = find(len == minlen);  
        fprintf('minlen�� %d\n', minlen);
        disp('·��Ϊ��')
        disp(population_sel(rr(1, 1), :))
    end
    
    population = population_sel;

end

%% չʾ�����Ż���Ľ��
rr = find(len == minlen);
figure(3);
plot_route(position, population(rr(1, 1),:));
xlabel('x');
ylabel('y');
title('�Ż��������TSP·��');
axis([-3, 3, -3, 3]);   




