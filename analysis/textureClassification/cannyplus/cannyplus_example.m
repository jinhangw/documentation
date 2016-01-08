img = imread('../data/asphalt/IMG_20120730_155929.jpg');

img = imread('../data/brick/img0118.jpg');


% run canny edge detector
edgemap = double(edge(double(rgb2gray(img)),'canny',[0.1,0.2],1));
figure(1);
imagesc(edgemap); colormap gray; axis image; title('Original Canny Edgemap');


% run canny plus edge detector
fprintf('Running cannyplus detector...'); tic;
[edgemap, edgemap_edgeid, edgemap_ptid] = cannyplus(img);
fprintf('%0.2fs\n',toc);

% plot results
figure(2);
imagesc(edgemap); colormap gray; axis image; title('Edgemap');

figure(3); 
subplot(2,2,1); 
imagesc(img); axis image; title('Original image');
subplot(2,2,2); 
imagesc(edgemap); colormap gray; axis image; title('Edgemap');
subplot(2,2,3); 
imagesc(edgemap_edgeid); colormap jet; axis image; title('Edge ids');
subplot(2,2,4); 
imagesc(edgemap_ptid); colormap jet; axis image; title('Point ids');