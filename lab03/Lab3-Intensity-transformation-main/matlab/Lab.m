%% Task 1
clear all
imfinfo('../assets/breastXray.tif');
f = imread('../assets/breastXray.tif');
imshow(f);
%%
f(3,10)             % print the intensity of pixel(3,10)
imshow(f(1:241,:));  % display only top half of the image
%%
[fmin, fmax] = bounds(f(:))
%%
imshow(f(:,241:482));
%%
g1 = imadjust(f, [0 1], [1 0]);
g2 = imadjust(f, [0 1], [1 0]);
figure              % open a new figure window
montage({f, g1, g2}, Size=[1,3])
%%
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})
%% Task 2
clear all       % clear all variables
close all       % close all figure windows
f = imread('../assets/bonescan-front.tif');
r = double(f);  % uint8 to double conversion
k = mean2(r);   % find mean intensity of image
E1 = 0.9;
E2 = 2;
s1 = 1 ./ (1.0 + (k ./ (r + eps)) .^ E1);
g1 = uint8(255*s1);
s2 = 1 ./ (1.0 + (k ./ (r + eps)) .^ E2);
g2 = uint8(255*s2);
% h1 = imhist(f);      % calculate and plot the histogram
% figure          % open a new figure window
% imhist(g1);      % calculate and plot the histogram
% imhist(g2);      % calculate and plot the histogram
% 
% montage({f, g1, g2})

% --- Visualization ---
figure('Name', 'Contrast Enhancement Analysis', 'Color', 'w');
t = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% Row 1: The Images
nexttile; imshow(f);  title('Original (f)');
nexttile; imshow(g1); title(['Enhanced E=', num2str(E1)]);
nexttile; imshow(g2); title(['Enhanced E=', num2str(E2)]);

% Row 2: The Histograms
nexttile; imhist(f);  grid on; title('Hist: Original');
nexttile; imhist(g1); grid on; title(['Hist: E=', num2str(E1)]);
nexttile; imhist(g2); grid on; title(['Hist: E=', num2str(E2)]);

% Link axes for the histograms to make comparison easier
linkaxes(findall(gcf, 'type', 'axes'), 'x');
%% Task 3
clear all       % clear all variable in workspace
close all       % close all figure windows
f=imread('../assets/pollen.tif');
imshow(f)
figure          % open a new figure window
imhist(f);      % calculate and plot the histogram
%%
close all
g=imadjust(f,[0.3 0.55]);
montage({f, g})     % display list of images side-by-side
figure
imhist(g);
%%
g_pdf = imhist(g) ./ numel(g);  % compute PDF
g_cdf = cumsum(g_pdf);          % compute CDF
close all                       % close all figure windows
subplot(1,3,1)
imshow(g);
subplot(1,3,2)                  % plot 1 in a 1x2 subplot
plot(g_pdf)
subplot(1,3,3)                  % plot 2 in a 1x2 subplot
plot(g_cdf)
%%
x = linspace(0, 1, 256);    % x has 256 values equally spaced
                            %  .... between 0 and 1
figure
plot(x, g_cdf)
axis([0 1 0 1])             % graph x and y range is 0 to 1
set(gca, 'xtick', 0:0.2:1)  % x tick marks are in steps of 0.2
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9)
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)
%%
h = histeq(g,256);              % histogram equalize g
close all
montage({f, g, h})
figure;
subplot(1,3,1); imhist(f);
subplot(1,3,2); imhist(g);
subplot(1,3,3); imhist(h);
%% Task 4
clear all
close all
f = imread('../assets/noisyPCB.jpg');
imshow(f)
%%
w_box = fspecial('average', [9 9])
w_gauss = fspecial('Gaussian', [7 7], 1.0)
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})
%%
w_box = fspecial('average', [2 2])
w_gauss = fspecial('Gaussian', [2 2], 1.0)
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})
%%
w_box = fspecial('average', [9 9])
w_gauss = fspecial('Gaussian', [7 7], 5.0)
g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})
%% Task 5
g_median = medfilt2(f, [7 7], 'zero');
figure; montage({f, g_median})
%% Task 6
f = imread('../assets/moon.tif');
f_median = medfilt2(f, [7 7], 'zero');
f_gauss = imfilter(f, fspecial('Gaussian', [7 7], 4));
figure; montage({f, f_median, f_gauss});
% blurs ain't it!
%%
f = imread('../assets/moon.tif');
f_lap = imfilter(f, fspecial('laplacian', 0.5));
f_unsharp = imfilter(f, fspecial('unsharp', 0.5));
f_sobel = imfilter(f, fspecial('sobel'));
figure; montage({f, f_lap, f_unsharp, f_sobel}, Size=[2,2]);
%% Task 7
close all                       % close all figure windows

f = imread('../assets/lake&tree.png');
h = imhist(f);
f2 = histeq(f,256);
h2 = imhist(f2);

subplot(2,2,1);
imshow(f);
subplot(2,2,2);
plot(h);
subplot(2,2,3);
imshow(f2);
subplot(2,2,4);
plot(h2);