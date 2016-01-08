


clear
close all

main_dir = 'all_data';

% nominal origin of longitude and latitude
lon0 = -81.0;
lat0 = 40.0;

%min_dist = 5;  % min_
min_dist = 2;  % min_



%for i=1:nt1
%    command1 = ['mv ',main_dir,'/',txt_list(1).name,' ',main_dir,'/rest/.'];
%    system(command1);
%end

% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

minLon = -79.9553;
maxLon = -79.9525;
minLat = 40.4335;
maxLat = 40.4346;

for k=1:nr1
    %    tic
    run_name = run_list(k).name;
    fprintf(1,'reading run %d: %s\n',k,run_name);
    read_one_run
%    fprintf(1,'GPS: %.2f ACC: %.2f  End: %.2f \n',GPSseconds(end), ACCseconds(end), ENDseconds);
    %    toc
    ind1 = lon>minLon;
    ind2 = lon<maxLon;
    ind3 = lat>minLat;
    ind4 = lat<maxLat;
    index = ind1.*ind2.*ind3.*ind4;
    fprintf(1,'sum: %d\n',sum(index));
    if (sum(index>0))
       targetDir = ['/home/data/pothole/video-data/',run_name];
       linkDir = ['/home/data/pothole/video-data-belgreen/',run_name];
       if (~exist(linkDir,'dir'))
           command1 = ['ln -s ',targetDir, ' ',linkDir];
           fprintf(1,'%s\n',command1);
           system(command1);
       end
    end
    
end


