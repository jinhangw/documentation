
for i = 1:2
    for j=1:4
        subplot(4,4,(i-1)*4+j);
        imagesc(filterBank{1}{i,j});
    end
end

for i = 1:3
    
    subplot(4,4,(3-1)*4+i);
    imagesc(filterBank{2}{i});
    
end

for i = 1:4
    
    subplot(4,4,(4-1)*4+i);
    imagesc(filterBank{3}{i});
    
end