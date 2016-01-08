
do_blur_rejection = 0;

for i=ni1:-1:4 %first couple of images are ususally black or ill-exposed
    if (~isnan(IMlat(i)) && ~isnan(IMlat(i-1))) % GPS needs to be a real number!
        % we discretize the longitude and latitude by 1/10000 degree, about
        % 10 m
        na = floor((IMlat(i)-lat0)*10000/min_dist);
        no = floor((IMlon(i)-lon0)*10000/min_dist);
        if (na > 0 && na <= size_sparse && no > 0 && no <= size_sparse)
            if (last_date(na,no) < IMdates(i))
                
                if (do_blur_rejection == 1)
                    % reject blurred images. This takes some time.
                    im_name = [main_dir,'/',run_name,'/', image_list(i).name];
                    imb = imread(im_name);
                    %    imbb=imb(end/2:end,:,1);
                    
                    % to speed things up only use the lower center area of
                    % the image:
                    imbb=imb(end/2:end*3/4,end/3:end*2/3,1);
                    % the fast version looks only at the horizontal blur
                    blur = blurMetric_fast(imbb);
                    
                    if(blur < 0.35)
                        last_date(na,no) = IMdates(i);
                    end
                else
                    last_date(na,no) = IMdates(i);
                end
            end
        end
    end
end

