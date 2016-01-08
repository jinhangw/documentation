
% birds_eye_projection
% 
% Script that uses the gravitational vector to claculate the rotation of an
% image and rotates the image into bird's eye view
%
% Christoph Mertz July 2012

clear
close all

% choose the example you want to look at
example = 2;

if (example == 1)
    aa = [-0.61291564; 8.417375; 4.739881];
    i1 = imread('20120716_131156/IMG_20120716_131200.jpg');
end


if (example == 2)
    aa = [-2.1383946; 7.1915436; 5.965712 ];
    i1 = imread('20120717_102513/IMG_20120717_102517.jpg');
end

% focal length (this is camera dependent, 
% see doc/html/Camera_properties.html):
fc = 2012; 

% In general there are distrotions in the image and the center of the image
% is not necessarily at [height/2 , width/2]. But we found that the
% distrotions are small and we negelct them here.

% get height and width
[height width dummy] = size(i1);

% the size and focal length of the new image:
% a smaller focal length gives you a wider field-of-view
new_fc = fc/6;
% factor to increas/decrease the resoution of the new projected image
% the smaller it is the faster does the script will run
new_res = 0.5;


fprintf(1,'Gravitation is %.2f [m/s^2] and should be 9.81 [m/s^2]\n',sqrt(aa'*aa));

% get the rotation matrix
% no guarantee that this is a standard definition, but it gets the job
% done.
% pitch (rotation around x):
ang1 = atan2(aa(2),aa(3));
R1 = [ 1     0         0       ; ...
       0 cos(ang1)  -sin(ang1) ; ...
       0 sin(ang1)   cos(ang1)   ];

aa1 = R1*aa;

% roll (rotation around y):
ang2 = atan2(aa1(1),aa1(3));
R2 = [ cos(ang2) 0  -sin(ang2) ; ...
          0      1      0      ; ...
       sin(ang2) 0  cos(ang2)   ];


RR = R2*R1;

% notice that RR rotates the gravitational vector to be in z direction:
%  RR*aa =  [ 0 ; 0 ; sqrt(aa'*aa) ]


% show the original iamges
figure(1)
image(i1)

% This is how you get from the original image to the new image. Shown for
% one pixel, the center pixel:
xp = [height/2; width/2];
% Convert from image (pixel) coordinate to camera coordinates. Notice that
% we write it in homogeneous coordinates, i.e. z = 1
xcam = [(xp(1) - height/2)/fc ; (xp(2) - width/2)/fc; 1];
% Rotate:
xc1 = RR*xcam;
% make it homogeneous again:
xc1 = xc1/xc1(3);
% apply focal length
xp1 = xc1*new_fc;
% shift:
xp2 = round([xp1(1) + height*new_res/2 ; xp1(2) + width*new_res/2 ]);
% xp2 are now the image (pixel) coordinate of the new image

% we will need this offset later on. It shifts the new image so that the
% old center point is the new center point plus another offset
off = xc1(2)*new_fc - 200*new_res;


% make an empty image:
i2 = zeros([ height*new_res  width*new_res 3]);


% scan through the new image and look for the corresponding intensity in
% the old image
for ih = 1:height*new_res
    for iw = 1:width*new_res
       
        xp = [ih ; iw + off ];
        xcam = [(xp(1) - height/4)/fc*8 ; (xp(2) - width/4)/fc*8; 1];
        xc1 = RR'*xcam;
        xc1 = xc1/xc1(3);
        xp1 = xc1*fc;
        xp2 = round([xp1(1) + height/2 ; xp1(2) + width/2 ]);
        
        if (xp2(1) >= 1 &&  xp2(1) <= height && xp2(2) >= 1 &&  xp2(2) <= width)
            i2(ih,iw, :) = i1(xp2(1), xp2(2), :);
        end
        
        
        
    end
end


% Plot the new image:
figure(2)
image(i2/255)
