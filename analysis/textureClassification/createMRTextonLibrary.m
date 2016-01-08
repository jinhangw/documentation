 
 load train.mat;
 [num_sample,temp] = size(train.files);
 NumClusters = 25;
 %GiantFeatureMatrix = [];
 GiantFeatureMatrix = zeros(100*num_sample, 9);
 
 for i=1:num_sample
    %GiantFeatureMatrix =[GiantFeatureMatrix;extractFilterResponsesRandomSampling(train.files{i},filterBank)]; 
     GiantFeatureMatrix((i-1)*100+1:i*100,:) =extractMRFilterResponsesRandomSampling(train.files{i}, filterBank); 

 end
 
 [res, TextonLibrary] = kmeans(GiantFeatureMatrix, NumClusters,'EmptyAction','drop');