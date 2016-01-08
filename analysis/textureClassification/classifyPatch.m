function [segimage,edgetonmap,textonMap,labeledView] ...
        = classifyPatch(img, svmModel, filterBank, TextonLibrary,...
                        edgetonLibrary, ifShowDebugImgs, ifUseLineseg)
%This function labels the possible road segments in an image.
%Input:
%   img: image to be classify
%   svmModel:  the svm model
%   filterBank: filterbank that is use to generate TextonLibrary
%   TextonLibrary:  Texton Library
%   edgetonLibrary: edgeton Library
%   ifShowDebugImgs: if show intermediate results for debug
%   ifUseLineseg:   if use line segment descriptor as part of whe whole
%                   descriptor
%Output:
%   segimage: result of superpixel segmentation
%   edgetonmap: edgeton map using the edgetonLibrary
%   textonMap: texton map using the TextonLibrary
%   labeledView: final labeled result image

if(ifShowDebugImgs)
figure;
imagesc(img);
end

segs = im2superpixels(img);
descs = [];
segimage = segs.segimage;

if(ifShowDebugImgs)
figure;
imagesc(segimage);
end

textonMap = textonify2(img, filterBank, TextonLibrary);

if(ifShowDebugImgs)
figure;
imagesc(textonMap);
end


spdata = mcmcGetSuperpixelData(img, segs);
[edata, adjlist] = mcmcGetEdgeData(segs, spdata);


imdata = mcmcComputeImageData(img, segs);

[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(img);


[edgetonmap,desc] = edgetonify2(img, edgemap_edgeid, edgetonLibrary);

if(ifShowDebugImgs)
figure;
imagesc(edgetonmap);
end

for i =1:segs.nseg
    
    %fprintf ('blablabla %d \r', i);
    numchars = fprintf('%d%% finished',uint8(i/segs.nseg*100));
    
    spimg = (segs.segimage == i);
    desc = textonHistInSP2(textonMap, spimg, filterBank, TextonLibrary);
    
    if(ifUseLineseg == true)
        desc2 = edgetonHistFromSP(img, edgemap_edgeid, spimg, edgetonLibrary);
        desc = [desc, spdata(i,:), desc2];
    else
        desc = [desc, spdata(i,:)];
    end
    
    descs = [descs;desc];
    
    fprintf('%s',char(8*ones(1,numchars)));
end

testLabels = classifySVM(svmModel, descs);

%posSegInd = find(testLabels==label);
%numPos = size(posSegInd, 2);

[h,w,c] = size(img);
labeledView=zeros(h,w);

%for i = 1:numPos
%    labeledView = labeledView +(segs.segimage==posSegInd(i));
%end

for i =1:segs.nseg
    labeledView = labeledView + (segs.segimage==i)*testLabels(i);
end


% if(ifShowDebugImgs)
% figure;
% imagesc(labeledView);
% end
