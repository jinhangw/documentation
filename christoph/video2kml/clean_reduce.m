

clear
close all

main_dir = 'all_data';

% nominal origin of longitude and latitude
lon0 = -81.0;
lat0 = 40.0;

%min_dist = 5;  % min_
min_dist = 2;  % min_

% to reduce the number of runs we look at if we run this script repeatedly,
% we only look at runs after this date (it's the date the file was copied):
% to get the datenum of today, use the command:
% >> datenum(date)  
% the reverse is:
% >> datestr(735243)
%  ans =
%  09-Jan-2013

%datenum_min = 735243;
%datenum_min = 735480;
%datenum_min = 735507; % 30-Sep-2013
%datenum_min = 735555; % 17-Nov-2013
datenum_min = 735570; % 02-Dec-2013

%txt_list = dir([main_dir,'/2*_*txt']);
%[nt1,nt2] = size(txt_list);

command1 = ['mv ',main_dir,'/*.txt ',main_dir,'/rest/.'];
system(command1);
command2 = ['mv ',main_dir,'/*.mp4 ',main_dir,'/rest/.'];
system(command2);
command3 = ['mv ',main_dir,'/*.jpg ',main_dir,'/rest/.'];
system(command3);

%for i=1:nt1
%    command1 = ['mv ',main_dir,'/',txt_list(1).name,' ',main_dir,'/rest/.'];
%    system(command1);
%end

% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

% no cleanup: Elapsed time is 454.977139 seconds = 7.5 min.
% remove no gps:              421.134821 seconds.
% reduce accel files:         265.3 seconds
% reduce gps files:           180.35886 seconds = 3 min.
tic

% move files that have no GPS:
for k=1:nr1
%for k=3700:3750
    
    if (run_list(k).datenum > datenum_min)
        
        %for k=10:10
        %    tic
        run_name = run_list(k).name;
        dirdir = [main_dir,'/',run_name];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % read the gps
        file = [run_name,'-gps.txt'];
        filename = [ dirdir ,'/', file];
        
        good_data = 1;
        if (~exist(filename,'file'))
            good_data = 0;
        else
            this_file = dir(filename);
            if (this_file.bytes < 100)  % almost no data
                good_data = 0;
            end
        end
        
        if (good_data==0)
            fprintf(1,'Warning: no or very small %s, moving whole directory\n', filename);
            check_dir =  [main_dir, '/rest/', run_name];
            if(~exist(check_dir,'dir'))
                command2 = ['mv ', dirdir, ' ', main_dir, '/rest/.'];
            else
                command2 = ['rm -r ',dirdir];
                fprintf(1,' ... directory already exists, rm \n');
            end
            
            system(command2);
        end
        
        
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % do the same for the accel file, but only if the data is good
        if (good_data == 1)
            file = [run_name,'-accel.txt'];
            filename = [ dirdir ,'/', file];
            %fprintf(1,'filename %d: %s \n', k, filename);
            %this_file = dir(filename);
            %fprintf(1,'this_file.byte = %d \n', this_file.bytes);
            
            if (~exist(filename,'file'))
                good_data = 0;
            else
                this_file = dir(filename);
                if (this_file.bytes < 100)  % almost no data
                    good_data = 0;
                end
            end
            
            if (good_data==0)
                fprintf(1,'Warning: no or very small %s, moving whole directory\n', filename);
                check_dir =  [main_dir, '/rest/', run_name];
                if(~exist(check_dir,'dir'))
                    command2 = ['mv ', dirdir, ' ', main_dir, '/rest/.'];
                else
                    command2 = ['rm -r ',dirdir];
                    fprintf(1,' ... directory already exists, rm \n');
                end
                
                system(command2);
            end
        end
       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % do the same for the startstop file, but only if the data is good
        if (good_data == 1)
            file = [run_name,'-startstop.txt'];
            filename = [ dirdir ,'/', file];
            %fprintf(1,'filename %d: %s \n', k, filename);
            %this_file = dir(filename);
            %fprintf(1,'this_file.byte = %d \n', this_file.bytes);
            
            if (~exist(filename,'file'))
                good_data = 0;
            else
                this_file = dir(filename);
                if (this_file.bytes == 0)  % no data
                    good_data = 0;
                end
            end
            
            if (good_data==0)
                fprintf(1,'Warning: no or empty %s, moving whole directory\n', filename);
                check_dir =  [main_dir, '/rest/', run_name];
                if(~exist(check_dir,'dir'))
                    command2 = ['mv ', dirdir, ' ', main_dir, '/rest/.'];
                else
                    command2 = ['rm -r ',dirdir];
                    fprintf(1,' ... directory already exists, rm \n');
                end
                
                system(command2);
            end
        end

        
        
    end
end
toc

% since we might have removed some directories, do the following again:
% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

% the following needs to be redone, it needs to fix all the values, not
% just accel and gps


tic
for k=1:nr1
    %    tic
    if (run_list(k).datenum > datenum_min)
        run_name = run_list(k).name;
        fprintf(1,'reading run %d: %s\n',k,run_name);
        read_one_run
        fprintf(1,'GPS: %.2f ACC: %.2f  End: %.2f \n',GPSseconds(end), ACCseconds(end), ENDseconds);
        %    toc
        
        index = ACCseconds < (ENDseconds+1);
        
        [ii1,ii2] = size(index);
        if (ii1 > sum(index)+10)
            reduce_accel_file
        end
        
        index = GPSseconds < (ENDseconds+1);
        
        [ii1,ii2] = size(index);
        if (ii1 > sum(index)+10)
            reduce_gps_file
        end
    end
end
toc


