

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  check if weather data is there
file = [run_name,'-weather_short.txt'];
filename = [ dirdir ,'/', file];

fprintf(1,'%d %s:  ', k, run_name);

if (~exist(filename,'file'))
    fprintf(1,'Warning: no %s\n', filename);
    S = 'none';
else
    fid = fopen(filename);
    S = fscanf(fid,'%s');
    fclose(fid);
end


for i=4:ni1 %first couple of images are ususally black or ill-exposed
%for i=ni1-30:ni1 %first couple of images are ususally black or ill-exposed
    
    if (~isnan(IMlat(i)) && ~isnan(IMlat(i-1))) % GPS needs to be a real number!
        
        dlat = (IMlat(i)-lat0)*10000/min_dist;
        dlon = (IMlon(i)-lon0)*10000/min_dist;
        na = floor(dlat);
        no = floor(dlon);
        
        ddlat = dlat - prev_dlat;
        ddlon = dlon - prev_dlon;
        del = sqrt(ddlat*ddlat + ddlon*ddlon);
        
        % downsample: only use image when it is the latest one
        % and make sure that the new image is more than 0.3*discretization
        % away from the previous image
        
        take_image = 0;
        if (exist('last_date','var'))
            if (na > 0 && na <= size_sparse && no > 0 && no <= size_sparse)
                if (last_date(na,no) == IMdates(i) && del > 0.3)
                    take_image = 1;
                end
            end
        else
            if (del > 1.0)
                 take_image = 1;
            end
        end
        
        if (take_image==1)
            % get the angle for the arrow icon
            prev_dlat = dlat;
            prev_dlon = dlon;
            
            del_east  = IMlon(i) - IMlon(i-1);
            del_north = IMlat(i) - IMlat(i-1);
            ang = atan2(del_east,del_north)/pi*180 + 22.5;
            ang1 = atan2(del_east,del_north)/pi*180;
            ang2 = 10*round(ang1/10);
            if (ang2 < 0)
                ang2 = ang2+360;
            end
            
            fprintf(fidw,'  <Placemark>\n');
            %fprintf(fidw,'    <name>Simple placemark</name>\n');
            
            % the normal placemark is an arrow in the direction of travel
            fprintf(fidw,'      <Style id="normalPlacemark">\n');
            fprintf(fidw,'        <IconStyle>\n');
            fprintf(fidw,'          <scale>0.5</scale>\n');
            fprintf(fidw,'          <Icon>\n');
            
            name = ['arrows/arrow_',num2str(ang2),'_',c_name,'.png'];
            fprintf(fidw,'            <href>%s</href>\n',name);
            
            %             % choose the arrow icon
            %             if ang < -135
%                 fprintf(fidw,'            <href>direction_down.png</href>\n');
%             elseif  ang < -90
%                 fprintf(fidw,'            <href>direction_downleft.png</href>\n');
%             elseif  ang < -45
%                 fprintf(fidw,'            <href>direction_left.png</href>\n');
%             elseif  ang < 0
%                 fprintf(fidw,'            <href>direction_upleft.png</href>\n');
%             elseif  ang < 45
%                 fprintf(1,'up  ang2 = %d\n',ang2);
%                 fprintf(fidw,'            <href>direction_up.png</href>\n');
%             elseif  ang < 90
%                 fprintf(fidw,'            <href>direction_upright.png</href>\n');
%             elseif  ang < 135
%                 fprintf(fidw,'            <href>direction_right.png</href>\n');
%             elseif  ang < 180
%                 fprintf(fidw,'            <href>direction_downright.png</href>\n');
%             else
%                 fprintf(fidw,'            <href>direction_down.png</href>\n');
%             end
            
           fprintf(fidw,'          </Icon>\n');
           fprintf(fidw,'        </IconStyle>\n');
           fprintf(fidw,'      </Style>\n');
            
            
            %    fprintf(fidw,'      <styleUrl>#normalPlacemark</styleUrl>\n');
            
            fprintf(fidw,'    <description> <![CDATA[\n');
            
            if (IMax(i) > -8.0) % test gravitational vector
                fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%s/%s">\n',dirdir,image_list(i).name);
            else % use the flipped images
                fprintf(fidw,'        <img style="width: 600px; height: 400px;"  src="%sflip/%s">\n',dirdir,image_list(i).name);
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
            
            light_of_day = 0;
            if (isDay)
                light_of_day = 1;
            elseif (isDawnDusk)
                light_of_day = 2;
            elseif (isNight)
                light_of_day = 3;
            end
            fprintf(fid_txt,'%s %4d %.8f %.8f %d %s\n', run_name,i, IMlon(i),IMlat(i), light_of_day, S);
        end
    end
end

