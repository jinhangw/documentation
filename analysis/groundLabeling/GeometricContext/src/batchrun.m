addpath(genpath('.'));
rootPath = '/home/ranqi/work/roadDetection/';


dataDirs = {'20120807_063017_small'};


for i = 1:size(dataDirs,2)
    
    dataDir = dataDirs{i};
    
    dirName = [rootPath dataDir];
    fileList = getAllFiles(dirName);
    filenum = size(fileList,1);
    
    outputDir = ['../test_dir/' dataDir '_label_result'];
    if (exist(outputDir,'dir') == 0)
        mkdir(outputDir);
    end
    
    outputDir
    
    for i=1:filenum
        tic
        cur_filename = fileList(i);
        
        cur_filename
        
        [pathstr, name, ext] = fileparts(cur_filename{1});
        name
        
        
        
        if(strcmp(ext,'.jpg'))
            photoPopupIjcv('../data/ijcvClassifier.mat', cur_filename{1}, [], outputDir)
        end
        toc
    end
    
    
end
