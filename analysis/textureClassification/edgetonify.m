function [edgetonmap] = edgetonify(im, EdgetonLibrary)
    
    perImageData = {};
    perImageData.image = im;
    [h,w,c] = size(im);
    
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
    
    features = lineSegDescriptor(im, perImageData.PixelIdxList);
    
    [temp,labeled_pixels] = min(distSqr(features', EdgetonLibrary')');
    
    
    %textonmap = reshape(labeled_pixels, h, w);
    edgetonmap = zeros(h,w);
    
    for i=1:size(stats,1)
        for j=1:size(stats(i).PixelIdxList,1)
            curPixelInd = stats(i).PixelIdxList(j,1);
            edgetonmap(curPixelInd) = labeled_pixels(i);
        end
    end
    
end