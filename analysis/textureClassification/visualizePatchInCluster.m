function visualizePatchInCluster(patches)
%This function randomly pick 100 patches out
%of the input patches and show them.

num = size(patches,1);

samples = randperm(num);
patches = patches(samples);

[h,w,c] = size(patches{1});

numWid = 10;

image = zeros(h*numWid,w*numWid,3);

for i = 1:min(numWid*numWid, num)
    if(mod(i,numWid)==0)
        curRow = floor(i/numWid);
        curCol = numWid;
    else
        curRow = floor(i/numWid)+1;
        curCol = uint16(mod(i,numWid));
    end
    
    image((curRow-1)*h+1:curRow*h, (curCol-1)*h+1:curCol*h,:) = patches{i};
    
end

imagesc(uint8(image));


