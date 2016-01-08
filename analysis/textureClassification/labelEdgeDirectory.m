%labelEdgeDirectory('./data/crack','aaaa')
function trainCrackData = labelEdgeDirectory(imgdir, saveMatName)
addpath('./cannyplus');
close all;

imgfilenames = struct2cell(dir(fullfile(imgdir,'*.JPG')));
imgfilenames = [imgfilenames,struct2cell(dir(fullfile(imgdir,'*.jpg')))];
imgfilenames = [imgfilenames,struct2cell(dir(fullfile(imgdir,'*.jpeg')))];

imgfilenames = imgfilenames(1,:);


%outfile = fullfile(imgdir,[imgfilenames{i}(1:end-4) '_mask.mat']);
trainCrackData = {};
count = 1;

for i = 1:numel(imgfilenames)
    perImageData = {};
    %close all;
    % segmentation file
    im = imread(fullfile(imgdir,imgfilenames{i}));
    smallsize = [600 800];
    im = imresize(im, smallsize);
    
    perImageData.image = im;
    perImageData.name = imgfilenames{i};
    perImageData.linesegs = {};
    perImageData.class = 1;
    
    
    figure(1);
    fprintf('Please click on points that make a polygone that encircle the\n');
    fprintf('training examples. Click again on the first point to close the\n');
    fprintf('polygone\n');
    fprintf('When you finish a polygon, double click on the image to go to\n');
    fprintf('the next image \n\n');
    
    
    mask = roipoly(im);
    
    
    if size(mask,1)~=0
        mask = double(mask);
        
        [edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im, mask);
        
        figure(2);
        imagesc(edgemap_edgeid);
        
        %numEdges = max(max(edgemap_edgeid));
        
        stats = regionprops(edgemap_edgeid,'PixelIdxList');
        
        for j = 1:size(stats,1);
            numPixels = size(stats(j,1).PixelIdxList,1);
            pixelCoords = zeros(2,numPixels);
            for k = 1:numPixels
                ind = stats(j,1).PixelIdxList(k,1);
                [r,c] = ind2sub(smallsize,ind);
                pixelCoords(1,k) = r;
                pixelCoords(2,k) = c;
            end
            perImageData.linesegs{j} = pixelCoords;

        end
        perImageData.PixelIdxList = stats;
        perImageData.mask = mask;

        trainCrackData{count} = perImageData;
        count=count+1;
    end

end

    %assignin('caller', saveMatName, trainData);
    %eval([saveMatName,'=','trainData;']);

    %save('trainCrackData', 'trainCrackData');

    
    %assignin('caller', saveMatName, trainData);
    eval([saveMatName,'=','trainCrackData;']);

    save(saveMatName,saveMatName);
    
end