%% Task 1
clear all
close all
f = imread('../assets/crabpulsar.tif');
w = [-1 -1 -1;
     -1  8 -1;
     -1 -1 -1];
g1 = abs(imfilter(f, w));     % point detected
se = strel("disk",1);
g2 = imerode(g1, se);         % eroded
threshold = 100;
g3 = uint8((g2 >= threshold)*255); % thresholded
montage({f, g1, g2, g3});
%% Task 2
clear all
close all
f1 = imread('../assets/circuit_rotated.tif');
f2 = imread('../assets/brain_tumor.jpg');

e1_sobel = edge(f1, 'sobel');
e1_log   = edge(f1, 'log');
e1_canny = edge(f1, 'canny');

e2_sobel = edge(f2, 'sobel');
e2_log   = edge(f2, 'log');
e2_canny = edge(f2, 'canny');

thresh_sobel = 0.05;
thresh_log = 0.005;
thresh_canny = [0.1, 0.2];
e3_sobel = edge(f1, 'sobel', thresh_sobel);
e3_log   = edge(f1, 'log', thresh_log);
e3_canny = edge(f1, 'canny', thresh_canny);

e4_sobel = edge(f2, 'sobel', thresh_sobel);
e4_log   = edge(f2, 'log', thresh_log);
e4_canny = edge(f2, 'canny', thresh_canny);

montage({f1, e1_sobel, e1_log, e1_canny, f2, e2_sobel, e2_log, e2_canny, f1, e3_sobel, e3_log, e3_canny, f2, e4_sobel, e4_log, e4_canny}, Size=[4,4]);
%% Task 3

% Part 1
clear all;
close all;
f = imread('../assets/circuit_rotated.tif');
fEdge = edge(f,'Canny');
figure(1);
montage({f,fEdge})

% Part 2
[H, theta, rho] = hough(fEdge);
figure(2)
imshow(H,[],'XData',theta,'YData', rho, ...
            'InitialMagnification','fit');
xlabel('theta'), ylabel('rho');
axis on, axis normal, hold on;

% Part 3
figure(2)
peaks  = houghpeaks(H,10);
x = theta(peaks(:,2)); y = rho(peaks(:,1));
plot(x,y,'o','color','red', 'MarkerSize',10, 'LineWidth',1);

% Part 4
figure(3)
surf(theta, rho, H);
xlabel('theta','FontSize',16);
ylabel('rho','FontSize',16)
zlabel('Hough Transform counts','FontSize',16)

% Part 5
lines = houghlines(fEdge,theta,rho,peaks,'FillGap',5,'MinLength',7);
figure(4), imshow(f), 
figure(4); hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end

%% Task 4
clear all;
close all;
f = imread('../assets/yeast-cells.tif');
figure(1);
imshow(f);

% Otsu's Method
f = imcomplement(f);
level = graythresh(f);
BW = imbinarize(f, level);

figure(2);
montage({f, BW});

% NOTE: Used AI to code local standard deviation thresholding
f_double = double(f);

% 2. Define Parameters 
% (You will likely need to tune these for your specific image)
w = 100;      % Window size w x w (e.g., 15x15)
a = 0.2;    % Constant weight for standard deviation (can be positive or negative)
b = 1;     % Constant weight for the mean

% 3. Calculate Local Mean (m_xy)
% Create an averaging filter
h = fspecial('average', [w w]);
% Apply filter. 'replicate' handles boundary pixels smoothly
m_xy = imfilter(f_double, h, 'replicate');

% 4. Calculate Local Standard Deviation (sigma_xy)
% We can use the formula: Var(X) = E[X^2] - (E[X])^2
% First, compute the local mean of the squared image
m_x2y = imfilter(f_double.^2, h, 'replicate');
% Calculate standard deviation (using max(..., 0) to avoid imaginary numbers from floating-point errors)
sigma_xy = sqrt(max(m_x2y - m_xy.^2, 0)); 

% Note: If you have the Image Processing Toolbox, you can alternatively use:
% sigma_xy = stdfilt(f_double, ones(w, w));

% 5. Compute the Threshold Matrix (T_xy)
T_xy = a * sigma_xy + b * m_xy;

% 6. Apply the Threshold
% The pixel is set to white (1) if it is >= threshold, otherwise black (0)
binary_image = f_double >= T_xy;

% 7. Display Results
figure;
subplot(1, 2, 1);
imshow(f);
title('Original Image');

subplot(1, 2, 2);
imshow(binary_image);
title(['Local Threshold (w=', num2str(w), ', a=', num2str(a), ', b=', num2str(b), ')']);

%% Task 4 V2
% Using watershed transform

clear all;
close all;
f = imread('../assets/yeast-cells.tif');
figure(1);
imshow(f);

% Starting by binarizing the image
f = imcomplement(f);
level = graythresh(f);
BW = imbinarize(f, level);

figure(2);
montage({f, BW});

% Distance transform
D = -bwdist(BW);
Di = imhmin(D, 2);
figure(3);
imshow(D,[])
title('Distance Transform of Binary Image')
figure(4);
imshow(Di,[])
title('Distance Transform of Binary Image (imin)')

% Watershed
figure(5);
L = watershed(Di);
L(BW) = 0;

% Display results
rgb = label2rgb(L,'jet',[.5 .5 .5]);
imshow(rgb)
title('Watershed Transform')

%% Task 5

clear all; close all;
f = imread('../assets/baboon.png');    % read image
[M N S] = size(f);                  % find image size
F = reshape(f, [M*N S]);            % resize as 1D array of 3 colours
% Separate the three colour channels 
R = F(:,1); G = F(:,2); B = F(:,3);
C = double(F)/255;          % convert to double data type for plotting
figure(1)
scatter3(R, G, B, 1, C);    % scatter plot each pixel as colour dot
xlabel('RED', 'FontSize', 14);
ylabel('GREEN', 'FontSize', 14);
zlabel('BLUE', 'FontSize', 14);

% perform k-means clustering
k = 5;
[L,centers]=imsegkmeans(f,k);
% plot the means on the scatter plot
hold
scatter3(centers(:,1),centers(:,2),centers(:,3),100,'black','fill');

% display the segmented image along with the original
J = label2rgb(L,im2double(centers));
figure(2)
montage({f,J})

%% Task 6

% Watershed segmentation with Distance Transform
clear all; close all;
I = imread('../assets/dowels.tif');
f = im2bw(I, graythresh(I));
g = bwmorph(f, "close", 1);
g = bwmorph(g, "open", 1);
montage({I,g});
title('Original & binarized cleaned image')

% calculate the distance transform image
gc = imcomplement(g);
D = bwdist(gc);
figure(2)
imshow(D,[min(D(:)) max(D(:))])
title('Distance Transform')

% perform watershed on the complement of the distance transform image
L = watershed(imcomplement(D));
figure(3)
imshow(L, [0 max(L(:))])
title('Watershed Segemented Label')

% Merge everything to show segmentation
W = (L==0);
g2 = g | W;
figure(4)
montage({I, g, W, g2}, 'size', [2 2]);
title('Original Image - Binarized Image - Watershed regions - Merged dowels and segmented boundaries')