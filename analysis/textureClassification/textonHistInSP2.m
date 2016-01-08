function descriptor = textonHistInSP2(textonMap, spimg, filterBank, TextonLibrary)
%This function calculate histogram of textons in a image
%This is slightly different version of textonHistInSP
%The only difference is the first parameter.
%Instead of taking orginal image and generate a texton map in the function,
%it takes a texton map directly.
% Input:
%   textonMap: 
%   spimg:  super-pixel image
%   filterBank: filter bank used to generate texton library.
%   TextonLibrary: the texton library.

%load('labeledAsphaltData.mat');

numTexton = size(TextonLibrary,1);
%textonMap = textonify2(img, filterBank, TextonLibrary);

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