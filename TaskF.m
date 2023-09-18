clear all;
close all;
clc;

clear all; close all; clc;

% % Get Image

[imageFilename, imagePath] = uigetfile('*.jpg'); 
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

% Centroid calculation for each tag
% Get points from Red and Yellow tag binary images

[jPointsRed,iPointsRed] = find(red);
[jPointsYellow,iPointsYellow] = find(yellow);

% Get smallest x and y co-ordinates in Red tag
min_red_i = min(iPointsRed);
max_red_i = max(iPointsRed);

min_red_j = min(jPointsRed);
max_red_j = max(jPointsRed);

% Get smallest x and y co-ordinates in Yellow tag
min_yellow_i = min(iPointsYellow);
max_yellow_i = max(iPointsYellow);

min_yellow_j = min(jPointsYellow);
max_yellow_j = max(jPointsYellow);

% Centroid calculation  
% max and min difference gives number pixels in between
% adding the difference to the min gives exact position
centroid_red_i = min_red_i + ((max_red_i - min_red_i)/2);
centroid_red_j = min_red_j + ((max_red_j - min_red_j)/2);

centroid_yellow_i = min_yellow_i + ((max_yellow_i - min_yellow_i)/2);
centroid_yellow_j = min_yellow_j + ((max_yellow_j - min_yellow_j)/2);

dCityBlock  = abs(centroid_red_i-centroid_yellow_i)+abs(centroid_red_j-centroid_yellow_j);
dChessboard = max(abs(centroid_red_i-centroid_yellow_i),abs(centroid_red_j-centroid_yellow_j));
dEuclidean  = sqrt((centroid_red_i-centroid_yellow_i)^2+(centroid_red_j-centroid_yellow_j).^2);

disp(['City Block Distance  : ' num2str(dCityBlock)]); 
disp(['Chessboard Distanace : ' num2str(dChessboard)]); 
disp(['Euclidean Distance   : ' num2str(dEuclidean)]); 

pause(0.3);
imshow(finalBorderedImage);

hold on;
plot(centroid_red_i ,centroid_red_j,'bo', 'Linewidth', 2);
plot(centroid_yellow_i,centroid_yellow_j,'bo','LineWidth',2);

% Add distance labels with distance 

% Cityblock distance
plot([centroid_yellow_i,centroid_red_i],[centroid_yellow_j,centroid_yellow_j],'g-','Linewidth',2);
plot([centroid_red_i,centroid_red_i],[centroid_yellow_j,centroid_red_j],'g-','Linewidth',2);
% get vertical distance between red and yellow tags
vertical_chessboard_distance = abs(centroid_yellow_j - centroid_red_j);

% Eucleidian distance
plot([centroid_red_i,centroid_yellow_i],[centroid_red_j,centroid_yellow_j],'b-','Linewidth',2);

% Find Chessboard distances that need to be plotted

% line at 45 degrees from line connecting red and yellow tag 
line = tand(45);
% calculating the chessboard distance using the concept of Hypotenuse triangle with two 45 degrees and one 90 degree 
% using the vertical distance between tags find the co-ordinate of the
% missing point on the vertical cityblock line, the y co-ordinate is the
% same as yellow tag,we find the missing x co-ordinate
product = vertical_chessboard_distance .* line;
chessboard_coordinate_i = product + centroid_red_i;

% Plot Chessboard lines using value of co-ordinate obtained
plot([chessboard_coordinate_i,centroid_yellow_i],[centroid_yellow_j,centroid_yellow_j],'y-','Linewidth',2);
plot([chessboard_coordinate_i,centroid_red_i],[centroid_yellow_j,centroid_red_j],'y-','Linewidth',2);

