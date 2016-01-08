

clear

%This script reads one run
% input:
%        main_dir  e.g. all_data
%        run_name  e.g. 20121002_163128_189


main_dir = 'all_data';
run_name = '20130614_123027_528';
%run_name = '20121002_163334_616';
% result: blur mean: 0.310   std: 0.025 

% main_dir = 'all_data_up/video-data';
% %run_name = '20130614_123027_528';
% run_name = '20130821_163211_464';
% % result:  mean:  0.3583 std: 0.0308

read_one_run

blur_all = ones(ni1,1);
tic
for i=4:ni1 %first couple of images are ususally black or ill-exposed
%for i=60:100 %first couple of images are ususally black or ill-exposed
    
    im_name = [main_dir,'/',run_name,'/', image_list(i).name];
    imb = imread(im_name);
%    imbb=imb(end/2:end,:,1);
    imbb=imb(end/2:end*3/4,end/3:end*2/3,1);
    blur = blurMetric_fast(imbb);
    
    fprintf(1,'image: %s blur: %.2f\n',im_name, blur);
    blur_all(i) = blur;
end

toc

figure(3)
plot(blur_all(5:end),'.')

fprintf(1,'blur mean: %.3f   std: %.3f \n', mean(blur_all(5:end)), std(blur_all(5:end)));

