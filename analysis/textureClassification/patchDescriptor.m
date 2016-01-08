function features = patchDescriptor(im)


% features(nseg, nf)
%   Feature Descriptions:
%      01 - 03: mean rgb
%      04 - 06: hsv conversion
%      07 - 11: hue histogram
%      12 - 14: sat histogram
%      15 - 29: mean texture response
%      30 - 44: texture response histogram
%      45 - 46: mean x-y
%      47 - 48: 10th, 90th perc. x
%      49 - 50: 10th, 90th perc. y
%      51 - 51: h / w
%      52 - 52: area
% color
imhsv = rgb2hsv(im);
grayim = imhsv(:, :, 3);
[imh imw] = size(grayim);

% parameters
canny_low = 0.05;
canny_high = 0.12;
canny_sigma = 1;

% canny edge detector
edgemap = double(edge(grayim,'canny',[canny_low,canny_high],canny_sigma));




%[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im);
%figure(2);
%imagesc(edgemap_edgeid);
pixels = regionprops(edgemap,'PixelIdxList');


ncolor = 6; % mean rgb, hsv
ncolhist = 8;
ntexthist = 15;
nloc = 8; % mean x-y, 10th, 90th percentile x-y, w/h, area
filtext = makeLMfilters;
ntext = size(filtext, 3);
nseg = size(pixels, 1);
if ntext~=15
    disp('warning: expecting 15 texture filters')
end

features = zeros(1, ncolor+ntext+ncolhist+ntexthist+ntexthist);




npix = imh*imw;

hhist = 1 + (imhsv(:, :, 1) > 0.2) + (imhsv(:, :, 1) > 0.4) + ...
    (imhsv(:, :, 1) > 0.6) + (imhsv(:, :, 1) > 0.8);
shist = 1 + (imhsv(:, :, 2) > 0.33) + (imhsv(:, :, 2) > 0.67);

% texture
imtext = zeros([imh imw ntext]);
for f = 1:ntext
    imtext(:, :, f) = abs(imfilter(im2single(grayim), filtext(:, :, f), 'same'));
end
[tmp, texthist] = max(imtext, [], 3);

allPixelsOnEdge=[];
for s = 1:nseg
    allPixelsOnEdge = [allPixelsOnEdge;pixels(s).PixelIdxList];
end


if(size(allPixelsOnEdge,1)>0)
    %spstats = regionprops(imsegs.segimage, 'PixelIdxList');
    s=1;
    % rgb means
    f = 0;
    for k = 1:3
        features(s, f+k) = mean(im(allPixelsOnEdge+(k-1)*imw*imh));
    end
    f = f + 3;
    % hsv means
    features(s, f+[1:3]) = rgb2hsv(features(s, [1:3]));
    f = f + 3;
    % hue histogram
    features(s, f+[1:5]) = hist(hhist(allPixelsOnEdge), [1:5])+1;
    features(s, f+[1:5]) = features(s, f+[1:5]) / sum(features(s, f+[1:5]));
    f = f + 5;
    % sat histogram
    features(s, f+[1:3]) = hist(shist(allPixelsOnEdge), [1:3])+1;
    features(s, f+[1:3]) = features(s, f+[1:3]) / sum(features(s, f+[1:3]));
    f = f + 3;
    % texture means
    for k = 1:ntext
        features(s, f+k) = mean(imtext(allPixelsOnEdge+(k-1)*npix));
    end
    f = f + ntext;
    % texture histogram
    features(s, f+(1:ntext)) = hist(texthist(allPixelsOnEdge), (1:ntext))+1;
    features(s, f+(1:ntext)) = features(s, f+(1:ntext)) / sum(features(s, f+(1:ntext)));
    f = f + ntext;
    features(s, f+(1:ntext)) = hist(texthist(1:npix), (1:ntext))+1;
    features(s, f+(1:ntext)) = features(s, f+(1:ntext)) / sum(features(s, f+(1:ntext)));
    
    
end












