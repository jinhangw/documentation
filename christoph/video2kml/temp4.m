

clear
close all

main_dir = 'all_data';

% nominal origin of longitude and latitude
lon0 = -81.0;
lat0 = 40.0;

%min_dist = 5;  % min_
min_dist = 2;  % min_


%txt_list = dir([main_dir,'/2*_*txt']);
%[nt1,nt2] = size(txt_list);


%for i=1:nt1
%    command1 = ['mv ',main_dir,'/',txt_list(1).name,' ',main_dir,'/rest/.'];
%    system(command1);
%end

% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);



