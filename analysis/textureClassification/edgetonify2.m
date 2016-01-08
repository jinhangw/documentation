function [edgetonmap,histo] = edgetonify2(im, edgeim, edgetonLibrary)
    
    [h,w,c] = size(edgeim);
          
    numEdgeton = size(edgetonLibrary, 1);

    [edgemap,edgemap_edgeid,edgemap_ptid, edgenormals, num_edges] = cp_edgelist(edgeim, 6);
    
    stats = regionprops(edgemap_edgeid,'PixelIdxList');
    
    features = lineSegDescriptor(im, stats);
    
    [temp,labeled_pixels] = min(distSqr(features', edgetonLibrary')');
    
    totalNum = size(stats,1);

    
    %textonmap = reshape(labeled_pixels, h, w);
    edgetonmap = zeros(h,w);
    
    for i=1:totalNum
        for j=1:size(stats(i).PixelIdxList,1)
            curPixelInd = stats(i).PixelIdxList(j,1);
            edgetonmap(curPixelInd) = labeled_pixels(i);
        end
    end
    
    if totalNum~=0
        histo = hist(labeled_pixels,1:numEdgeton)/totalNum;
    else
        histo = hist(labeled_pixels,1:numEdgeton);
    end
    
end