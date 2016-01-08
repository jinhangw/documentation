
fidw = fopen(kml_file_name,'w');

fid_txt = fopen(txt_only_file_name,'w');


fprintf(fidw,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fidw,'<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(fidw,'<Document>\n');


prev_dlat = 0;
prev_dlon = 0;

