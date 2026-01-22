
# Lab 1 - Introduction to Matlab (Oliver Dai Logbook)

**_Peter Cheung, V1.2 - 15 January 2026_**

In this lab you will write some simple programs using MATLAB to  manipulate some 2D image data (as two-dimensional array) with simple matrix operations.  You will perform the following two geometric transformations:
* Rotation
* Shearing

---
## Installing MATLAB

✅ Done

---
## Learning MATLAB Basics

✅ Watched a 15 minute tutorial. Feel good enough for now.

---
## Loading the test image

✅ Done

## Displaying Images

✅ Done

---
## Task 1 - Image Rotation

See `Lab1-Introduction-main/oliver_solutions/RotateMatrix.m`

I decided to go with an alternative approach to the pixel-by-pixel image rotation. It seemed inefficient, and I know computers are quite good at matrix multiplication. Would a rotation matrix work?

Not quite. 

A linear transformation "rotation" matrix like the one below rotates around the origin, which is the corner of the image (0,0).

    [cos(θ), 	sin(θ)]
    [-sin(θ), 	cos(θ)]
We can solve this by translating the image by half its width and height, so that the center of the image is on the origin. For this, we use an affine transformation for translation:

    [1, 	0, 		-width/2]
    [0, 	1, 		width/2]
    [0, 	0, 		1]
Then rotate the image using a compatible rotation matrix:

    [cos(θ), 	sin(θ), 	0]
    [-sin(θ), 	cos(θ), 	0]
    [0, 		0, 			1]

Before translating it back to the original coordinate system:

    [1, 	0, 		width/2]
    [0, 	1, 		-width/2]
    [0, 	0, 		1]
The transformation matrix is the composition of the three matrices.

Multiply the original image (stacked into a matrix with homogenous coordinates to make compatible with affine transformations) by the composite transformation matrix to get the resulting rotated image.


✅ Done

---
## Task 2 - Image Shearing


Same as the Image Rotation task, but use a shear matrix rather than rotation:

    [1, 	-x, 	0]
    [-y, 	1, 		0]
    [0,		0, 		1]

