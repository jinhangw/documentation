function [features, sampled_patch] = extractFilterResponsesRandomSampling(im, filterBank, num_sample)
%     image = imread(im);
%     [h,w,c] = size(image);
%     num_pixel = h*w;
%     average_level = sum(sum(sum(image)))./(num_pixel * c);
%     pad_wid = 24;
%     pad_image = ones(h+2*pad_wid, w+2*pad_wid, c).*average_level;
%     h_start = pad_wid +1;
%     h_end = h + pad_wid;
%     w_start = pad_wid + 1;
%     w_end = w + pad_wid;
%     pad_image(h_start:h_end,w_start:w_end,:) = image;
%     R_channel = pad_image(:,:,1);
%     G_channel = pad_image(:,:,2);
%     B_channel = pad_image(:,:,3);
%     %test
%     [L,a,b] =RGB2Lab(R_channel, G_channel, B_channel);
% %     L = R_channel;
% %     a = G_channel;
% %     b = B_channel;
%     %test
%     %num_sample = 100;
%     features = zeros(num_sample,17);
% 
%     
%     if(num_sample > w || num_sample > h)
%         error('error: number of sample need to be smaller than w or h');
%     end
%     row_rand = randperm(h) + pad_wid;
%     col_rand = randperm(w) + pad_wid;

    
    
    
    
    
    

%   Detailed explanation goes here
    raw = imread(im);
    image = raw;
    [h,w,c] = size(image);
    num_pixel = h*w;
    average_level = sum(sum(sum(image)))./(num_pixel * c);
    
     pad_wid = 24;

    
    image = double(image);
    R_channel = image(:,:,1);
    G_channel = image(:,:,2);
    B_channel = image(:,:,3);
    %test
    [L,a,b] = RGB2Lab(R_channel, G_channel, B_channel);
    

    
    %test
    num_sample = 100;
    features = zeros(num_sample,9);

    
    row_rand = randperm(h-2*pad_wid) + pad_wid;
    col_rand = randperm(w-2*pad_wid) + pad_wid;
    
    
    
    
       
    

    
    sampled_patch = cell(num_sample,1);

    
    
    for i=1:num_sample
            col_ind = col_rand(i);
            row_ind = row_rand(i);

            index = i;
  
            for fb1 = 1:4
                filter_even = filterBank{1}{1,fb1};
                filter_odd = filterBank{1}{2,fb1};
                half_size_op_win = (size(filter_even,1)-1)/2;
                op_window_h = (row_ind - half_size_op_win):(row_ind + half_size_op_win);
                op_window_w = (col_ind - half_size_op_win):(col_ind + half_size_op_win);
                features(index, fb1) = sqrt(sum(sum(L(op_window_h,op_window_w).* filter_even))^2+...
                                            sum(sum(L(op_window_h,op_window_w).* filter_odd))^2);        
            end
            
            for fb2 = 1:3
                filter = filterBank{2}{1,fb2};
                half_size_op_win = (size(filter,1)-1)/2;
                op_window_h = (row_ind - half_size_op_win):(row_ind + half_size_op_win);
                op_window_w = (col_ind - half_size_op_win):(col_ind + half_size_op_win);
                features(index, 5+(fb2-1)*3 ) = sum(sum(L(op_window_h,op_window_w).* filter));
                features(index, 6+(fb2-1)*3 ) = sum(sum(a(op_window_h,op_window_w).* filter));
                features(index, 7+(fb2-1)*3 ) = sum(sum(b(op_window_h,op_window_w).* filter));
                
            end
            
            for fb3 = 1:4
                filter = filterBank{3}{1,fb3};
                half_size_op_win = (size(filter,1)-1)/2;
                op_window_h = (row_ind - half_size_op_win):(row_ind + half_size_op_win);
                op_window_w = (col_ind - half_size_op_win):(col_ind + half_size_op_win);
                features(index, 13+fb3) = sum(sum(L(op_window_h,op_window_w).* filter));     
            end
            
            
            sample_window_h = (row_ind - pad_wid):(row_ind + pad_wid);
            sample_window_w = (col_ind - pad_wid):(col_ind + pad_wid);
            sampled_patch{i} = raw(sample_window_h,sample_window_w,:);
        
    end
    
end