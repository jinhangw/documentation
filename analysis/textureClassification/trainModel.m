%This script train the svm model using texton histograms and optinally
%edgeton descriptors.
addpath('./cannyplus');
%load Libraries
filterBank=createFilterBank();
load ./models/TextonLibrary.mat;
load ./models/EdgetonLibrary.mat;

%load traning data
load ./trainAsphaltData.mat;
load ./trainBrickData.mat;
load ./trainCrackData.mat;
load ./trainNegativeData.mat;


ifUseLineSegment = false;

numTrainAsphalt = size(trainAsphaltData,2);

numTrainBrick = size(trainBrickData,2);

numCrackBrick = size(trainCrackData,2);


numTrainNegative = size(trainNegativeData,2);

allTrainData = [];

allLabel = [];

trainCombo = {trainAsphaltData{1,1:numTrainAsphalt},...
              trainBrickData{1,1:numTrainBrick},...
              trainCrackData{1,1:numCrackBrick},...
              trainNegativeData{1,1:numTrainNegative}};

for i = 1:size(trainCombo, 2)
    %i
    img = trainCombo{1,i}.image;
    
    textonMap = textonify2(img, filterBank, TextonLibrary);

    
    spdata = mcmcGetSuperpixelData(img, trainCombo{1,i}.rawSegs);
    [edata, adjlist] = mcmcGetEdgeData(trainCombo{1,i}.rawSegs, spdata);
    
    
    imdata = mcmcComputeImageData(img, trainCombo{1,i}.rawSegs);

    
    numSP = size(trainCombo{1,i}.segLabel(1,1).segInd,2);
    
    [edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(img);

    
    for j = 1:numSP
        spimg = (trainCombo{1,i}.segLabel.labeledSegs == trainCombo{1,i}.segLabel(1,1).segInd(j));
        
        desc = textonHistInSP2(textonMap, spimg, filterBank, TextonLibrary);
     
        
        if ifUseLineSegment==true
        %test
            desc2 = edgetonHistFromSP(img, edgemap_edgeid, spimg, EdgetonLibrary); 
            desc = [desc, spdata(trainCombo{1,i}.segLabel(1,1).segInd(j),:), desc2];
        else
            desc = [desc, spdata(trainCombo{1,i}.segLabel(1,1).segInd(j),:)];
        end
        
        allTrainData = [allTrainData; desc];
        allLabel = [allLabel; trainCombo{1,i}.class ];
    end
    
end


svmModel = trainSVM(allTrainData, allLabel, 2);

if ifUseLineSegment==true
    save('roadSVMClassifierWithLineSegsForFourClasses','svmModel');
else
    save('roadSVMClassifierWithoutLineSegsForFourClasses','svmModel');
end



