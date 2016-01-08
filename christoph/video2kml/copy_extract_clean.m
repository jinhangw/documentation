
%tstart = tic;

move_data = 1;

% this is the master file that does all the stuff that needs to be done
% when a new data file arrives.

% this first one is if we copied the data from the camera to the hard drive
% location ..../temp/vid
if move_data == 1
    fprintf(1,'Moving new files ...\n');
    command1 = 'mv all_data/../temp/vid/*/*.* all_data/.';
    system(command1);

    % this second one is if we copied the data from the camera via dropbox
    % to the computer hard drive
elseif move_data == 0
    fprintf(1,'Copying new files ...\n');
    copy_new_files
end


fprintf(1,'Extract and order ...\n');
extract_and_order

fprintf(1,'Clean and reduce ...\n');
clean_reduce

fprintf(1,'Check weather file, create if not present ...\n');
check_and_create_weather_file


% other things you might want to do:
%
% create symbolic link to all the runs that were taken on cloudy days:
%
% link_cloud_runs
%
% or create symbolic link to all the runs:
%
fprintf(1,'create symbolic link to all the runs ...\n');
link_all_runs
%

%toc(tstart)
