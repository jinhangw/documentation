
% script to make the arrows used as icons

close all
clear

[A,MAP,ALPHA] = imread('direction_left.png');

figure(1)
image(A)

B = A(16:37,5:26,1:3);
ALPHA_B = ALPHA(16:37,5:26);

figure(2)
image(B)
axis equal

[n1,n2,n3] = size(B);

nA = 1;
nB = 2*nA;
C = uint8(zeros([n1+nB,n2+nB,n3]));
ALPHA_C = uint8(zeros([n1+nB,n2+nB]));

C(1+nA:n1+nA,1+nA:n2+nA,1:3) = B;
ALPHA_C(1+nA:n1+nA,1+nA:n2+nA) = ALPHA_B;

%  this is if you want to resize it, not really needed because 
% you can resize them in the kml file
%
% D = imresize(C,2/3);
% ALPHA_D = imresize(ALPHA_C,2/3);
% figure(3)
% image(D)
% axis equal

% no resizing:
D = C;
ALPHA_D = ALPHA_C;


E0 = imrotate(D,270,'bilinear','crop');
ALPHA_E = imrotate(ALPHA_D,270,'bilinear','crop');


% change color:
im_col = E0(:,:,1);
im_grey = E0(:,:,3);

for cc = 1:8
    
    
    E = E0;
    if cc == 1
        c_name = 'yellow';
    elseif cc == 2
        E(:,:,1) = im_grey;
        c_name = 'green';
    elseif cc == 3
        E(:,:,2) = im_grey;
        c_name = 'red';
    elseif cc == 4
        E(:,:,1) = im_grey;
        E(:,:,2) = im_grey;
        E(:,:,3) = im_col;
        c_name = 'blue';
    elseif cc == 5
        E(:,:,1) = im_grey;
        E(:,:,2) = im_col;
        E(:,:,3) = im_col;
        c_name = 'cyan';
    elseif cc == 6
        E(:,:,1) = im_col;
        E(:,:,2) = im_grey;
        E(:,:,3) = im_col;
        c_name = 'magenta';
    elseif cc == 7
        E(:,:,1) = im_col;
        E(:,:,2) = im_col;
        E(:,:,3) = im_col;
        c_name = 'white';
    elseif cc == 8
        E(:,:,1) = im_grey;
        E(:,:,2) = im_grey;
        E(:,:,3) = im_grey;
        c_name = 'black';
    end
    
    figure
    image(E)
    axis equal;
    
    aa = 0;
    name = ['arrows/arrow_',num2str(aa),'_',c_name,'.png'];
    imwrite(E,name,'Alpha',ALPHA_E)
    
    for aa = 10:10:360
        F = imrotate(E,-aa,'bilinear','crop');
        ALPHA_F = imrotate(ALPHA_E,-aa,'bilinear','crop');
        name = ['arrows/arrow_',num2str(aa),'_',c_name,'.png'];
        imwrite(F,name,'Alpha',ALPHA_F)
    end
    
    
end

