clear
close all

main_dir = 'all_data';

% nominal origin of longitude and latitude
lon0 = -81.0;
lat0 = 40.0;


% list of all the directories = name of the runs
run_list = dir([main_dir,'/2*_*']);
[nr1,nr2] = size(run_list);

rest_list = dir([main_dir,'/rest/2*_*']);
[nrr1,nrr2] = size(rest_list);



all_list = dir('/home/pork/Desktop/ResearchData/video-data/*.mp4');
[na1,na2] = size(all_list);





for i=1:nr1
    run1(i,1:15) = run_list(i).name(1:15);
end

for i=1:nrr1
    run2(i,1:15) = rest_list(i).name(1:15);
end

for i=1:na1
    [an1,an2] = size(all_list(i).name);
    if (an2 < 19)
        fprintf(1,' !!!File name too short: %s something is wrong!!!\n', all_list(i).name);
    else
        all1(i,1:15) = all_list(i).name(5:19);
    end
end



if (exist('run1'))
    celldata = cellstr(run1);
else
    celldata = {'dummy1' 'dummy2'};
end

if (exist('run2'))
    celldata1 = cellstr(run2);
else
    celldata1 = {'dummy1' 'dummy2'};
end



for i=1:na1
    [an1,an2] = size(all_list(i).name);
    if (an2 >= 19)   % file name long enough
        if (sum(strcmp(all1(i,:),celldata)) == 0 && sum(strcmp(all1(i,:),celldata1)) == 0 )
            command1 = ['cp /home/pork/Desktop/ResearchData/video-data/*',all1(i,:),'* ',main_dir];
            system(command1);
            fprintf(1,'%s: %d %d\n',all1(i,:),sum(strcmp(all1(i,:),celldata)),sum(strcmp(all1(i,:),celldata1)));
            fprintf('%s\n',command1);
        end
    end
end




