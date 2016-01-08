function [textonmap] = textonify(im, filterBank, TextonLibrary)
    image = imread(im);
    [h,w,c] = size(image);
    [features] = extractMRFilterResponses(im, filterBank);
    num_pixel = size(features,1);
    num_cluster = size(TextonLibrary,1);
    temp_distsqr_array = zeros(num_cluster,1);
    labeled_pixels = zeros(num_pixel,1);
%     for i = 1:num_pixel
%         for j= 1:num_cluster
%             temp_distsqr_array(j)=distSqr(features(i,1)',TextonLibrary(j,1)');
%         end
%         [temp,min_cluster_label] = min(temp_distsqr_array);
%         labeled_pixels(i) = min_cluster_label;
%     end
    [temp,labeled_pixels] = min(distSqr(features', TextonLibrary')');
    
    
    textonmap = reshape(labeled_pixels, h, w);
end