clear all;
close all;
clc;

clear all; close all; clc;

% % Get Image

[imageFilename, imagePath] = uigetfile('*.png'); 
RGB = imread([imagePath imageFilename]);    
imwrite(RGB,'assignment.png','bmp');


% Capture the red pixels
red = RGB(:,:,1) > 150 & RGB(:, :, 2) < 50 & RGB(:, :, 3) < 50;
% Capture the yellow pixels
yellow = RGB(:,:,1) >150  & RGB(:, :, 2) > 150 & RGB(:, :, 3) <55;

combinedBinary = yellow + red;

imshow(red);
imshow(yellow);
imshow(combinedBinary);
