function imsegs = im2superpixels(im)
%call the external command to get superpixels.

prefix = num2str(floor(rand(1)*10000000));
fn1 = ['./tmpim' prefix '.ppm'];
fn2 = ['./tmpimsp' prefix '.ppm'];
segcmd = 'LD_LIBRARY_PATH=/usr/lib64 ../groundLabeling/segment/segment 0.5 200 800';%0.5 600 200

imwrite(im, fn1);
system([segcmd ' ' fn1 ' ' fn2]);
imsegs = processSuperpixelImage(fn2);

delete(fn1);
delete(fn2);