% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature vector should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

%Placeholder that you can delete. Empty features.
%features = zeros(size(x,1), 128);
num_points=size(x,1);
features = zeros(size(x,1), 128);
small_gaussian=fspecial('Gaussian',[feature_width feature_width],1);
large_gaussian=fspecial('Gaussian',[feature_width feature_width],feature_width/2); %(16x16)


[gx,gy]=imgradientxy(small_gaussian);
ix=imfilter(image,gx);
iy=imfilter(image,gy);

get_octant=@(x,y)(ceil(atan2(y,x)/(pi/4))+4);

orients=arrayfun(get_octant,ix,iy);
mag=hypot(ix,iy); %Root Mean Square% % 600x800
%mesh(mag) 
c_size=feature_width/4;


for ix =1:num_points
	if round(x(ix)-2*c_size)<1 %X:1:800
		frame_x_range=1:4*c_size;
	elseif round(x(ix)+2*c_size-1)>800
		frame_x_range=800-4*c_size:799;
	else
	 	frame_x_range=round(x(ix)-2*c_size):round(x(ix)+2*c_size-1);
	end

	if round(y(ix)-2*c_size)<1 %Y:1:600
		frame_y_range=1:4*c_size;
	elseif round(y(ix)+2*c_size-1)>600
		frame_y_range=600-4*c_size:599;
	else
	 	frame_y_range=round(y(ix)-2*c_size):round(y(ix)+2*c_size-1);
	end
	%max(max(frame_y_range)) %600
	%max(max(frame_x_range))
	%size(frame_y_range)
	%round(frame_x_range)
	%round(frame_y_range)
	%size(mag)
	frame_mag=mag(fix(frame_y_range),fix(frame_x_range));
	% size(frame_mag)
	% % % %size(frame_mag)
	% % % %size(small_gaussian)
	% % % %size(large_gaussian)
	frame_mag=frame_mag.*large_gaussian;
	frame_orients=orients(frame_y_range,frame_x_range);
	for a=0:3
		for b=0:3
			cell_orients=frame_orients(a*4+1:a*4+4,b*4+1:b*4+4);
			cell_mag=frame_mag(a*4+1:a*4+4,b*4+1:b*4+4);
			%size(cell_mag) %(4,4)
			%size(cell_orients) %(4,4)
			for c=1:8
				f = cell_orients == c;
				features(ix,a*32+b*8+c)=sum(sum(cell_mag(f)));
			
		end
	end
end

%features = diag(1./sum(features,2))*features; %Normalize feature vectors
features = (features./sum(features,2)); %Normalize feature vectors
end








