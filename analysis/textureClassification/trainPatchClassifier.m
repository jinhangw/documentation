
%load labeled data
load cracks.mat;
load cracksNeg.mat;
addpath('./cannyplus');
%process them into edge image patches
fprintf('process labeled areas into edge image patches ...\n');
crackPatches = processMasksIntoPatches(cracks);
crackNegPatches = processMasksIntoPatches(cracksNeg);

%combine them for training.
fprintf('combine them for training ...\n');
[crackDescs,crackLabel] = getPatchDescAndLabel(crackPatches,1);
[crackNegDescs,crackNegLabel] = getPatchDescAndLabel(crackNegPatches,0);


allDescs = [crackDescs; crackNegDescs];
allLabel = [crackLabel; crackNegLabel];

%train
fprintf('train SVM ...\n');
patchSvmModel = trainSVM(allDescs, allLabel, 2);

%save the classifier
save('patchClassifierCrackAndNeg', 'patchSvmModel');
