function descriptor = textonHistInSP(img, spimg, filterBank, TextonLibrary)
% Input:
%   image: original image
%   spimg:  super-pixel image
%   filterBank: filter bank used to generate texton library.
%   TextonLibrary: the texton library.

%load('labeledAsphaltData.mat');

numTexton = size(TextonLibrary,1);

%img = trainData{1,1}.image;
%spimg = trainData{1,1}.segLabel.labeledSegs == trainData{1,1}.segLabel(1,1).segInd(1);
%imagesc(segs);

%figure
textonMap = textonify2(img, filterBank, TextonLibrary);
%imagesc(textonMap);

maskedTM = textonMap.*spimg;
%imagesc(maskedTM);

%hist(maskedTM)

TMInds = maskedTM(find(maskedTM>0));

%aaa=hist(maskedTM(find(maskedTM>0)),1:25);

textonVector = zeros(1, numTexton);
textonVectorPx = zeros(1, numTexton);

numTextonArea = 0;
numPixel = 0;

for i = 1:numTexton
    connectedComp = bwconncomp(maskedTM==i);
    textonVector(1,i) = connectedComp.NumObjects;
    
    numPxCurrentTextonKind = 0;
    for j = 1:connectedComp.NumObjects
        numPxCurrentTextonKind = numPxCurrentTextonKind + size(connectedComp.PixelIdxList{j},1);
    end
    
    textonVectorPx(1,i) = numPxCurrentTextonKind;
    
    numTextonArea = numTextonArea + connectedComp.NumObjects;
    numPixel = numPixel + numPxCurrentTextonKind;
end

textonVector=textonVector./numTextonArea;
textonVectorPx = textonVectorPx./numPixel;

descriptor = [textonVector, textonVectorPx];