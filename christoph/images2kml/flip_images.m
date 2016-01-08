


dirdir = '/home/data/photo-data/20120816/';
files = dir([dirdir, '*.jpg']);

for i=1:length(files)
    file_nam1 = [dirdir, files(i).name];
    file_nam2 = [dirdir,'flip/', files(i).name];
    command1 = ['convert ',file_nam1,' -rotate 180 ', file_nam2];
    system(command1);
    if mod(i,10) == 0
        fprintf(1,' %d %s\n',i, command1);
    end
end




