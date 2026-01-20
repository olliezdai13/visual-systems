%%
clear; clc;
load('./matlab/clown.mat');
% clown  (20,319)
%%
% imshow (clown)
%%
    function [Out] = Rotate(In, Theta)
    [rows, cols] = size(In);
    % 1. Define the Center of Rotation (middle of the image)
    cx = (cols + 1) / 2;
    cy = (rows + 1) / 2;

    % 2. Create the Destination Grid (meshgrid)
    % This represents every pixel coordinate in the output image
    [Xd, Yd] = meshgrid(1:cols, 1:rows);

    % 3. Flatten and Stack into Homogeneous Coordinates
    % Dimensions: 3 x N (where N is total pixels)
    dest_vectors = [Xd(:)'; Yd(:)'; ones(1, numel(Xd))];

    % 4. Construct the Transformation Matrix (Affine)
    % We need the Inverse Mapping: Dest -> Source
    % So we rotate by -Theta to find where the pixel came from.
    
    % Matrix components:
    % T1: Translate center to origin
    T1 = [1, 0, -cx; 
          0, 1, -cy; 
          0, 0, 1];
          
    % R: Rotation matrix
    R = [cos(Theta), sin(Theta), 0; 
        -sin(Theta), cos(Theta), 0; 
         0,          0,          1];
         
    % T2: Translate origin back to center
    T2 = [1, 0, cx; 
          0, 1, cy; 
          0, 0, 1];

    % Combined Matrix: M = T2 * R * T1
    M = T2 * R * T1;

    % 5. Perform the Matrix Multiplication (The core operation)
    % Calculates all source coordinates at once
    source_vectors = M * dest_vectors;

    % 6. Extract Source Coordinates
    Xs = reshape(source_vectors(1, :), rows, cols);
    Ys = reshape(source_vectors(2, :), rows, cols);

    % 7. Interpolate (Sample the data)
    % interp2(X, Y, V, Xq, Yq) interpolates V at query points Xq,Yq
    % 'linear' = Bilinear Interpolation
    % 0 = Fill background value for out-of-bounds pixels
    rotated_img = interp2(1:cols, 1:rows, In, Xs, Ys, 'linear', 0);

    Out = rotated_img;
    end

    %%
    % Rotate the clown image by a specified angle (in radians)
angle = pi/4; % Example angle of 45 degrees
rotatedClown = Rotate(clown, angle);

% Display the rotated image
imshow(rotatedClown);