
all_file = [dirdir,'all.txt'];
command1 = ['rm ', all_file];
system(command1);

dirdir = '/home/data/photo-data/20120816/';
files = dir([dirdir, '*.txt']);

command2 = ['touch ', all_file];
system(command2);


%length(files)
%files(1).name

for i=1:length(files)
    fid = fopen([dirdir, files(i).name]);
    C = textscan(fid, '%3c');
    fclose(fid);
    fprintf(1,'%s: %s %d',files(i).name,C{1}(1,1:3),strcmp(C{1}(1,1:3),'IMG'));
    
    if strcmp(C{1}(1,1:3),'IMG')
        
        fid = fopen([dirdir, files(i).name]);
        C = textscan(fid, '%23c %2c %f        %c%f         %2c %f    %2c%f%1c %f%1c%f%2c  %f   %1c   %f     %1c %f      %s');
        fclose(fid);
        
        [na1, na2] = size(C{13}); % sometimes there is infinity, this will test it
        fprintf(1,' %f %d', C{3}(1), na1);
        
        if C{3}(1) < -10 && na1 > 0
            fprintf(1,' %f good ', C{15}(1)); % direction of gravity 
            command3 = ['cat ', dirdir, files(i).name, ' >> ', all_file];
            system(command3);
        end
        
    end
    fprintf(1,'\n');
end


