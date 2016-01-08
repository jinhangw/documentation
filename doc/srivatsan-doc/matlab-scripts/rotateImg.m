function [outputImg] = rotateImg(inputImg,phi,fc)

		%Rotates image about X axis through the given angle.
    [height,width,~] = size(inputImg);
    
    pcx = width/2;pcy = height/2;
		
		%rotation about x-axis
		
		R_phi = [1          0           0 ; ...
		0          cos(phi)  -sin(phi); ...
		0          sin(phi)  cos(phi)];
	
    K  = [fc         0          pcx;...
          0          fc         pcy;...
          0          0          1];
    
  	H1 = K*R_phi/(K);
    H1 = H1./H1(3,3); 
   
		h1 = 0.8*height;%height at which we want to preserve resolution;

		p1 = [1;h1;1];p2 = [width;h1;1];
    p1_ = H1*p1;p2_ = H1*p2;
    p1_ = p1_(1:2)./p1_(3);p2_ = p2_(1:2)./p2_(3);
    d = sqrt((p1_-p2_)'*(p1_-p2_));
    s = width/d;
   	%scaling matrix to adjust output image resolution
		S = [s 0 0; 0 s 0; 0 0 1]; 
		
	  h2 = 0.7*height;%height from which we want to include in the projection
 

    C = [1,h2;width,h2;1,height;width,height]';
    C_ = S*H1*[C;ones(1,4)];C_ = [C_(1,:)./C_(3,:);C_(2,:)./C_(3,:)];
    
    min_x = min(C_(1,:));min_y = min(C_(2,:));

    T = eye(3) + [zeros(3,2) [1-min_x;1-min_y;0]];
    
    H_final = T*S*H1;
    
    C_ = H_final*[C;ones(1,4)];C_ = [C_(1,:)./C_(3,:);C_(2,:)./C_(3,:)];
    max_x = max(C_(1,:));max_y = max(C_(2,:));
    
    if(numel(size(inputImg))>2)
        out_size = ceil([max_y,max_x]);
    else
        out_size = ceil([max_y,max_x]);
    end
    
    outputImg = warpH(inputImg,H_final,out_size,0);
    
end
