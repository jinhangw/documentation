function SpatialPyramid = createSpatialPyramid(textonmap, NumClusters, L)
    [h,w,c] = size(textonmap);
    init_corners = [1 1 h w; 1 h w 1];
    corners ={};
    SpatialPyramid = {};
    bin = 0.5:1.0:(NumClusters+0.5);
    
    %SpatialPyramid{1} = histc(,bin);
    corners{1} ={};
    corners{1}{1} = init_corners;
    
    for i=2:(L+1)
        corners{i}={};
        SpatialPyramid{i} = {};
        for iter=1:size(corners{i-1},2)
            corners{i} =[corners{i},divideRectangleByTwo(corners{i-1}{1,iter})]; 
        end
    end
    
    for i=1:(L+1)
        for iter=1:size(corners{i},2)

            window_h_range = corners{i}{iter}(1,1):corners{i}{iter}(1,3);
            window_w_range = corners{i}{iter}(2,1):corners{i}{iter}(2,3);
            window_h = size(window_h_range,2);
            window_w = size(window_w_range,2);
            window = textonmap(window_h_range,window_w_range);
            SpatialPyramid{i}{iter} = histc(reshape(window,window_h*window_w,1),bin);
        end
    end
    
end


