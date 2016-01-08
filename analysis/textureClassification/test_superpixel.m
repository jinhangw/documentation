img = imread('./data/IMG_20120730_155553.jpg');
imagesc(img);

segs = im2superpixels(img);
segimage = segs.segimage;

figure;
imagesc(segimage);
