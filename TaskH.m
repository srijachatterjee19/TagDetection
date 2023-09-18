

clear all; close all; clc;

% get the camera object
cam = webcam(1); 

% get a single snapshot from the camera to create a binary
% matrix consisting of zeros
snap = snapshot(cam);
M      = size(snap,1);
N      = size(snap,2);

% 
binaryMatrix = uint8(zeros([M,N]));
% Matrix to keep track of centroids using matrices
redTag = zeros(5,2);
yellowTag = zeros(5,2);

for i = 1 : 10
    % Acquire live RGB image using webcam     
    RGB = snapshot(cam);
    image(RGB);
    
    % Thresholding Red and Yellow tags     
    % Capture the yellow pixels
    yellow = RGB(:,:,1) > 177  & RGB(:, :, 2) > 165 & RGB(:, :, 3) < 109;
    % Capture the red pixels
    red = RGB(:,:,1) > 126 & RGB(:, :, 2) < 72 & RGB(:, :, 3) < 86;
                
    % Strels used for morpholofical operations
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
   
    % Combine binarised tags after morphological operations
    
    % Borders added around each tag using Range non-linear filter
    redBorder = rangefilt(red);
    yellowBorder = rangefilt(yellow);
    
    % Add tag borders to original RGB image
     redTagBorder = imoverlay(RGB,redBorder,'green');
     finalBorderedImage = imoverlay(redTagBorder,yellowBorder,'blue');

    % Centroid calculation for each tag
    
    % Get points from Red and Yellow tag binary images
    
    [jPointsRed,iPointsRed] = find(red);
    [jPointsYellow,iPointsYellow] = find(yellow);
    
    % Get smallest x and y co-ordinates in Red tag
    min_red_i = double(min(iPointsRed));
    max_red_i = double(max(iPointsRed));
    
    min_red_j = double(min(jPointsRed));
    max_red_j = double(max(jPointsRed));
    
    % Get smallest x and y co-ordinates in Yellow tag
    min_yellow_i = double(min(iPointsYellow));
    max_yellow_i = double(max(iPointsYellow));
    
    min_yellow_j = double(min(jPointsYellow));
    max_yellow_j = double(max(jPointsYellow));
    
    % Centroid calculation  
    % max and min difference gives number pixels in between
    % adding the difference to the min gives exact position
    centroid_red_i = min_red_i + ((max_red_i - min_red_i)/2);
    centroid_red_j = min_red_j + ((max_red_j - min_red_j)/2);
    
    centroid_yellow_i = min_yellow_i + ((max_yellow_i - min_yellow_i)/2);
    centroid_yellow_j = min_yellow_j + ((max_yellow_j - min_yellow_j)/2);
    
    imshow(finalBorderedImage);
    
    hold on;
    plot(centroid_red_i ,centroid_red_j,'bo', 'Linewidth', 2);
    plot(centroid_yellow_i,centroid_yellow_j,'bo','LineWidth',2);
    
    % Convert the centroid points to integer type to plot correctly     
    centroid_red_j= int64(centroid_red_j);
    centroid_red_i = int64(centroid_red_i);
    centroid_yellow_i = int64(centroid_yellow_i);
    centroid_yellow_j = int64(centroid_yellow_j);
  
     % The centroid points aquired from RGB frame set to a value "1"    
    binaryMatrix(centroid_red_j,centroid_red_i) = 1;
    binaryMatrix(centroid_yellow_j,centroid_yellow_i) = 1;
    
    % Add the x and y centroid co-ordinates that are set to 1 to an array
    % to keep track of points detected in previous frame
    [y, x] = find(binaryMatrix==1);
    
    redTag(i,1) = centroid_red_i;
    redTag(i,2) = centroid_red_j;
    yellowTag(i,1) = centroid_yellow_i;
    yellowTag(i,2) = centroid_yellow_j;

    imshow(finalBorderedImage);
    hold on;

    % Plot the centroids and distance between them on the current image frame     
    plot(x,y,'bo','Linewidth',2);

    % Plot the centroids and distance between them on the current image frame     
     
    % Plot the non-zero centroid points stored seperately for each tag
    % Plot the points in the current iteration 
     plot([nonzeros(redTag(i,1)),nonzeros(yellowTag(i,1))],[nonzeros(redTag(i,2)),nonzeros(yellowTag(i,2))],'g-','Linewidth',2);
    
     % Plot the points all the non-zero points  
     plot([nonzeros(redTag(:,1)),nonzeros(yellowTag(:,1))],[nonzeros(redTag(:,2)),nonzeros(yellowTag(:,2))],'b-','Linewidth',2);

    drawnow;
    % wait before acquiring next frame
    pause(20);
     
end

% stop plotting
hold off;
% Display final drawing
finalDrawing = snapshot(cam);




