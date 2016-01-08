% filterBank=loadMRFilterBank();
% createMRTextonLibrary();
% textonMap = textonifyMR(train.files{1}, filterBank, TextonLibrary);
% imagesc(textonMap);

filterBank=createFilterBank();
createTextonLibrary();
save('TextonLibrary', 'TextonLibrary');

im_name = './data/IMG_20120730_155553.jpg';
textonMap = textonify(im_name, filterBank, TextonLibrary);
imagesc(textonMap);
title('textonified image')

imim = imread(im_name);
figure
image(imim)
title('input image')


