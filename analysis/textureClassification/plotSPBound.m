function boundimg = plotSPBound(boundMap, imgsize)
%overlay superpixel boundrary on original image for
%better visualization.
[w,h] = size(boundMap);
boundimg = zeros(imgsize);

for i =1:w
    for j=1:h
        curbound = boundMap{i,j};
        if(size(curbound,1)~=0)
            boundimg(curbound)=1;
        end
    end
end
