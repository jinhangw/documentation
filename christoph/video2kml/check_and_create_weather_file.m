
clear
close all

main_dir = 'all_data';

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
    
    fprintf(1,'%d: ', k);
    
    command1 = ['ls ', dirdir, '/*weather_short.txt'];
    system(command1);
    if (~exist(filename,'file'))
        
        file_gps = [run_name,'-gps.txt'];
        filename_gps = [ dirdir ,'/', file_gps];
        file_json = [run_name,'-weather-data.json'];
        filename_json = [ dirdir ,'/', file_json];
        
        if (~exist(filename_json,'file'))
            command2 = ['(python get.py ', filename_gps, ') > ', filename_json ];
            system(command2);
        end
        command3 = ['(python parse_short.py ', filename_json, ') > ', filename ];
        system(command3);
        
    end
    
end 