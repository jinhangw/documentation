numNegative = size(trainNegative.files,1);
trainNegativeData = cell(1,numNegative);


for i=1: numNegative
    perImageData = {};
    
    im = imread(trainNegative.files{i,1});
    perImageData.image = im;
    perImageData.name = trainNegative.files{i,1};
    perImageData.class = 0;
    
    segs = im2superpixels(im);

    result = {};
    segInd = [];
    result.labeledSegs = segs.segimage;
    
    perImageData.rawSegs = segs;

    
    for j = 1: segs.nseg
        if segs.npixels(j)>2000
            segInd = [segInd, j];
        end
    end
    result.segInd = segInd;
    perImageData.segLabel = result;
    trainNegativeData{1,i} = perImageData;
end

save('trainNegativeData','trainNegativeData');
