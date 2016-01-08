function [ features ] = extractMRFilterResponses( im, MRFilter )

    filterSize = size(MRFilter{1}{1,1},1);


    image = imread(im);
    [h,w,c] = size(image);
    num_pixel = h*w;
    %average_level = sum(sum(sum(image)))./(num_pixel * c);
    
%     pad_wid = 24;
%     pad_image = ones(h+2*pad_wid, w+2*pad_wid, c).*average_level;
%     h_start = pad_wid +1;
%     h_end = h + pad_wid;
%     w_start = pad_wid + 1;
%     w_end = w + pad_wid;
%     pad_image(h_start:h_end,w_start:w_end,:) = image;

    image = double(image);
    R_channel = image(:,:,1);
    G_channel = image(:,:,2);
    B_channel = image(:,:,3);

    [L,a,b] =RGB2Lab(R_channel, G_channel, B_channel);
    [hue,satuation,value] = rgb2hsv(image);
    satuationMask = ones(filterSize,filterSize)./(filterSize*filterSize);
    
    
    num_sample = w*h;
    features = zeros(num_sample,9);

    


    
    
    for i = 1:6
        responceTemp = zeros(h,w,6);
        for j =1:6
            responceTemp(:,:,j) = conv2(L, MRFilter{1}{i,j}, 'same');
        end
        maxResponce = max(responceTemp,[],3);
        features(:,i) = reshape(maxResponce, num_sample,1);
    end
    
    
    for i = 1:2
        features(:,6+i) = reshape(conv2(L, MRFilter{2}{1,i},'same'),num_sample,1);
    end
    
    features(:,9) = reshape(conv2(satuation, satuationMask,'same'),num_sample,1);

    
    
%     for col_ind = w_start:w_end
%         for row_ind = h_start:h_end
%             
%             index = sub2ind([h,w],row_ind-pad_wid, col_ind-pad_wid);
%             
%             
%             
%             for i = 1:6
%                 featTemp = zeros(1,6);
%                 for j =1:6
%                     filter = MRFilter{1}{i,j};
%                     half_size_op_win = (size(filter,1)-1)/2;
%                     op_window_h = (row_ind - half_size_op_win):(row_ind + half_size_op_win);
%                     op_window_w = (col_ind - half_size_op_win):(col_ind + half_size_op_win);
%                     featTemp(1,j) = sum(sum(L(op_window_h,op_window_w).* filter));
%                 end
%                 features(index,i) = max(featTemp);
%             end
%             
%             for i = 1:2
%                 
%                 filter = MRFilter{2}{1,i};
%                 half_size_op_win = (size(filter,1)-1)/2;
%                 op_window_h = (row_ind - half_size_op_win):(row_ind + half_size_op_win);
%                 op_window_w = (col_ind - half_size_op_win):(col_ind + half_size_op_win);
%                 features(index,i+6) = sum(sum(L(op_window_h,op_window_w).* filter));
%                 
%             end
%             
%             
%         end    
%     end


end

