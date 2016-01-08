function imsegs = im2superpixelsParas(im, sigma, k, min)
%call the external command to get superpixels.
%with parameters in the interface

prefix = num2str(floor(rand(1)*10000000));
fn1 = ['./tmpim' prefix '.ppm'];
fn2 = ['./tmpimsp' prefix '.ppm'];
segcmd = ['LD_LIBRARY_PATH=/usr/lib64 ../groundLabeling/segment/segment ', ...
           num2str(sigma),' ', num2str(k),' ',num2str(min)];%0.5 600 200

imwrite(im, fn1);
system([segcmd ' ' fn1 ' ' fn2]);
imsegs = processSuperpixelImage(fn2);

delete(fn1);
delete(fn2);