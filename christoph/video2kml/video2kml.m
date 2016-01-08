

clear
close all

main_dir = 'all_data_all';
%main_dir = 'all_data_small_test';

% nominal origin of longitude and latitude
%Pittsburgh:
lon0 = -81.0;
lat0 = 40.0;
%District D-4:
%lon0 = -76.0;
%lat0 = 41.0;
%District D-9:
%lon0 = -79.0;
%lat0 = 40.0;

%min_dist = 5;  % min_
min_dist = 2;  % min_

% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

if (nr1 == 0)
    fprintf(1,'something wrong, only %d files, maybe no external disk present?\n', nr1);
end

% directory of one run
%run_name = run_list(3).name;
%read_one_run


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% produce the kml

%max_run = 5;
max_run = nr1;
tic
%for cc = 1:7
for cc = 7:7
%for cc = 2:2
    
    clear last_date
    clear only_latest
    
    if cc == 1
        kml_file_name = 'day_latest.kml';
        txt_only_file_name = 'day_latest.txt';
        c_name = 'yellow';
        only_latest = 1;
        day_night_dd = 1; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 2
        kml_file_name = 'day_all.kml';
        txt_only_file_name = 'day_all.txt';
        c_name = 'white';
        only_latest = 0;
        day_night_dd = 1; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 3
        kml_file_name = 'night_latest.kml';
        txt_only_file_name = 'night_latest.txt';
        c_name = 'blue';
        only_latest = 1;
        day_night_dd = 2; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 4
        kml_file_name = 'night_all.kml';
        txt_only_file_name = 'night_all.txt';
        c_name = 'black';
        only_latest = 0;
        day_night_dd = 2; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 5
        kml_file_name = 'dawn_dusk_latest.kml';
        txt_only_file_name = 'dawn_dusk_latest.txt';
        c_name = 'cyan';
        only_latest = 1;
        day_night_dd = 3; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 6
        kml_file_name = 'dawn_dusk_all.kml';
        txt_only_file_name = 'dawn_dusk_all.txt';
        c_name = 'magenta';
        only_latest = 0;
        day_night_dd = 3; % all = 0 day = 1 night = 2 dawn/dusk = 3
    elseif cc == 7
        kml_file_name = 'all_day_latest.kml';
        txt_only_file_name = 'all_day_latest.txt';
        c_name = 'yellow';
        only_latest = 1;
        day_night_dd = 0; % all = 0 day = 1 night = 2 dawn/dusk = 3
    end
    
    size_sparse = 100000;
    % if we want only the latest images, create the last_date matrix
    if only_latest == 1
        last_date = spalloc(size_sparse,size_sparse,10000); % creates sparse matrix with room for 10000 non-zero elements
%        for k=1:nr1
        for k=max_run:-1:1
            run_name = run_list(k).name;
            fprintf(1,'adding run %d for matrix: %s\n',k,run_name);
            read_one_run
            if (good_data == 1)
                if ( day_night_dd == 0 ...
                        || (day_night_dd == 1 && isDay == 1) ...
                        || (day_night_dd == 2 && isNight == 1) ...
                        || (day_night_dd == 3 && isDawnDusk == 1) )
                    
                    make_gps_matrix
                    
                end
            end
        end
    end
    
    start_kml
   
    %one_run_kml
    
    %for k=1:nr1   106
    %for k=1:nr1
    for k=1:max_run
        run_name = run_list(k).name;
        fprintf(1,'adding run %d: %s\n',k,run_name);
        read_one_run
        if (good_data == 1)
            if ( day_night_dd == 0 ...
                    || (day_night_dd == 1 && isDay == 1) ...
                    || (day_night_dd == 2 && isNight == 1) ...
                    || (day_night_dd == 3 && isDawnDusk == 1) )
                one_run_kml
                
            end
        end
    end
    
    end_kml
    
    
end

toc