
% select the positive examples
trainCrackData = labelEdgeDirectory('./data/crack_short','cracks');

patches = processMasksIntoPatches(trainCrackData);
visualizePatchInCluster(patches); 
 

%  select the negative examples
trainCrackNegData = labelEdgeDirectory('./data/crack_short','cracksNeg');
 
patchesNeg = processMasksIntoPatches(trainCrackNegData);
visualizePatchInCluster(patchesNeg); 
 
% given the examples, train the classifier
trainPatchClassifier

% test example
im_test = imread('./data/test/img0668.jpg');
figure
image(im_test)

classifyEdgePatch(im_test, patchSvmModel)


