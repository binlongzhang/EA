function [swarm] = init(featureNum,popSize,Vmin,Vmax)
%INIT 此处显示有关此函数的摘要
%   此处显示详细说明
    swarm.maxLength = featureNum;
    swarm.threshold = 0.6;
    swarm.divisionNum = 12;
    swarm.maxRenewExemplar = 7;
    swarm.maxLengthChange = 9;
    swarm.lambda = 0.8;
    swarm.pc = zeros(1,popSize);
    swarm.exemReNewCount = zeros(1,popSize);
    swarm.partPopSize = ceil(popSize/swarm.divisionNum);
    swarm.popSize =  swarm.divisionNum * swarm.partPopSize;
    swarm.fitness = zeros(swarm.popSize,1);
    swarm.meanFitness = zeros(swarm.divisionNum,1);
    swarm.particle{swarm.popSize} = {};
    swarm.division{swarm.divisionNum} = {};
    swarm.particleLen = ones(swarm.popSize,1);
    swarm.renewExemplar = false(1,swarm.popSize);
    swarm.gBest.pos = []; 
    swarm.gBest.fitness = 0; 
    swarm.gBest.notChange = 0;
    for i = 1:swarm.divisionNum
        swarm.division{i}.start = (i-1)*swarm.partPopSize+1;
        swarm.division{i}.end = i*swarm.partPopSize;
        swarm.division{i}.len = floor((i/swarm.divisionNum)*swarm.maxLength);
        swarm.particleLen(swarm.division{i}.start:swarm.division{i}.end) = swarm.division{i}.len;
        for j = swarm.division{i}.start : swarm.division{i}.end
            swarm.particle{j}.position = rand(1,swarm.division{i}.len);     
            swarm.particle{j}.velocity = Vmin + rand(1,swarm.division{i}.len)*(Vmax-Vmin);
            swarm.particle{j}.exemplar = zeros(1,swarm.division{i}.len);
            swarm.particle{j}.pBest.pos = swarm.particle{j}.position; 
            swarm.particle{j}.pBest.fitness = 0;     
            swarm.particle{j}.fitness = 0;
            swarm.particle{j}.pBestNotImprove = 0;
        end
    end
end

