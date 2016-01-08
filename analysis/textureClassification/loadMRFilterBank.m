function filterBank = loadMRFilterBank;
    addpath('filterBank');
  
    RFSFilter = makeRFSfilters;
    
    filterBank = {};
    filterBank{1} = cell(6,6);
    filterBank{2} = cell(1,2);
    
    
    for i = 1:6
        for j = 1:6
            filterBank{1}{i,j} = RFSFilter(:,:,(i-1)*6+j);
        end
    end
    
        
    filterBank{2}{1,1} = RFSFilter(:,:,37);
    filterBank{2}{1,2} = RFSFilter(:,:,38);

    
    
end