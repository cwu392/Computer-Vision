% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points
%x = ceil(rand(500,1) * size(image,2));
%y = ceil(rand(500,1) * size(image,1));

alpha=0.06;
gaussian=fspecial('Gaussian',[5,5],1);
[gx,gy]=imgradient(gaussian);

ix=imfilter(image,gx);
iy=imfilter(image,gy);


%%%%%%%%%%%%%%

large_gaussian=fspecial('Gaussian',[5,5], 2);
ixx=imfilter(ix.*ix,large_gaussian);
iyy=imfilter(iy.*iy,large_gaussian);
ixy=imfilter(ix.*iy,large_gaussian);

har=ixx.*iyy-ixy.*ixy-alpha.*(ixx+iyy).*(ixx+iyy);

thresholded=har > 0.1*mean2(har); %% UnKnown%%


har = har.*thresholded;
har_max = colfilt(har, [feature_width feature_width], 'sliding', @max);
har = har.*(har == har_max);

[y, x] = find(har > 0);
confidence = har(har > 0);

end


