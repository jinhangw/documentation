imgdir ='./data/edgetonData';
addpath('./cannyplus');

imgfilenames1 = struct2cell(dir(fullfile(imgdir,'*.JPG')));
imgfilenames2 = struct2cell(dir(fullfile(imgdir,'*.jpg')));
imgfilenames3 = struct2cell(dir(fullfile(imgdir,'*.png')));

imgfilenames = [imgfilenames1(1,:), imgfilenames2(1,:), imgfilenames3(1,:)];


   

num = size(imgfilenames,2);
edgetonDataForClustering = cell(1,num);


for i=1: num
    
    numchars = fprintf('%d%% finished',uint8(i/num*100));
    
    perImageData = {};
   
    
    im = imread(fullfile(imgdir,imgfilenames{i}));

    
    %im = imread(trainNegative.files{i,1});
    %size = size(im);
    perImageData.image = im;
    perImageData.name = imgfilenames{i};
    perImageData.class = 0;
    
    [edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im);
        
              
    stats = regionprops(edgemap_edgeid,'PixelIdxList');
    
    for j = 1:size(stats,1);
        numPixels = size(stats(j,1).PixelIdxList,1);
        pixelCoords = zeros(2,numPixels);
        for k = 1:numPixels
            ind = stats(j,1).PixelIdxList(k,1);
            [r,c] = ind2sub(size(im),ind);
            pixelCoords(1,k) = r;
            pixelCoords(2,k) = c;
        end
        perImageData.linesegs{j} = pixelCoords;
        
    end
    perImageData.PixelIdxList = stats;
    
    edgetonDataForClustering{i} = perImageData;
    
    fprintf('%s',char(8*ones(1,numchars)));

end

save('edgetonDataForClustering','edgetonDataForClustering');
