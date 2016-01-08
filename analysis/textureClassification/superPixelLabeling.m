function [result, segs ] = superPixelLabeling(im)
%This function makes you to label target superpixels in an image
%and return thier data structures.
result = {};
f=figure;
segs = im2superpixels(im);


[h,w,c] = size(segs.segimage);

[boundmap, perim] = mcmcGetSuperpixelBoundaries_fast(segs);
boundimg = plotSPBound(boundmap, [h w]);
overlayimg = overlayBoundmapOnImg(im, boundimg);

imshow(overlayimg);

[x, y, button] = ginput(1);

finalMask = uint16(zeros(h,w));
segInd = [];





while button ~= 27
[x, y, button] = ginput(1);
%disp(['You clicked X:',num2str(x),', Y:',num2str(y)]);

if x>0 && x<w && y>0 && y<h
    clickedValue = segs.segimage(int16(y), int16(x));
    %disp(['You clicked value: ',num2str(clickedValue)]);
    if size(find(segInd==clickedValue),2)==0
        finalMask = finalMask + uint16(segs.segimage==clickedValue).*segs.segimage;
        segInd = [segInd, clickedValue];
        disp('segment added');
    else
        disp('segment already labeled');
    end
else
    disp('out bound');
end
%set(f,'WindowButtonDownFcn',{@labelCallback, segs});
end

%imagesc(finalMask);
result.labeledSegs = finalMask;
result.segInd = segInd;
close(f);





% function labelCallback(hObject,eventdata,segs)
% pos=get(hObject,'CurrentPoint');
% disp(['You clicked X:',num2str(pos(1)),', Y:',num2str(pos(2))]);
% disp(['You clicked value: ',num2str(segs.segimage(pos(2),pos(1)))])