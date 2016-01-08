
numTrainPositive = size(trainAsphaltData,2);
descsPos = [];

for i = 1:numTrainPositive
    i
    img = trainAsphaltData{1,i}.image;
    numSP = size(trainAsphaltData{1,i}.segLabel(1,1).segInd,2);
    for j = 1:numSP
        spimg = (trainAsphaltData{1,i}.segLabel.labeledSegs == trainAsphaltData{1,i}.segLabel(1,1).segInd(j));
        
        desc = textonHistInSP(img,spimg, filterBank, TextonLibrary);
        descsPos = [descsPos;desc];
    end
    
end


numTrainPositive = size(trainBrickData,2);
descsPos2 = [];

for i = 1:numTrainPositive
    i
    img = trainBrickData{1,i}.image;
    numSP = size(trainBrickData{1,i}.segLabel(1,1).segInd,2);
    for j = 1:numSP
        spimg = (trainBrickData{1,i}.segLabel.labeledSegs == trainBrickData{1,i}.segLabel(1,1).segInd(j));
        
        desc = textonHistInSP(img,spimg, filterBank, TextonLibrary);
        descsPos2 = [descsPos2;desc];
    end
    
end



numTrainNegative =20;% size(trainNegativeData,2);
descsNeg = [];

for i = 1:numTrainNegative
    i
    img = trainNegativeData{1,i}.image;
    numSP = size(trainNegativeData{1,i}.segLabel(1,1).segInd,2);
    for j = 1:numSP
        spimg = (trainNegativeData{1,i}.segLabel.labeledSegs == trainNegativeData{1,i}.segLabel(1,1).segInd(j));
        
        desc = textonHistInSP(img,spimg, filterBank, TextonLibrary);
        descsNeg = [descsNeg; desc];
    end
    
end


posAsphaltLabel = ones(size(descsPos,1),1);
posBrickLabel = ones(size(descsPos2,1),1)*2;

negLabel = zeros(size(descsNeg,1),1);

allTrainData = [descsPos;descsPos2;descsNeg];
allLabel = [posAsphaltLabel;posBrickLabel;negLabel];

svmModel = trainSVM(allTrainData,allLabel,2);

save('roadSVMClassifier', 'svmModel');



