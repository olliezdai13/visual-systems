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