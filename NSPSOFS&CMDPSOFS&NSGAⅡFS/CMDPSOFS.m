clc;
clear;
close all;
%% 加载数据
dataname = 'Hill'
dataPath = ['data/' dataname '/data.mat'];
savePath = ['result/CMDPSOFS/' dataname];
load(dataPath);
archiveAll = {};
for inden = 1:10
    %% 超参数设置
    N = 30;                             % 初始种群个数
    dim = size(train,2)-1;              % 空间维数
    objDim = 2;
    epoches = 100;                      % 最大迭代次数     
    limit = [0, 1];                     % 设置位置参数限制
    vlimit = [-0.6, 0.6];               % 设置速度限制
    w = [0.1,0.4];                      % 惯性权重的起点和范围
    c = [1.5,0.5];                       % 学习因子的起点和范围
    theta = 0.6;                        % 选取特征的界限
    neighborNum = 5;                    % 邻居数量
    kFold = 10;                         % k折交叉验证
    %% 种群初始化
    % 随机分布
    x = limit(1) + (limit(2) - limit(1)) * rand(N, dim);                            % 初始种群的位置
    v = (rand(N, dim).*2-1).*vlimit(2);                                             % 初始种群的速度,随机产生
    pbestX = x;                                                                     % 每个个体的历史最佳位置
    gBestX = zeros(1, dim);                                                         % 种群的历史最佳位置
    pbestY = critical(train(:,2:end),train(:,1),x,theta,neighborNum,kFold);         % 每个个体的历史最佳适应度
    nondomIndex = nondominateSolution(pbestY);
    leaderSet = x(nondomIndex,:);
    leaderY = pbestY(nondomIndex,:);
    leaderDis = crowdDistance(leaderY);
    archiveX = [];
    archiveY = [];
%     allError = KNNTrainTest(train,test,neighborNum,kFold)  

    %% 开始迭代
    for iter = 1:epoches

        disp(['inden == '  int2str(inden) ',iter == '  int2str(iter)]);

        % 速度更新
        for i = 1:N
            % 获取gbest
            % 随机选择两个个体
            temp = randi(size(leaderSet,1),1,2);    
            % 比较这两个个体的适应度值大小，选择小的
            if leaderDis(temp(1)) < leaderDis(temp(2))
                gbestIndex = temp(1);
            else
                gbestIndex = temp(2);
            end
            gBestX = leaderSet(gbestIndex,:);
            %  速度更新，新速度 = 原始速度 + 个体自学习 + 群体学习
            tempW = rand()*w(2) + w(1);
            c1 = rand()*c(2) + c(1);
            c2 = rand()*c(2) + c(1);
            v(i,:) = v(i,:) * tempW + c1 * rand * (pbestX(i,:) - x(i,:)) + c2 * rand * (gBestX - x(i,:));% 速度更新    
        end 
        % 边界速度处理
        v(v > vlimit(2)) = vlimit(2);
        v(v < vlimit(1)) = vlimit(1);
        x = x + v;% 位置更新
        % 边界位置处理
        x(x > limit(2)) = limit(2);
        x(x < limit(1)) = limit(1);


        % mutation操作
        x = mutation(x,iter,epoches);
        % 评价每个粒子
        evaluate = critical(train(:,2:end),train(:,1),x,theta,neighborNum,kFold);

        %   更新pbest
        for i = 1:N
            if isDominate(evaluate(i,:),pbestY(i,:))
                pbestX(i,:) = x(i,:);
                pbestY(i,:) = evaluate(i,:);
            end
        end
        tempLeaderSet = [leaderSet;x];
        tempLeaderY = [leaderY;evaluate];
        nondomIndex = nondominateSolution(tempLeaderY);
        leaderSet = tempLeaderSet(nondomIndex,:);
        leaderY = tempLeaderY(nondomIndex,:);
    %     unionX = [leaderSet;x];
    %     unionY = [leaderY;evaluate];
    %     nondomIndex = nondominateSolution(unionY);
    %     leaderSet = unionX(nondomIndex,:);
    %     leaderY = unionY(nondomIndex,:);   
        archiveX = [archiveX;leaderSet];
        archiveY = [archiveY;leaderY];

        leaderDis = crowdDistance(leaderY);
    end
    archiveAll{inden} ={archiveX,archiveY} ;
end
save(savePath)


% % 计算结果
% solutionIndex = nondominateSolution(archiveY);
% solution = archiveX(solutionIndex,:);
% solutionFlag = solution > theta;
% [solutionFlag,solutionIndex] = unique(solutionFlag,'row');
% solution = solution(solutionIndex,:);
% 
% [solutionNum,solutionTrainErr,solutionTestErr] = calResult(train,test,solution,theta,neighborNum,kFold);
% result = [result;solutionNum,solutionTrainErr,solutionTestErr];




%% 结果可视化
% testmean = [];
% for i  = 1:max(result(:,1))
%     temp = result(find(result(:,1) == i),:);
%     if size(temp,1)~=0
%         testmean = [testmean;mean(temp,1)];
%     end
% end
% 
% resultMin = result(nondominateSolution(result(:,[1 3])),[1 3]);
% resultMin = unique(resultMin,'rows')
% plot(testmean(:,1),testmean(:,3)*100,resultMin(:,1),resultMin(:,2)*100)
% legend('CMDPOSFS-A','CMDPOSFS-B')
% title(['wine(' num2str(allError(2)*100) +'%)'])
