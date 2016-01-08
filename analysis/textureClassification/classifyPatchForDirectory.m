function classifyPatchForDirectory(imgdir,ifUseLineseg)
%Input: 
%   imgdir: the image directory you want to classify
%   ifUseLineseg: boolean value that switch on/off if to use
%                 line segment descriptor as a part of the 
%                 complete descriptor
%Output:
%   results are save as images in saveDir.

filterBank=createFilterBank();
load ./models/TextonLibrary.mat;
load ./models/EdgetonLibrary.mat;
addpath('./cannyplus');
if (ifUseLineseg == true)
    load ./models/roadSVMClassifierWithLineSegsForFourClasses.mat;
else
    load ./models/roadSVMClassifierWithoutLineSegsForFourClasses;
end

imgfilenames1 = struct2cell(dir(fullfile(imgdir,'*.JPG')));
imgfilenames2 = struct2cell(dir(fullfile(imgdir,'*.jpg')));
imgfilenames3 = struct2cell(dir(fullfile(imgdir,'*.png')));

imgfilenames = [imgfilenames1(1,:), imgfilenames2(1,:), imgfilenames3(1,:)];

saveDir = './testresults/';

if (~exist('./testresults/', 'dir'))
    mkdir(saveDir);
end

imgWidForProcess = 800;

for i = 1:numel(imgfilenames)
    %labelimage = classifyPatchWrapper(fullfile(imgdir,imgfilenames{i}), svmModel, filterBank, TextonLibrary, EdgetonLibrary);
    
    %i    
    testimg = imread(fullfile(imgdir,imgfilenames{i}));
    
    [h,w,c] = size(testimg);
    if(w>imgWidForProcess)
        testimg  = imresize(testimg, [NaN imgWidForProcess]);
    end

    [segimage, edgetonmap,textonMap,labelimage] = classifyPatch(testimg, svmModel, filterBank, TextonLibrary, EdgetonLibrary, false, ifUseLineseg);
    
    
    
    %imagesc(labelimage);
    [temp,name,temp2]= fileparts(imgfilenames{i});
    
    h = figure;
    mymap = [0,0,0;0,1,0;0,0,1;1,0,0];
    colormap(mymap);
    imagesc(labelimage,[0 3]);
    saveas(h,[saveDir, name,'_classified.png']);
    
    plotData = imread([saveDir, name,'_classified.png']);       
    labelImageForConcatenate = imresize(plotData, [NaN imgWidForProcess]);
    
    %
    colormap(jet);
    imagesc(segimage);
    saveas(h,[saveDir, name,'_classified.png']);
    segimagePlot = imread([saveDir, name,'_classified.png']);       
    segimagePlot = imresize(segimagePlot, [NaN imgWidForProcess]);
    
    imagesc(edgetonmap);
    saveas(h,[saveDir, name,'_classified.png']);
    edgetonmapPlot = imread([saveDir, name,'_classified.png']);       
    edgetonmapPlot = imresize(edgetonmapPlot, [NaN imgWidForProcess]);
    
    imagesc(textonMap);
    saveas(h,[saveDir, name,'_classified.png']);
    textonMapPlot = imread([saveDir, name,'_classified.png']);       
    textonMapPlot = imresize(textonMapPlot, [NaN imgWidForProcess]); 
    
    imageCombined = [testimg;segimagePlot;textonMapPlot;edgetonmapPlot;labelImageForConcatenate];
    
    close(h);
    imwrite(imageCombined, [saveDir, name,'_classified.png']);

end