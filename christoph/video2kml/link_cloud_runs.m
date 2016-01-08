
clear
close all

% choose the directory you want to link to:
%sub_dir = 'video-data_upto_june_26_2013';
%sub_dir = 'video-data_upto_june2013';
%sub_dir = 'video-data_upto_may2013';
sub_dir = 'video-data';


% all_data_up -> /media/My Passport/ResearchData/
main_dir = ['all_data_up/', sub_dir];
%main_dir = '/media/My\ Passport/ResearchData/video-data_upto_june_26_2013';
% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

% directory of one run
%run_name = run_list(3).name;
%read_one_run

for k=1:nr1
%for k=1:1
%for k=109:112
    run_name = run_list(k).name;
    
    dirdir = [main_dir,'/',run_name];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  check if weather data is there
    file = [run_name,'-weather_short.txt'];
    filename = [ dirdir ,'/', file];
    
    fprintf(1,'%d %s:  ', k, run_name);
    
    if (~exist(filename,'file'))
        fprintf(1,'Warning: no %s\n', filename);
    else
        fid = fopen(filename);
        S = fscanf(fid,'%s');
        fclose(fid);
        
        % possible weather summaries:
        % LightSnow, Flurries, Rain, LightRain, Drizzle, Overcast, MostlyCloudy,
        % PartlyCloudy, Clear, Dry
        clouds = strcmp(S,'Overcast') +  strcmp(S,'MostlyCloudy');

        is_day_night_dawn_dusk
        
        fprintf(1,'%s  cloud: %d  isDay: %d', S, clouds, isDay);
        if (clouds == 1 && isDay == 1)
            command1 = ['cd ', main_dir, ' ; cd ../clouds ; ', 'ln -s ../',sub_dir,'/', run_name, ' ', run_name];
            system(command1);
        end
    end
    fprintf(1,'\n');
   
end