

function [dates, seconds] = str2datenum(date_string, offset)

year     =  str2num(date_string(:,1:4));
month    =  str2num(date_string(:,5:6));
day      =  str2num(date_string(:,7:8));
hour     =  str2num(date_string(:,10:11));
minute   =  str2num(date_string(:,12:13));
second   =  str2num(date_string(:,14:15));
msec     =  str2num(date_string(:,17:19));

dates = datenum(year,month,day,hour,minute,second);
% no offset:
if (offset == -1)
    seconds = dates*86400 + msec/1000.0;
% offset = first time:
elseif (offset == 0)
    seconds = (dates-dates(1))*86400 + msec/1000.0;
% user defined offset:
else
    seconds = (dates-offset)*86400 + msec/1000.0;
end