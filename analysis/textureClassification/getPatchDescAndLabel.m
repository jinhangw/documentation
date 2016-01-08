function [descs, labels] = getPatchDescAndLabel(patches,label)
%This function prepare patches' data for training.
%Input:
%   patches: W*W*N matrix. W: width of patch. N: number of patches.
%   label: an 1x1 value represent the label
%Output:
%   descs: NxM matrix. N:number of patch. M:dimenstion of descriptor.
%   labels: Nx1 matrix. all the element has same value of input "label"

sample = patchDescriptor(patches{1});
dim = size(sample,2);

numPatches = size(patches,1);

descs = zeros(numPatches, dim);

for i=1:numPatches
    %i
    desc = patchDescriptor(patches{i});
    
    if(sum(desc)~=0)
        descs(i,:) = desc;
    else
        descs(i,:) = descs(i-1,:);
    end
end

labels = ones(numPatches,1)*label;

end