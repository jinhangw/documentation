%labelSPDirectory('./data/brick/','trainBrickData',2);
%labelSPDirectory('./data/asphalt/','trainAsphaltData',1)

function trainData = labelSPDirectory(imgdir, saveMatName, class)
close all;

imgfilenames = struct2cell(dir(fullfile(imgdir,'*.jpg')));
imgfilenames2 = struct2cell(dir(fullfile(imgdir,'*.JPG')));
imgfilenames = [imgfilenames,imgfilenames2];

imgfilenames = imgfilenames(1,:);


%outfile = fullfile(imgdir,[imgfilenames{i}(1:end-4) '_mask.mat']);
trainData = {};
perImageData = {};

for i = 1:numel(imgfilenames)
    % segmentation file
    % check if file already exists (image has been segmented)
    im = imread(fullfile(imgdir,imgfilenames{i}));
    perImageData.image = im;
    perImageData.name = imgfilenames{i};
    perImageData.class = class;
    
    %f = figure(88);
    %imagesc(im);
    
%     [x, y, button] = ginput(1);
%     while button~=27
%         [x, y, button] = ginput(1);
%     end
%     close(f);




    
    [labeledSeg, rawSegs] = superPixelLabeling(im);
    perImageData.segLabel = labeledSeg;
    perImageData.rawSegs = rawSegs;
    
    % save segmentation
    if(size(labeledSeg.segInd,1)~=0)
        trainData = cat(2, trainData, cell(1,1));
        trainData{1,size(trainData,2)} = perImageData;
    end
end

    assignin('caller', saveMatName, trainData);
    eval([saveMatName,'=','trainData;']);

    save(saveMatName,saveMatName);

end
