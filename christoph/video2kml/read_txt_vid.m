

clear

%dirdir = ['/home/mertz/Dropbox/20120816_140355/'];
dirdir = ['/Users/srivatsan/Documents/Project_Pothole/Test/8 Oct/'];
imdir  = ['/Users/srivatsan/Documents/Project_Pothole/Test/output/8 Oct/VID_20121005_155824_069'];

lon0 = -81.0;
lat0 = 40.0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  read start and stop
file = '20121005_155824_069-startstop.txt';
filename = [ dirdir , file];


fid = fopen(filename);
C = textscan(fid, ' %7c %19c %6c %19c');
fclose(fid);


%START: 20121002_163334_616
%STOP: 20121002_163541_383

[dates, STARTseconds] = str2datenum(C{2},0);
STARTdate0 = dates(1);

[dates, ENDseconds] = str2datenum(C{4},STARTdate0);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the gps
file = '20121005_155824_069-gps.txt';
filename = [ dirdir , file];


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the accel
file = '20121005_155824_069-accel.txt';
filename = [ dirdir , file];


fid = fopen(filename);
C = textscan(fid, '%20c                    %f %1c   %f  %1c   %f ');
fclose(fid);

%  gps.txt:
% 20121002_163336_681: 9.512718, 0.343835, -1.959575
%   %20c                    %f %1c   %f  %1c   %f

[dates, ACCseconds] = str2datenum(C{1},STARTdate0);
ACCdate0 = dates(1);

ax = C{2};
ay = C{4};
az = C{6};
%  Latitude at 109.3 seconds: interp1(seconds,Lat,109.3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read images

image_list = dir([imdir,'/*.png']);
[ni1,ni2] = size(image_list);

IMseconds = linspace(1,ni1,ni1);
IMseconds = STARTseconds + (IMseconds-1) * (ENDseconds - STARTseconds)/(ni1-1);
IMdates = STARTdate0 + IMseconds/86400.0;

% interpolated GPS for each image:
IMlat = interp1(GPSseconds,lat,IMseconds);
IMlon = interp1(GPSseconds,lon,IMseconds);
IMax  = interp1(ACCseconds,ax,IMseconds);

IMplotit = zeros(size(IMseconds));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% produce the kml

fidw = fopen('images.kml','w');


fprintf(fidw,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fidw,'<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(fidw,'<Document>\n');

last_date = spalloc(100000,100000,ni1); % creates sparse matrix with room for ni1 non-zero elements
for i=4:ni1 %first couple of images are ususally black or ill-exposed
    if (~isnan(IMlat(i)) && ~isnan(IMlat(i-1))) % GPS needs to be a real number!
        % we discretize the longitude and latitude by 1/10000 degree, about
        % 10 m
        na = floor((IMlat(i)-lat0)*10000);
        no = floor((IMlon(i)-lon0)*10000);
        if (last_date(na,no) < IMdates(i))
            last_date(na,no) = IMdates(i);
        end
    end
end

prev_dlat = 0;
prev_dlon = 0;
for i=4:ni1 %first couple of images are ususally black or ill-exposed
    
    if (~isnan(IMlat(i)) && ~isnan(IMlat(i-1))) % GPS needs to be a real number!
        
        dlat = (IMlat(i)-lat0)*10000;
        dlon = (IMlon(i)-lon0)*10000;
        na = floor(dlat);
        no = floor(dlon);
        
        ddlat = dlat - prev_dlat;
        ddlon = dlon - prev_dlon;
        del = sqrt(ddlat*ddlat + ddlon*ddlon);
        
        % downsample: only use image when it is the latest one
        % and make sure that the new image is more than 0.3*discretization
        % away from the previous image
        if (last_date(na,no) == IMdates(i) && del > 0.3)
            % get the angle for the arrow icon
            prev_dlat = dlat;
            prev_dlon = dlon;
            
            del_east  = IMlon(i) - IMlon(i-1);
            del_north = IMlat(i) - IMlat(i-1);
            ang = atan2(del_east,del_north)/pi*180 + 22.5;
            
            
            fprintf(fidw,'  <Placemark>\n');
            %fprintf(fidw,'    <name>Simple placemark</name>\n');
            
            % the normal placemark is an arrow in the direction of travel
            fprintf(fidw,'      <Style id="normalPlacemark">\n');
            fprintf(fidw,'        <IconStyle>\n');
            fprintf(fidw,'          <scale>1.2</scale>\n');
            fprintf(fidw,'          <Icon>\n');
            
            
            % choose the arrow icon
            if ang < -135
                fprintf(fidw,'            <href>direction_down.png</href>\n');
            elseif  ang < -90
                fprintf(fidw,'            <href>direction_downleft.png</href>\n');
            elseif  ang < -45
                fprintf(fidw,'            <href>direction_left.png</href>\n');
            elseif  ang < 0
                fprintf(fidw,'            <href>direction_upleft.png</href>\n');
            elseif  ang < 45
                fprintf(fidw,'            <href>direction_up.png</href>\n');
            elseif  ang < 90
                fprintf(fidw,'            <href>direction_upright.png</href>\n');
            elseif  ang < 135
                fprintf(fidw,'            <href>direction_right.png</href>\n');
            elseif  ang < 180
                fprintf(fidw,'            <href>direction_downright.png</href>\n');
            else
                fprintf(fidw,'            <href>direction_down.png</href>\n');
            end
            
            fprintf(fidw,'          </Icon>\n');
            fprintf(fidw,'        </IconStyle>\n');
            fprintf(fidw,'      </Style>\n');
            
            
            %    fprintf(fidw,'      <styleUrl>#normalPlacemark</styleUrl>\n');
            
            fprintf(fidw,'    <description> <![CDATA[\n');
            
            if (IMax(i) > -8.0) % test gravitational vector
                fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%s%s">\n',imdir,image_list(i).name);
            else % use the flipped images
                fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%sflip/%s">\n',imdir,image_list(i).name);
            end
            
            fprintf(fidw,'            ]]> </description>\n');
            fprintf(fidw,'    <Point>\n');
            fprintf(fidw,'      <coordinates> %.8f ,%.8f ,0</coordinates>\n',IMlon(i),IMlat(i));
            fprintf(fidw,'    </Point>\n');
            fprintf(fidw,'    <TimeStamp>\n');
            %  the date needs to look like this:
            %    <when>1997-07-16T07:30:15Z</when>
            print_date = datestr(STARTdate0+IMseconds(i)/86400,31);
            print_date(11) = 'T';
            
            fprintf(fidw,'      <when>%sZ</when>\n',print_date);
            fprintf(fidw,'    </TimeStamp>\n');
            
            fprintf(fidw,'  </Placemark>\n');
        end
    end
end
fprintf(fidw,'</Document>\n');
fprintf(fidw,'</kml>\n');


fclose(fidw);


