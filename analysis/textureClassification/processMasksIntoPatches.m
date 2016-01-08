function patches = processMasksIntoPatches(cracks)

numOfPic = size(cracks,2);
pad=10;
sideLen= (pad*2+1);
totalPix = sideLen*sideLen*3;
brightness = 100;

patches = {};

for i = 1:numOfPic
    segs = cracks{i}.linesegs;
    
    for j = 1:size(segs,2)
        for k =1:4:size(segs(j),2)
            x= segs{j}(1,k);
            y= segs{j}(2,k);
            patch = cracks{i}.image(x-pad:x+pad,y-pad:y+pad,:);
%             patchLab=RGB2Lab(patch);
%             patchLab(:,:,1) = histeq(uint8(patchLab(:,:,1)));
%             patch=Lab2RGB(patchLab);
            curbrightness = sum(sum(sum(patch)))/totalPix;
            scale = brightness/curbrightness;
            patch = patch.*scale;
            patches = [patches;patch];
        end
    end
end