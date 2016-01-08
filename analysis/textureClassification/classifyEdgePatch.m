function classifyEdgePatch(im, svmModel)
%This function classifiy a patch sampled around an edge
%Input:
%   im: imput image
%   svmModel: svm model trained on patch on edges.
%Output is displayed.

% canny_low = 0.05;
% canny_high = 0.12;
% canny_sigma = 1;
% imhsv = rgb2hsv(im);
% grayim = imhsv(:, :, 3);
%edgemap = double(edge(grayim,'canny',[canny_low,canny_high],canny_sigma));
[h,w,ch] = size(im);

pad = 10;

[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im);

pixels = regionprops(edgemap,'PixelIdxList');

numSeg = size(pixels,2);

numPix = size(pixels.PixelIdxList,1);


% desc = patchDescriptor(patch{1});
% dim=size(desc,2);
step = 10;

descs = zeros(round(numPix/step+step),59);
indexs = zeros(round(numPix/step+step),1);


count=1;
for i=1:step:numPix
    if (mod(count,10) == 1)
        numchars = fprintf('%d%% finished',uint8(i/numPix*100));
    end
    
    index = pixels.PixelIdxList(i);
    [r,c] = ind2sub([h,w],index);
    
    rl=max(r-pad,1);
    rh=min(r+pad,h);
    cl=max(c-pad,1);
    ch=min(c+pad,w);
    
    patch = im(rl:rh,cl:ch,:);
    
    desc = patchDescriptor(patch);
    
    descs(count,:) = desc;
    indexs(count,1) = index;
    
    count=count+1;
    
    if (mod(count,10) == 1)
    fprintf('%s',char(8*ones(1,numchars)));
    end
end

    label = classifySVM(svmModel, descs);
    
    
    for i = 1:size(label,2)
        if(label(1,i)==1)
            [r,c] = ind2sub([h,w],indexs(i));
            
            pad=3;
            rl=max(r-pad,1);
            rh=min(r+pad,h);
            cl=max(c-pad,1);
            ch=min(c+pad,w);
            
            im(rl:rh,cl:ch,1)=255;
            im(rl:rh,cl:ch,2)=0;
            im(rl:rh,cl:ch,3)=0;

        end
    end

imagesc(im);


