imgOri = imread('./data/crack/20121206_135455.JPG');
addpath('./cannyplus');

im = imresize(imgOri, [600 800]);


%im=RGB2Lab(im);
% im=rgb2gray(im);
% 
% imeq = histeq(im(:,:,1));
% imshow(im)
% figure, imshow(imeq)


% if size(im,3) == 3,
%     im = RGB2Lab(im);
%     im=im(:,:,1);
% end
% 
% % Check if image is double or not
% if ~isa(im, 'double'),
%     im = im2double(im);
% end


    % edgemap = double(edge(double(rgb2gray(im)),'canny',[0.1,0.2],1));
    % figure(1);
    % imagesc(edgemap); colormap gray; axis image; title('Original Canny Edgemap');


imagesc(im);

% canny edge detector
%edgemap = double(edge(im,'canny',[canny_low,canny_high],canny_sigma));
%edgemap = double(edge(im,'prewitt',0.05));

[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(im);

%edgemap = sobel(im, 40.0);



figure;
imagesc(edgemap);