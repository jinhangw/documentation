function segment_directory(imgdir)
% segment_directory(imgdir)
close all;

imgfilenames = struct2cell(dir(fullfile(imgdir,'*-L.bmp')));
imgfilenames = imgfilenames(1,:);

for i = 1:numel(imgfilenames)
    % segmentation file
    outfile = fullfile(imgdir,[imgfilenames{i}(1:end-4) '_mask.mat']);
    %outfile = fullfile(imgdir,[imgfilenames{i}(1:end-4) '.mat']);
    % check if file already exists (image has been segmented)
    if exist(outfile,'file')
        continue;
    end
    fprintf(['Segmenting ' fullfile(imgdir,imgfilenames{i}) '\n']);
    % load image for segmentation
    im = imread(fullfile(imgdir,imgfilenames{i}));
    % segment the image
    figure(1); 
    mask = roipoly(im);
    % display segmentation
    figure(2);
    im_mask_r = im(:,:,1); im_mask_r(~mask) = 0; im_mask(:,:,1) = im_mask_r;
    im_mask_g = im(:,:,2); im_mask_g(~mask) = 0; im_mask(:,:,2) = im_mask_g;
    im_mask_b = im(:,:,3); im_mask_b(~mask) = 0; im_mask(:,:,3) = im_mask_b;
    imagesc(im_mask); axis image; axis off;
    % save segmentation
    save(outfile,'mask');
end
