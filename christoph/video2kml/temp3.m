
for i=1:nr1
    run1(i,1:15) = run_list(i).name(1:15);
end

for i=1:na1
    all1(i,1:15) = all_list(i).name(5:19);
end

celldata = cellstr(run1);

for i=1:na1
    fprintf(1,'%s: %d\n',all1(i,:),sum(strcmp(all1(i,:),celldata)));
    if (sum(strcmp(all1(i,:),celldata)) > 0)
        command1 = ['cp /home/pork/Desktop/ResearchData/video-data/*',all1(i,:),'* ',main_dir];
        system(command1);
        fprintf('%s\n',command1);
    end
end

