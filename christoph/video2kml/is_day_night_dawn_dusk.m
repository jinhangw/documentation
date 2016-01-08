

%This script reads one run
% input:
%        main_dir  e.g. all_data
%        run_name  e.g. 20121002_163128_189


% the directory which contains all the data (*.txt files and images)
dirdir = [main_dir,'/',run_name];

good_data = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  read start and stop
file = [run_name,'-startstop.txt'];
filename = [ dirdir ,'/', file];

if (~exist(filename,'file'))
    good_data = 0;
    fprintf(1,'Warning: no %s\n', filename);
else
    fid = fopen(filename);
    C = textscan(fid, ' %7c %19c %6c %19c');
    fclose(fid);
    
    
    %START: 20121002_163334_616
    %STOP: 20121002_163541_383
    
    [dates, STARTseconds] = str2datenum(C{2},0);
    STARTdate0 = dates(1);
    
    [dates, ENDseconds] = str2datenum(C{4},STARTdate0);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the gps
file = [run_name,'-gps.txt'];
filename = [ dirdir ,'/', file];


if (~exist(filename,'file'))
    good_data = 0;
    fprintf(1,'Warning: no %s\n', filename);
else
    fid = fopen(filename);
    C = textscan(fid, ' %20c                    %f           %1c     %f');
    fclose(fid);
    
    %  gps.txt:
    % 20121002_163351_120: -79.95439114049077, 40.43452796526253
    %   %20c                    %f           %1c     %f
    %                          Lon                  Lat
    
    [dates, GPSseconds] = str2datenum(C{1},STARTdate0);
    GPSdate0 = dates(1);
    
    lon = C{2};
    lat = C{4};
    %  Latitude at 109.3 seconds: interp1(GPSseconds,lat,109.3)
    
    if (max(diff(GPSseconds)) > 120)
        fprintf(1,'Warning: more than 2 min jump in time: %.1f\n', max(diff(GPSseconds)));
        good_data = 0;
    end
end



isNight = 0;
isDay   = 0;
isDawnDusk = 0;

str_date = datestr(STARTdate0,23);
isDaySave = is_Daylight_Savings(str_date);
hour_offset = 5 - isDaySave;

[SunRiseSet,Day,Dec,Alt,Azm,Rad] =  suncycle(lat(1),lon(1),STARTdate0);
sunRise = SunRiseSet(1)-hour_offset;
sunSet = SunRiseSet(2)-hour_offset;
if sunSet < 12
    sunSet = 24 + sunSet;
end

time_of_day = (STARTdate0-floor(STARTdate0))*24;

if (time_of_day > sunRise+0.5 && time_of_day < sunSet-0.5)
    isDay = 1;
%    fprintf(1,'Day\n');
elseif (time_of_day < sunRise-0.5 || time_of_day > sunSet+0.5)
    isNight = 1;
%    fprintf(1,'Night\n');
else
    isDawnDusk = 1;
%    fprintf(1,'DawnDusk\n');
end

