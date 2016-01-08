



%all_list = dir('/home/pork/Desktop/ResearchData/video-data/*.mp4');
all_list = dir('temp/*.mp4');
all_txt = dir('temp/*startstop.txt');

[ns1,ns2] = size(all_list);
[nt1,nt2] = size(all_txt);

for i=1:ns1
    
    run_name = all_list(i).name(5:23);
    datestr(1,1:19) = run_name;
    [l_dates,l_seconds] = str2datenum(datestr, -1);
    fprintf(1,' %s %.3f\n', run_name, l_seconds);
    for j=1:nt1
        
        txt_name = all_txt(j).name(1:15);
        datestr(1,1:15) = txt_name;
        datestr(1,16:19) = '_000';
        [t_dates,t_seconds] = str2datenum(datestr, -1);
        if (abs(l_seconds - t_seconds) < 5)
            fprintf(1,' %s     %.3f\n', txt_name, t_seconds);
            if (abs(l_seconds - t_seconds) > 0.01)
                command = ['cd temp; mv ',txt_name,'-startstop.txt ',run_name,'-startstop.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
                command = ['cd temp; mv ',txt_name,'-accel.txt ',run_name,'-accel.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
                command = ['cd temp; mv ',txt_name,'-gravity.txt ',run_name,'-gravity.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
                command = ['cd temp; mv ',txt_name,'-linaccel.txt ',run_name,'-linaccel.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
                command = ['cd temp; mv ',txt_name,'-orient.txt ',run_name,'-orient.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
                command = ['cd temp; mv ',txt_name,'-gyro.txt ',run_name,'-gyro.txt; cd .. '];
                fprintf(1,'%s\n',command);
                system(command);
            end
        end
    end
end

