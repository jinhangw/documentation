 
 load train.mat;
 [num_sample,temp] = size(train.files);
 NumClusters = 25;
 %GiantFeatureMatrix = [];
 numRandSamplePerImage = 100;
 GiantFeatureMatrix = zeros(numRandSamplePerImage*num_sample, 17);
 samplePatchArrayForVisualization = cell(numRandSamplePerImage*num_sample,1);
 
 for i=1:num_sample
    %GiantFeatureMatrix =[GiantFeatureMatrix;extractFilterResponsesRandomSampling(train.files{i},filterBank)]; 
    [GiantFeatureMatrix((i-1)*100+1:i*100,:), samplePatchArrayForVisualization((i-1)*100+1:i*100)] = ...
        extractFilterResponsesRandomSampling(train.files{i}, filterBank,numRandSamplePerImage); 

 end
 
 [res, textons,dummy, distance] = kmeans(GiantFeatureMatrix, NumClusters,'EmptyAction','drop');
 
 TextonLibrary.textons = textons;
 TextonLibrary.sd = zeros(NumClusters,1);
 
 for i = 1:NumClusters
    TextonLibrary.sd(i,1) = std(distance((res==i),i));
 end
 
 
 
 centroidSamplePatch = cell(NumClusters,1);
 for i = 1:NumClusters
    centroidSamplePatch{i,1} = samplePatchArrayForVisualization(res==i);
 end
 
 %visualizePatchInCluster(centroidSamplePatch{1});