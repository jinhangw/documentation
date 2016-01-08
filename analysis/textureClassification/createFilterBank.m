function [filterBank] = createFilterBank;
    filterBank = {};
    filterBank{1} = cell(2,4);
    filterBank{2} = cell(1,3);
    filterBank{3} = cell(1,4);
    
    for i = 1:4
        filterBank{1}{1,i} = createGaborFilter((i-1)*0.25*3.14159,1);
        filterBank{1}{2,i} = createGaborFilter((i-1)*0.25*3.14159,0);
    end
    
    for i = 1:3
        sigma = 2^(i-1);
        half_size = 3 * sigma;
        size = 2 * half_size + 1;
        filterBank{2}{1,i} = fspecial('gaussian',[size,size],sigma);
    end
    
    for i = 1:4
        sigma = 2^(i-1);
        half_size = 3 * sigma;
        size = 2 * half_size + 1;
        filterBank{3}{1,i} = fspecial('log',[size,size],sigma);
    end
end