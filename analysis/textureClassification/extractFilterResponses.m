function [features] = extractFilterResponses(im, filterBank)
image = imread(im);
[h,w,c] = size(image);
num_pixel = h*w;

image = double(image);
R_channel = image(:,:,1);
G_channel = image(:,:,2);
B_channel = image(:,:,3);
[L,a,b] =RGB2Lab(R_channel, G_channel, B_channel);

features = zeros(num_pixel,17);


for fb1 = 1:4
    filter_even = filterBank{1}{1,fb1};
    filter_odd = filterBank{1}{2,fb1};
    responceEven = conv2(L, filter_even, 'same');
    responceOdd = conv2(L, filter_odd, 'same');
    responceTotal = sqrt(responceEven.^2 + responceOdd.^2);
    features(:,fb1) = reshape(responceTotal, num_pixel,1);
    
end

for fb2 = 1:3
    filter = filterBank{2}{1,fb2};
    responceL = conv2(L, filter, 'same');
    responceA = conv2(a, filter, 'same');
    responceB = conv2(b, filter, 'same');
    
    
    features(:, 5+(fb2-1)*3 ) = reshape(responceL, num_pixel,1);
    features(:, 6+(fb2-1)*3 ) = reshape(responceA, num_pixel,1);
    features(:, 7+(fb2-1)*3 ) = reshape(responceB, num_pixel,1);
    
end

for fb3 = 1:4
    filter = filterBank{3}{1,fb3};
    responce = conv2(L, filter, 'same');
    features(:,13+fb3) = reshape(responce, num_pixel,1);
    
    
end



end



