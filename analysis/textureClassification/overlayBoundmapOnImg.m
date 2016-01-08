function overlay = overlayBoundmapOnImg(img, boundmask)

overlay = img;
[h,w,c] = size(img);
boundmask = boundmask*255;

temp = overlay(:,:,1);
temp(boundmask>img(:,:,1))=255;
overlay(:,:,1) = temp;

temp = overlay(:,:,2);
temp(boundmask>img(:,:,2))=0;
overlay(:,:,2) = temp;

temp = overlay(:,:,3);
temp(boundmask>img(:,:,3))=0;
overlay(:,:,3) = temp;

