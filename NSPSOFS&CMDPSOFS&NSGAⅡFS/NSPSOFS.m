clc;
clear;
close all;
warning off;

%% 加载数据
dataname = 'Hill'
dataPath = ['data/' dataname '/data.mat'];
savePath = ['result/NSPSOFS/' dataname];
load(dataPath);
result = [];
for inden = 1:10
    %% 超参数设置
    N = 30;                             % 初始种群个数
    dim = size(train,2)-1;              % 空间维数
    objDim = 2;
    epoches = 100;                      % 最大迭代次数     
    limit = [0, 1];                     % 设置位置参数限制
    vlimit = [-0.6, 0.6];               % 设置速度限制
    w = 0.7298;                         % 惯性权重
    c1 = 1.49618;                       % 自我学习因子
    c2 = 1.49618;                       % 群体学习因子 
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
    % 计算全部特征都使用的准确率
%     allError = KNNTrainTest(train,test,neighborNum,kFold)  
    %% 开始迭代
    for iter = 1:epoches    
        disp(['inden == '  int2str(inden) ',iter == '  int2str(iter)]);
        evaluate = critical(train(:,2:end),train(:,1),x,theta,neighborNum,kFold);
        nondomIndex = nondominateSolution(evaluate);
        nonDomS =[nondomIndex,evaluate(nondomIndex,:)];
        crowdDis = crowdDistance(evaluate(nondomIndex,:));
        nonDomS = sortrows([crowdDis',nonDomS],1);
        nonDomS = nonDomS(nonDomS(:,1)==min(nonDomS(:,1)) , :);

        union = x;
        xNew = zeros(size(x));
        for i = 1:N
            %   更新pbest
            if isDominate(evaluate(i,:),pbestY(i,:))
                pbestX(i,:) = x(i,:);
                pbestY(i,:) = evaluate(i,:);
            end
            choicedIndex =nonDomS( randperm(size(nonDomS,1),1),2 );
            gBestX = x(choicedIndex,:);
            %  速度更新，新速度 = 原始速度 + 个体自学习 + 群体学习
            v(i,:) = v(i,:) * w + c1 * rand * (pbestX(i,:) - x(i,:)) + c2 * rand * (gBestX - x(i,:));% 速度更新
            % 边界速度处理
            v(i,v(i,:) > vlimit(2)) = vlimit(2);
            v(i,v(i,:) < vlimit(1)) = vlimit(1);
            xNew(i,:) = x(i,:) + v(i,:);% 位置更新
            % 边界位置处理
            xNew(i,xNew(i,:) > limit(2)) = limit(2);
            xNew(i,xNew(i,:) < limit(1)) = limit(1);       
        end
        union = [union;xNew];
        evaluate = [evaluate;critical(train(:,2:end),train(:,1),xNew,theta,neighborNum,kFold)];
        frontValue = nondominateSort(evaluate);

        nextX = [];
        selectIndex = 1;
        for i = 1:max(frontValue)
            tempIndex = (frontValue == i);
            if sum(tempIndex) <= (N-size(nextX,1))
                x(1:sum(tempIndex),:) = union(tempIndex,:);
                selectIndex = selectIndex + sum(tempIndex);
            else
                tempParticle =  union(tempIndex,:);
                tempDis = crowdDistance(tempParticle);
                [~,tempCrowdIndex] = sortrows([tempDis',tempParticle],1);
                x(selectIndex:N,:) = tempParticle(tempCrowdIndex(1:(N-size(nextX,1)),:),:);
                break;
            end
        end
    end

    %%  在测试集上为F1计算准确率
    solution = union(frontValue==1,:);
    solutionIndex = solution > theta;
    % solutionEvaluate = evaluate(frontValue==1,:);
    [solutionNum,solutionTrainErr,solutionTestErr] = calResult(train,test,solution,theta,neighborNum,kFold);
    % critical(test(:,2:end),test(:,1),solution,theta,neighborNum,kFold);
    result = [result;solutionNum,solutionTrainErr,solutionTestErr];
end

save(savePath)

% %% 结果可视化
% load(savePath);
% testmean = [];
% for i  = 1:max(result(:,1))
%     temp = result(find(result(:,1) == i),:);
%     if size(temp,1)~=0
%         testmean = [testmean;mean(temp,1)];
%     end
% end
% 
% resultMin = result(nondominateSolution(result(:,[1 3])),[1 3]);
% resultMin = unique(resultMin,'rows');
% plot(testmean(:,1),testmean(:,3)*100,resultMin(:,1),resultMin(:,2)*100)
% legend('NSPOSFS-A','NSPOSFS-B')
% title(['wine(' num2str(allFeatureError(2)*100) +'%)'])


