

clear

%Point this to the folder containing the input images
imdir  = ['../data/Images/up_street/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read images

image_list = dir([imdir,'*.jpg']);
[ni1,ni2] = size(image_list);

%Save the output images in a folder called "rotated" inside the input
%image folder

outDir = [imdir 'rotated/'];

%Create directory for the output images
mkdir(outDir);

%for i = 1:size(image_list,1)
for i = 1:size(image_list)
    i1 = imread([imdir image_list(i).name]);

    % get height and width
    [height width dummy] = size(i1);
    

    %The values in this Homography matrix are handtuned for a particular 
    %set of images and cannot be guaranteed to work for any general set. 
    %Work on a more general rotation and ground-plane projection algorithm 
    %is underway.
    
    H = [-0.0931481481481481,         -2.13333333333333,          1241.42222222222;...
                           0,                      -2.2,          1375.41407407407;...
                           0,      -0.00185185185185185,                         1;];

    fprintf('Warping image %d of %d\n',i,size(image_list,1));
    i2 = warpH(i1,H,size(i1),0);
    
    figure(1);
    subplot(121);
    image(i1);
    subplot(122);
    image(i2);
    
    imwrite(i2,[outDir image_list(i).name]);
end

