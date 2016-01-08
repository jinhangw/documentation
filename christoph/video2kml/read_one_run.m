

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
    if (strcmp(C{1}(1),'2'))  % new format
        
        fid = fopen(filename);
        C = textscan(fid, ' %19c %1c %19c');
        fclose(fid);
        
        [dates, STARTseconds] = str2datenum(C{1},0);
        STARTdate0 = dates(1);
        
        [dates, ENDseconds] = str2datenum(C{3},STARTdate0);
        
    else % old format
        
        
        
        %START: 20121002_163334_616
        %STOP: 20121002_163541_383
        
        [dates, STARTseconds] = str2datenum(C{2},0);
        STARTdate0 = dates(1);
        
        [dates, ENDseconds] = str2datenum(C{4},STARTdate0);
    end
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
    
    % around Pittsburgh latitude is 40 and longitute -80
    % somewhere a mistake in the data collection was made and longitute and
    % latitude was switched. Here we select the correct one.
    templl = C{2};
    if (mean(templl) <40)
        lon = C{2};
        lat = C{4};
    else
        lon = C{4};
        lat = C{2};
    end
    %  Latitude at 109.3 seconds: interp1(GPSseconds,lat,109.3)
    
    if (max(diff(GPSseconds)) > 120)
        fprintf(1,'Warning: more than 2 min jump in time: %.1f\n', max(diff(GPSseconds)));
        good_data = 0;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the accel
file = [run_name,'-accel.txt'];
filename = [ dirdir ,'/', file];


if (~exist(filename,'file'))
    good_data = 0;
    fprintf(1,'Warning: no %s\n', filename);
else
    fid = fopen(filename);
    C = textscan(fid, '%20c                    %f %1c   %f  %1c   %f ');
    fclose(fid);
    
    %  gps.txt:
    % 20121002_163336_681: 9.512718, 0.343835, -1.959575
    %   %20c                    %f %1c   %f  %1c   %f
    
    [dates, ACCseconds] = str2datenum(C{1},STARTdate0);
    ACCdate0 = dates(1);
    
    % sometimes there is the same time twice or even more often. Fix that by changing one of
    % the times slightly:
    s_fix =  diff(ACCseconds);
    ind_fix =  s_fix <= 0;
    
    while (sum(ind_fix) > 0)
        ACCseconds(2:end) = ACCseconds(2:end) + ind_fix.*(0.0001-s_fix);
        s_fix =  diff(ACCseconds);
        ind_fix =  s_fix <= 0;
    end
    
    
    ax = C{2};
    ay = C{4};
    az = C{6};
    %  Latitude at 109.3 seconds: interp1(seconds,Lat,109.3)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read images

image_list = dir([dirdir,'/*.jpg']);
[ni1,ni2] = size(image_list);

IMseconds = linspace(1,ni1,ni1);
IMseconds = STARTseconds + (IMseconds-1) * (ENDseconds - STARTseconds)/(ni1-1);
IMdates = STARTdate0 + IMseconds/86400.0;

% interpolated GPS for each image:
% this will make sure that the seconds are monotonically increasing:
ind_mono = ones(size(GPSseconds));
ind_mono(2:end) = diff(GPSseconds);

IMlat = interp1(GPSseconds(ind_mono>0),lat(ind_mono>0),IMseconds);
IMlon = interp1(GPSseconds(ind_mono>0),lon(ind_mono>0),IMseconds);

% this will make sure that the seconds are monotonically increasing:
ind_mono = ones(size(ACCseconds));
ind_mono(2:end) = diff(ACCseconds);

IMax  = interp1(ACCseconds(ind_mono>0),ax(ind_mono>0),IMseconds);

IMplotit = zeros(size(IMseconds));



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

