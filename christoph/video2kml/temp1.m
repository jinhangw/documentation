
clear
close all

main_dir = 'all_data';

% nominal origin of longitude and latitude
lon0 = -81.0;
lat0 = 40.0;


% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);


command1 = ['mv ',main_dir,'/*.txt ',main_dir,'/rest/.'];
system(command1);
command2 = ['mv ',main_dir,'/*.mp4 ',main_dir,'/rest/.'];
system(command2);
command3 = ['mv ',main_dir,'/*.jpg ',main_dir,'/rest/.'];
system(command3);

tic


%for k=1:nr1
for k=1:nr1
    
    run_name = run_list(k).name;
    dirdir = [main_dir,'/',run_name];
    video_file = dir([dirdir, '/*.mp4']);
    
    command4 = ['ffmpeg -i ', dirdir,'/', video_file.name, ' ', dirdir,'/img%04d.jpg'];
    system(command4);
     fprintf(1,'read run %d: %s\n',k,run_name);
   
end
toc