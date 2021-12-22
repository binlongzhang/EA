clc
clear
dataname = 'Hill';
theta = 0.6;
neighborNum = 5;
kFold = 10;
dataPath = ['data/' dataname '/data.mat'];
allError = load(['result\' 'NSPSOFS\' dataname]).allFeatureError;
CMDPSOFS_Res = load(['result\' 'CMDPSOFS\' dataname]).archiveAll;
NSPSOFS_Res = load(['result\' 'NSPSOFS\' dataname]).result;
load(dataPath);
%% CMDPSOFS
CMDPSOFS_Result = [];
for i = 1:size(CMDPSOFS_Res,2)
    nodominateIndex = nondominateSolution(CMDPSOFS_Res{i}{2});
    solution = CMDPSOFS_Res{i}{1}(nodominateIndex,:);
    solutionFlag = solution > theta;
    [solutionFlag,solutionIndex] = unique(solutionFlag,'row');
    solution = solution(solutionIndex,:);
    [solutionNum,solutionTrainErr,solutionTestErr] = calResult(train,test,solution,theta,neighborNum,kFold);
    CMDPSOFS_Result = [CMDPSOFS_Result;solutionNum,solutionTrainErr,solutionTestErr];
end
CMDPSOFS_testmean = [];
for i  = 1:max(CMDPSOFS_Result(:,1))
    temp = CMDPSOFS_Result(find(CMDPSOFS_Result(:,1) == i),:);
    if size(temp,1)~=0
        CMDPSOFS_testmean = [CMDPSOFS_testmean;mean(temp,1)];
    end
end
CMDPSOFS_resultMin = CMDPSOFS_Result(nondominateSolution(CMDPSOFS_Result(:,[1 3])),[1 3]);
CMDPSOFS_resultMin = unique(CMDPSOFS_resultMin,'rows');

%% NSPSOFS
NSPSOFS_testmean = [];
for i  = 1:max(NSPSOFS_Res(:,1))
    temp = NSPSOFS_Res(find(NSPSOFS_Res(:,1) == i),:);
    if size(temp,1)~=0
        NSPSOFS_testmean = [NSPSOFS_testmean;mean(temp,1)];
    end
end
NSPSOFS_resultMin = NSPSOFS_Res(nondominateSolution(NSPSOFS_Res(:,[1 3])),[1 3]);
NSPSOFS_resultMin = unique(NSPSOFS_resultMin,'rows');
%% 结果可视化
plot(NSPSOFS_testmean(:,1),NSPSOFS_testmean(:,3)*100,'k',NSPSOFS_resultMin(:,1),NSPSOFS_resultMin(:,2)*100,'r',...
    CMDPSOFS_testmean(:,1),CMDPSOFS_testmean(:,3)*100,'c',CMDPSOFS_resultMin(:,1),CMDPSOFS_resultMin(:,2)*100,'b' )
legend('NSPOSFS-A','NSPOSFS-B','CMDPSOFS-A','CMDPSOFS-B')
title([dataname '(' num2str(allError(2)*100) +'%)'])