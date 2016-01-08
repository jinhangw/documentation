%testimg = imread('./data/asphalt/IMG_20120730_161633.jpg');
%testimg = imread('./data/asphalt/IMG_20120730_161237.jpg');
%testimg = imread('./data/asphalt/IMG_20120730_161039.jpg');
%testimg = imread('./data/asphalt/IMG_20120730_160923.jpg');
testimg = imread('./data/test/img0216.jpg');
%testimg = imread('./data/crack2/img0693.jpg');

% testimg = imread('./data/test/20121205_122941.JPG');
% 
 testimg = imread('./data/test/20121205_122723.JPG');
 testimg = imread('./data/test/img0714.jpg');
% 
% testimg = imread('./data/test/img0493.jpg');
%testimg = imread('./data/crack/20121206_135249.JPG');
% 
% testimg = imread('./data/crack2/img0693.jpg');
% 
 testimg = imread('./data/crack/20121206_134941.JPG');
% 
% testimg = imread('./data/IMG_20120730_161758.jpg');


%bad
%testimg = imread('./data/test/20121205_123008.JPG');


labelimage = classifyPatch(testimg, svmModel, filterBank, TextonLibrary, EdgetonLibrary, false);
imagesc(labelimage);


