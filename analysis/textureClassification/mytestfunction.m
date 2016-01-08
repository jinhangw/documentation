% Load some image:

% display the image:
figure(88);
clf;
h = imagesc(aaa);
axis image

% Get a value from the screen:
[x, y] = ginput(1);

msgbox(['You want pixel: ' num2str(round([x,y]))]);