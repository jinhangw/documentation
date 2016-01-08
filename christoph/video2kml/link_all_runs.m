
clear
close all

base_dir = 'all_data_up';
link_dir = 'video-data_all';

%for is = 1:5
for is = [1,3,5,6]
    % choose the directory you want to link to:
    if is == 1
        sub_dir = 'video-data';
    elseif is == 2
        sub_dir = 'video-data_upto_june_26_2013';
    elseif is == 3
        sub_dir = 'video-data_upto_june2013';
    elseif is == 4
        sub_dir = 'video-data_upto_may2013';
    elseif is == 5
        sub_dir = 'video-data_upto_dec2013';
    elseif is == 6
        sub_dir = 'video-data_upto_dec2012';
    else
        fprintf(1,'is = %d is not associated with a diretory!\n', is);
    end
    
    % all_data_up -> /media/My Passport/ResearchData/
    main_dir = [base_dir, '/', sub_dir];
    
    fprintf(1,'\nMain directory: %s\n', main_dir);
    
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
        
        link_name = [ base_dir, '/',  link_dir, '/', run_name];
        
        if (~exist(link_name,'dir'))
            fprintf(1,'%d linking: %s to %s \n', k, dirdir, link_name);
            
            command1 = ['cd ', main_dir, ' ; cd ../', link_dir, ' ; ', 'ln -s ../',sub_dir,'/', run_name, ' .'];
            system(command1);
        end
        
        
    end
    
end