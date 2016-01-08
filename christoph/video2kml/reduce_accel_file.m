


fprintf(1,'    >>>>>>  reducing accel file <<<< \n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the accel
file = [run_name,'-accel.txt'];
filename = [ dirdir ,'/', file];


fid = fopen(filename);
C = textscan(fid, '%20c                    %f %1c   %f  %1c   %f ');
fclose(fid);

%  gps.txt:
% 20121002_163336_681: 9.512718, 0.343835, -1.959575
%   %20c                    %f %1c   %f  %1c   %f

file = [run_name,'-accel_new.txt'];
filename = [ dirdir ,'/', file];

[nc1,nc2] = size(C{1});

fid = fopen(filename,'w');
for l=1:nc1
    if index(l) == 1
        fprintf(fid,'%s %f, %f, %f\n',C{1}(l,:),C{2}(l),C{4}(l),C{6}(l));
    end
end
fclose(fid);

file = [run_name,'-accel.txt'];
filename = [ dirdir ,'/', file];
file_new = [run_name,'-accel_new.txt'];
filename_new = [ dirdir ,'/', file_new];
file_old = [run_name,'-accel_old.txt'];
filename_old = [ dirdir ,'/', file_old];

command4 = ['mv ',filename, ' ',filename_old];
command5 = ['mv ',filename_new, ' ',filename];

system(command4);
system(command5);
