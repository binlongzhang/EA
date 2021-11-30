clear
clc


files=dir(fullfile('result','*.mat'));
fileNames={files.name};

for n = 1:numel(fileNames)
    
    dataName = fileNames{n};
    disp(dataName)
    runs = 10;
    fold = 10;
    load(['result/' dataName]);

    featureNum = zeros(runs,fold);
    acc = zeros(runs,fold);

    for i = 1:runs
       res = result{i};
       for j = 1:fold
          featureNum(j,i) = res{j}.featureNum ;
          acc(j,i) = res{j}.acc ;
       end

    end

    resFeatureNum = mean(featureNum);
    resAcc = mean(acc);
    [~,maxIndex] = max(resAcc);
    
    disp([dataName ' mean:  featureSize == ' num2str(mean(resFeatureNum)) ]);
    disp([dataName ' Best:  Accuracy == ' num2str(resAcc(maxIndex))]);
    disp([dataName ' mean:  Accuracy == ' num2str(mean(resAcc))]);
    disp('***********************************************************************')
end
