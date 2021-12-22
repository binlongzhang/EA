clc
clear
%% 超参数
% DLBCL SRBCT 9Tumor Leukemia1
dataName = 'Brain1';
load(['data1/' dataName])
dataX = data;
dataY = label;

SUDivideNum = 10;
featureNum = size(dataX,2);
popSize = min(ceil(featureNum/20),300);
c1 = 1.49445;
c2 = 1.49445;
maxIters = 100;
alpha = 7;
beta = 9;
lambda = 0.9;
vMin = -0.6;
vMax = 0.6;
fitnessFun = @fitnessKfold;
%% 初始化filter
%基于SU排序
su = zeros(1,size(dataX,2));
for i = 1:size(dataX,2)
   su(i) = SU(dataX(:,i),dataY,SUDivideNum);
end
[~,dataIndex] = sort(su,'des');
dataX = dataX(:,dataIndex);

swarms{20} = {};
%% 20次独立运行
for epoch = 1:20
    disp(['第' num2str(epoch) '运行'])
    rng(epoch)
    %初始化种群
    swarm = init(featureNum,popSize,vMin,vMax); 
    %初始化fitness
    for p = 1:swarm.popSize
        swarm.particle{p}.fitness = fitnessFun(swarm.particle{p},dataX,dataY,swarm.threshold,swarm.lambda);
        swarm.particle{p}.pBest.fitness = swarm.particle{p}.fitness;
        swarm.fitness(p) = swarm.particle{p}.fitness;
    end
    %更新gbest
    [~,gBestIndex] = max(swarm.fitness);
    swarm.gBest.pos = swarm.particle{gBestIndex}.position;
    swarm.gBest.fitness = swarm.fitness(gBestIndex);
    %更新fitness排序
    [~,swarm.fitSortIndex]=sort(swarm.fitness,'descend');
    %更新pc
    swarm = updatePc(swarm);
    %更新exemplar for all
    for p = 1:swarm.popSize
        swarm.particle{p}.exemplar = getExemplar(swarm,p);
    end

    % 用于记录收敛过程
    tic
%     recordParticle{maxIters} = {};
%     record = zeros(1,swarm.popSize);
%     recordTime = zeros(1,swarm.popSize);
    %所有特征的准确率
    fullAcc = balanceAcc(dataX,dataY)
    
    %开始迭代 
    for iter = 1:maxIters
       w = 0.9 - 0.5*(iter/maxIters);
       for p = 1:swarm.popSize
           if(swarm.renewExemplar(p))
                swarm.particle{p}.exemplar = getExemplar(swarm,p);
                swarm.renewExemplar(p) = false;
           end
           %更新速度位置
           v = zeros(1,swarm.particleLen(p));
           for d = 1:swarm.particleLen(p)
               exemIndex = swarm.particle{p}.exemplar(d);
               v(d) = c1*rand()*(swarm.particle{exemIndex}.position(d)-swarm.particle{p}.position(d));
           end
           v = v + swarm.particle{p}.velocity;
           %检查越界
           v(v>vMax) = vMax;
           v(v<vMin) = vMin;
           swarm.particle{p}.velocity = v;
           %位置
           swarm.particle{p}.position = swarm.particle{p}.position + v;
           swarm.particle{p}.position(swarm.particle{p}.position>1) = 1;
           swarm.particle{p}.position(swarm.particle{p}.position<0) = 0;
    %        if(swarm.particle{p}.pBestNotImprove == alpha)
    %            v = zeros(1,swarm.particleLen(p));
    %            for d = 1:swarm.particleLen(p)
    %                exemIndex = swarm.particle{p}.exemplar(d);
    %                v(d) = c1*rand()*(swarm.particle{exemIndex}.position(d)-swarm.particle{p}.position(d));
    %            end
    %            v = v + swarm.particle{p}.velocity;
    %            %检查越界
    %            v(v>vMax) = vMax;
    %            v(v<vMin) = vMin;
    %            swarm.particle{p}.velocity = v;
    %            %位置
    %            swarm.particle{p}.position = swarm.particle{p}.position + v;
    %            swarm.particle{p}.position(swarm.particle{p}.position>1) = 1;
    %            swarm.particle{p}.position(swarm.particle{p}.position<0) = 0;
    %            swarm.particle{p}.pBestNotImprove = 0;
    %        else
    %            particleSize = min([swarm.particleLen(p),size(swarm.particle{p}.pBest.pos,2),size(swarm.gBest.pos,2)]);
    %            v = zeros(size(swarm.particle{p}.position));
    %            v(1:particleSize) =  v((1:particleSize))  + ...
    %                c1.*rand(1,particleSize).*(swarm.particle{p}.pBest.pos(1:particleSize)-swarm.particle{p}.position(1:particleSize))+ ...
    %                c2.*rand(1,particleSize).*(swarm.gBest.pos(1:particleSize) - swarm.particle{p}.position(1:particleSize));
    %             v = v + w * swarm.particle{p}.velocity;
    %             %检查越界
    %             v(v>vMax) = vMax;
    %             v(v<vMin) = vMin;
    %             swarm.particle{p}.velocity = v;
    %             %位置
    %             swarm.particle{p}.position = swarm.particle{p}.position + v;
    %             swarm.particle{p}.position(swarm.particle{p}.position>1) = 1;
    %             swarm.particle{p}.position(swarm.particle{p}.position<0) = 0;
    %        end

           %更新fitness和pbest
           swarm.particle{p}.fitness = fitnessFun(swarm.particle{p},dataX,dataY,swarm.threshold,swarm.lambda);
           swarm.fitness(p) = swarm.particle{p}.fitness;
           if(swarm.particle{p}.pBest.fitness < swarm.fitness(p))
                swarm.particle{p}.pBest.pos = swarm.particle{p}.position;
                swarm.particle{p}.pBest.fitness = swarm.fitness(p);
                swarm.particle{p}.pBestNotImprove = 0;
           else
                swarm.particle{p}.pBestNotImprove = swarm.particle{p}.pBestNotImprove+1; 
           end

           if(swarm.particle{p}.pBestNotImprove  == alpha)
               swarm.renewExemplar(p) = true;
           end
       end
       %更新gbest
       [gBestFitness,gBestIndex] = max(swarm.fitness);
       if(swarm.gBest.fitness < gBestFitness)
           swarm.gBest.pos = swarm.particle{gBestIndex}.position;
           swarm.gBest.fitness = gBestFitness;
           swarm.gBest.notChange = 0;
       else
           swarm.gBest.notChange = swarm.gBest.notChange +1;
       end

       if(swarm.gBest.notChange==beta)
           swarm = lengthChange(swarm,dataX,dataY,fitnessFun);
           swarm.gBest.notChange = 0;
       end
       if(any(swarm.renewExemplar))
            swarm = updatePc(swarm);
       end

%        record(iter) = swarm.gBest.fitness;
%        recordTime(iter) = toc;
%        recordParticle{iter}.pos = swarm.gBest.pos;
%        recordParticle{iter}.Acc = balanceAcc(dataX(:,swarm.gBest.pos > swarm.threshold),dataY);
       disp(['iter == ' num2str(iter) '   |  gBestFitness == ' num2str(swarm.gBest.fitness) '     |ACC==  ' num2str(balanceAcc(dataX(:,swarm.gBest.pos > swarm.threshold),dataY)) '   |  time == ' num2str(toc)])

    end
    
    swarms{epoch} = swarm;
end
%% 结果可视化
% plot(record);
% title('收敛过程')
