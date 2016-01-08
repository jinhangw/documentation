% load trainCrackData.mat;
% load trainNegativeCrackData.mat
%  
% numCrackSample = size(trainCrackData,2);
% 
% numNegativeCrackSample = size(trainNegativeCrackData,2);

load edgetonDataForClustering;

%allSamples = [trainCrackData, trainNegativeCrackData];

numAllSampless = size(edgetonDataForClustering,2);

allfeatures = [];

for i=1:numAllSampless
    
    numchars = fprintf('%d%% finished',uint8(i/numAllSampless*100));
    
    curDesc = lineSegDescriptor(edgetonDataForClustering{1,i}.image, edgetonDataForClustering{1,i}.PixelIdxList);
    allfeatures = [allfeatures;curDesc];
    
    fprintf('%s',char(8*ones(1,numchars)));

end

 NumClusters = 25;
 [edgeRes, EdgetonLibrary] = kmeans(allfeatures, NumClusters,'EmptyAction','drop');
 
 save('EdgetonLibrary','EdgetonLibrary');