imfinfo('peppers.png')
RGB = imread('peppers.png');  
%%
imshow(RGB)
I = rgb2gray(RGB);
figure
% imshow(I)
%%
imshowpair(RGB, I, 'montage')
title('Original colour image (left) grayscale image (right)');
%%
[R,G,B] = imsplit(RGB);
montage({R, G, B},'Size',[1 3])
title('Montage of R G B channels');
%%
HSV = rgb2hsv(RGB);
[H,S,V] = imsplit(HSV);
montage({H,S,V}, 'Size', [1 3])
title('Montage of H S V channels');
%%
XYZ = rgb2xyz(RGB);
[X,Y,Z] = imsplit(XYZ);
montage({X,Y,Z}, 'Size', [1 3])
title('Montage of X Y Z channels');