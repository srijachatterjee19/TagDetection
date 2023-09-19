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


% Strels used
strelDisk = strel('disk',7); 
strelLine = strel('line',6,3);
strelRect = strel("rectangle",[4,10]);

% % RED TAG % % 
% Perform dilations on binarised red tag
dilatedRed = imdilate(red,strelDisk);
dilatedRed = imdilate(dilatedRed,strelDisk);

% Closing operations on red tag
closeRed = imclose(dilatedRed,strelLine);
closeRed = imclose(closeRed,strelLine);

% Boundary around red tag traced
borderRed = imdilate(closeRed,strelLine) - imerode(closeRed,strelLine);

% Final output after performing morphological operations
red = dilatedRed + closeRed + borderRed;

% % YELLOW TAG % % 

% Perform dilation on binarised yellow tag
dilateYellow = imdilate(yellow,strelDisk);
dilateYellow = imdilate(dilateYellow,strelDisk);

% Closing operation on yellow tag
closeYellow = imclose(dilateYellow,strelLine);
closeYellow = imclose(closeYellow,strelLine);

% Boundary around yellow tag
borderYellow = imdilate(closeYellow,strelLine) - imerode(closeYellow,strelLine);

% Final output after performing morphological operations
yellow = dilateYellow + closeYellow + borderYellow;

% Borders added around each tag using Range non-linear filter
redBorder = rangefilt(red);
yellowBorder = rangefilt(yellow);

% Add tag borders to original RGB image
redTagBorder = imoverlay(RGB,redBorder,'green');
finalBorderedImage = imoverlay(redTagBorder,yellowBorder,'blue');
imshow(finalBorderedImage);
