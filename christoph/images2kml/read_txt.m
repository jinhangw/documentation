


%dirdir = ['/home/mertz/Dropbox/20120816_140355/'];
%filename = [ dirdir , '20120816_140355.txt'];

dirdir = '/home/data/photo-data/20120816/';
filename = [ dirdir , 'all.txt'];
%filename = [ dirdir , '20120817_180212.txt'];
%filename = [ dirdir , '20120816_135555.txt'];
fid = fopen(filename);
%fid = fopen('temp.txt');
%C = textscan(fid, '%23c%2c%f');
%C = textscan(fid, '%23c%2c%f%c%f%2c%f%2c%f%1c');
C = textscan(fid, '%23c %2c %f        %c%f         %2c %f    %2c%f%1c %f%1c%f%2c  %f   %1c   %f     %1c %f      %s');
fclose(fid);

year     =  str2num(C{1}(:,5:8));
month    =  str2num(C{1}(:,9:10));
day      =  str2num(C{1}(:,11:12));
hour     =  str2num(C{1}(:,14:15));
minute   =  str2num(C{1}(:,16:17));
second   =  str2num(C{1}(:,18:19));
%C
%IMG_20120816_140421.jpg||-79.95450669, 40.43360362||98.78125||0.2, 0.25, 0.3||9.343558, -0.29964766, -2.1383946||loc:on
%C = textscan(fid, '%23c %2c %f        %c%f         %2c %f    %2c%f%1c %f%1c%f%2c  %f  %1c   %f     %1c %f      %s');
%                    1    2   3         4 5          6   7     8  9 10 11 12 13 14 15   16   17

[nc1,nc2] = size(C{1});

fidw = fopen('images.kml','w');


fprintf(fidw,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fidw,'<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(fidw,'<Document>\n');
% fprintf(fidw,'  <TimeSpan>\n');
% i = 1;
% fprintf(fidw,'      <begin>%4d-%.2d-%.2dT%.2d:%.2d:%.2dZ</begin>\n',year(i),month(i),day(i),hour(i),minute(i),second(i));
% i = nc1;
% fprintf(fidw,'      <end>%4d-%.2d-%.2dT%.2d:%.2d:%.2dZ</end>\n',year(i),month(i),day(i),hour(i),minute(i),second(i));
% fprintf(fidw,'  </TimeSpan>\n');

for i=1:nc1

    
    % get the angle for the arrow icon
    ang = 0;
    if i==1
        ang = C{7}(i) + 22.5; % magnetic compass, sometimes correct
    else
        del_east = C{3}(i) - C{3}(i-1);
        del_north = C{5}(i) - C{5}(i-1);
        ang = atan2(del_east,del_north)/pi*180 + 22.5;
    end

    
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
    
    if (C{15}(i) > -8.0) % test gravitational vector
        fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%s%s">\n',dirdir,C{1}(i,:));
    else
        fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%sflip/%s">\n',dirdir,C{1}(i,:));
    end
    
   fprintf(fidw,'            ]]> </description>\n');
    fprintf(fidw,'    <Point>\n');
    fprintf(fidw,'      <coordinates> %.8f ,%.8f ,0</coordinates>\n',C{3}(i),C{5}(i));
    fprintf(fidw,'    </Point>\n');
    fprintf(fidw,'    <TimeStamp>\n');
    %fprintf(fidw,'  <when>1997-07-16T07:30:15Z</when>\n');
    fprintf(fidw,'      <when>%4d-%.2d-%.2dT%.2d:%.2d:%.2dZ</when>\n',year(i),month(i),day(i),hour(i),minute(i),second(i));
    fprintf(fidw,'    </TimeStamp>\n');
    
    fprintf(fidw,'  </Placemark>\n');
end
fprintf(fidw,'</Document>\n');
fprintf(fidw,'</kml>\n');


fclose(fidw);
