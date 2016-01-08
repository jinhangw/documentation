%testimg = imread('./data/crack/img0693.jpg');
%testimg = imread('./data/asphalt/IMG_20120730_161633.jpg');

imgdir = './data/asphalt/';
imgfilenames = struct2cell(dir(fullfile(imgdir,'*.jpg')));
imgfilenames = imgfilenames(1,:);



for i = 1:numel(imgfilenames)

testimg = imread(fullfile(imgdir,imgfilenames{i}));
    
imagesc(testimg);
figure;
imsegs = im2superpixelsParas(testimg, 0.5, 100, 100);
imagesc(imsegs.segimage);

pause;
close all;

end