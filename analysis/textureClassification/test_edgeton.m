addpath('./cannyplus');
load ./models/EdgetonLibrary.mat;
img = imread('./data/IMG_20120730_155553.jpg');

[edgemap, edgemap_edgeid, edgemap_ptid, edgenormals] = cannyplus(img);


[edgetonmap,desc] = edgetonify2(img, edgemap_edgeid, EdgetonLibrary);

imagesc(img);
figure;
imagesc(edgetonmap);
