

filename = [dirdir, datename,'/',datename, '-', sensor, '.txt'];
y_title = [sensor, ' ', unit];
fprintf(1,'\n%s\n',y_title);
if (~exist(filename,'file'))
    good_data = 0;
    fprintf(1,'\n !!!!!!!!  Warning read_plot_one: no %s !!!!! \n\n', filename);
else
    fid = fopen(filename);
    C = textscan(fid, '%20c                    %f %1c   %f  %1c   %f ');
    fclose(fid);
    
    %  ...sensor.txt:
    % 20121002_163336_681: 9.512718, 0.343835, -1.959575
    %   %20c                    %f %1c   %f  %1c   %f
    
    [dates, VALseconds] = str2datenum(C{1},0);
    VALdate0 = dates(1);
    
    ax = C{2};
    ay = C{4};
    az = C{6};
 
    [na1,na2] = size(VALseconds);
    fprintf(1,'%s, %s: \nax: mean %6.2f std %6.3f  \nay: mean %6.2f std %6.3f\naz: mean %6.2f std %6.3f \n', ...
        filename, title_name, mean(ax), std(ax), mean(ay), std(ay), mean(az), std(az));
        fprintf(1,'Update rate: %.1f Hz\n',na1/(VALseconds(na1)-VALseconds(1)));
    figure
    %plot the values:
    subplot(2,2,1)
    plot(VALseconds,ax)
    hold on
    plot(VALseconds,ay,'r')
    plot(VALseconds,az,'k')
    hold off
    xlabel('time [s]')
    ylabel(y_title)
    legend('x','y','z')
    title(title_name)
    
    % plot the time steps
    subplot(2,2,3)
    plot(VALseconds,'.')
    ylabel('time [s]')

    % plot the difference in time steps
    subplot(2,2,4)
    plot(diff(VALseconds),'.')
    ylabel('diff time [s]')
       
end


