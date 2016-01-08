function [textonmap] = textonify2(im, filterBank, TextonLibrary)
    [h,w,c] = size(im);
    [features] = extractFilterResponses2(im, filterBank);
    num_pixel = size(features,1);
    num_cluster = size(TextonLibrary,1);
    temp_distsqr_array = zeros(num_cluster,1);
    labeled_pixels = zeros(num_pixel,1);

    
    [temp,labeled_pixels] = min(distSqr(features', TextonLibrary.textons')');
    
    
    textonmap = reshape(labeled_pixels, h, w);
end