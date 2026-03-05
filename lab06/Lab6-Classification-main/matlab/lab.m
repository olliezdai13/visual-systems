% Task 1
clear all; 
close all;
f = imread('../assets/cafe_van_gogh.jpg');
s1 = f(1:2:end,1:2:end,:);
s2 = s1(1:2:end,1:2:end,:);
s3 = s2(1:2:end,1:2:end,:);
s4 = s3(1:2:end,1:2:end,:);
s5 = s4(1:2:end,1:2:end,:);
figure(1)
montage({f, s1, s2, s3, s4, s5});

a1 = imresize(f, 0.5);
a2 = imresize(a1, 0.5);
a3 = imresize(a2, 0.5);
a4 = imresize(a3, 0.5);
a5 = imresize(a4, 0.5);
figure(2)
montage({f, a1, a2, a3, a4, a5});

%% Task 2
% Template 1
clear all; close all;
f = imread('../assets/salvador_grayscale.tif');
w = imread('../assets/template1.tif');
c = normxcorr2(w, f);
figure(1)
surf(c)
shading interp

[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(w,1);
xoffSet = xpeak-size(w,2);
figure(2)
imshow(f)
drawrectangle(gca,'Position', ...
    [xoffSet,yoffSet,size(w,2),size(w,1)], 'FaceAlpha',0);

% Template 2
w2 = imread('../assets/template2.tif');
c = normxcorr2(w2, f);
figure(3)
surf(c)
shading interp

[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(w2,1);
xoffSet = xpeak-size(w2,2);
figure(4)
imshow(f)
drawrectangle(gca,'Position', ...
    [xoffSet,yoffSet,size(w2,2),size(w2,1)], 'FaceAlpha',0);

%% Task 3
clear all; close all;
I = imread('../assets/salvador.tif');
f = im2gray(I);
points = detectSIFTFeatures(f);
figure(1); imshow(I);
hold on;
plot(points.selectStrongest(100));

%% Task 4
clear all; close all;
I1 = imread('../assets/cafe_van_gogh.jpg');
I2 = imrotate(imresize(I1, 0.5), 20);
f1 = im2gray(I1);
f2 = im2gray(I2);
points1 = detectSIFTFeatures(f1);
points2 = detectSIFTFeatures(f2);
Nbest = 100;
bestFeatures1 = points1.selectStrongest(Nbest);
bestFeatures2 = points2.selectStrongest(Nbest);
figure(1); imshow(I1);
hold on;
plot(bestFeatures1);
hold off;
figure(2); imshow(I2);
hold on;
plot(bestFeatures2);
hold off;

% Task 4 Pt. 2

[features1, valid_points1] = extractFeatures(f1, bestFeatures1);
[features2, valid_points2] = extractFeatures(f2, points2);

 indexPairs = matchFeatures(features1, features2, 'Unique', true);

 matchedPoints1 = valid_points1(indexPairs(:,1),:);
 matchedPoints2 = valid_points2(indexPairs(:,2),:);
 figure(3);
 showMatchedFeatures(f1,f2,matchedPoints1,matchedPoints2);

%% Task 5

clear all;
close all;

I1 = imread('../assets/traffic_1.jpg');
I2 = imread('../assets/traffic_2.jpg');
gray1 = rgb2gray(I1);
gray2 = rgb2gray(I2);

% SIFT
points1_sift = detectSIFTFeatures(gray1);
points2_sift = detectSIFTFeatures(gray2);
Nbest = 200;
bestFeatures1 = points1_sift.selectStrongest(Nbest);
bestFeatures2 = points2_sift.selectStrongest(Nbest);
[features1_sift, validPoints1_sift] = extractFeatures(gray1, bestFeatures1);
[features2_sift, validPoints2_sift] = extractFeatures(gray2, points2_sift);
indexPairs_sift = matchFeatures(features1_sift, features2_sift);
matchedPoints1_sift = validPoints1_sift(indexPairs_sift(:, 1));
matchedPoints2_sift = validPoints2_sift(indexPairs_sift(:, 2));

% SIFT results
figure;
showMatchedFeatures(I1, I2, matchedPoints1_sift, matchedPoints2_sift);
title('SIFT Feature Matching');

% SURF
points1_surf = detectSURFFeatures(gray1);
points2_surf = detectSURFFeatures(gray2);
[features1_surf, validPoints1_surf] = extractFeatures(gray1, points1_surf);
[features2_surf, validPoints2_surf] = extractFeatures(gray2, points2_surf);
indexPairs_surf = matchFeatures(features1_surf, features2_surf);
matchedPoints1_surf = validPoints1_surf(indexPairs_surf(:, 1));
matchedPoints2_surf = validPoints2_surf(indexPairs_surf(:, 2));

% SURF results
figure;
showMatchedFeatures(I1, I2, matchedPoints1_surf, matchedPoints2_surf);
title('SURF Feature Matching');

%% Task 6

camera = webcam;                            % create camera object for webcam
net = googlenet;                               % change this for other networks
inputSize = net.Layers(1).InputSize(1:2);   % find neural network input size
figure 
I = snapshot(camera);      
image(I);
f = imresize(I, inputSize);                 % resize image to match network
tic;                                        % mark start time
[label, score] = classify(net,f);           % classify f with neural network net
toc                                         % report elapsed time
title({char(label), num2str(max(score),2)}); % label object