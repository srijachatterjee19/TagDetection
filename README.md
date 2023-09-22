# TagDetection 🔖

This project was a part of MOD002643 Image Processing. The assignment was broken into several tasks and final task involved using a web-cam to capture a drawing made on screen when the two tags were moved. A red and a yellow tag were used for this assignment. 

## Thresholding 

This [task](TagDetection/TaskC.m) involved thresholding values specific a static image taken of the tags. `imtool` was used to manually collect the RGB values for the tags. For the Red tag the lowest Red value and values above were used and values lower the than the highest Green and Blue values were used. Similarly, for the yellow tag, the values above the lowest values were used for Red and Green and values lower than the lowest Red values. To put it simply, 

Red tag: R > lowest; Green >lowest; Blue < highest

Yellow tag: R> lowest; Green < highest; Blue < highest

Doing the same achieved good results each time.


## Morphological operator

Morphological operators like dilation and closing were used twice to cover the text and hole on the tag successfully for [task D](TagDetection/TaskD.m). The gradient added to the final output(after closing and dilation) got rid of the rough edges and the output is much neater.


## Annotate Tag boundaries

Non-Linear range filter was successfully applied to the RGB input image and the output is what was desired as shown in [task E](TagDetection/TaskE.m) .This traced the boundary of the tags and overlayed over the original image.


## Centroids and distances

The centroids of the tags were calculated by using the max and min functions for the red/yellow tag co-ordinates and adding the difference to the `min` gives exact position. City Block Distance,Chessboard Distanace and Euclidean Distances were calculated and displayed in [task F](TagDetection/TaskF.m).Lastly, Thresholding values were altered for this task and was picked up well. The task was tested in two rooms to show the effectiveness of the thresholding, and both performed well, the distances were displayed in real-time for [task G](TagDetection/TaskG.m). For drawind using the two tags([task H](TagDetection/TaskH.m)) Matrices composed of zeros were used to store the centroids of the tags separately and all points plotted each time in the loop.Lines in green indicates the current instance of drawing being made in the loop, the blue lines are picked up from the previous frames.

