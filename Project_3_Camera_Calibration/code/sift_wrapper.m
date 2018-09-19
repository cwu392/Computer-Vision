% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu and James Hays

% This is a wrapper for VLFeat's sift functions. It removes duplicate
% points which would otherwise cause problems for RANSAC (because you would
% be likely to sample duplicate points and therefore your linear system
% would not have enough independent rows).

% For reference: http://www.vlfeat.org/overview/sift.html  
% Potential useful functions: vl_sift() and vl_ubcmatch()
% It is recommend to use [0, 255] single precision gray scale image for
% vl_sift() input.

function [ Points_2D_pic_a, Points_2D_pic_b ] = sift_wrapper( pic_a, pic_b )


    pic_a = single(rgb2gray(pic_a));
    pic_b = single(rgb2gray(pic_b));

    % Calculate the SIFT features and matching
    [fleft,dleft]   = vl_sift(pic_a); 
    fprintf('found %d SIFT descriptors in pic a\n',size(fleft,2))
    [fright,dright] = vl_sift(pic_b);     
    fprintf('found %d SIFT descriptors in pic b\n',size(fright,2))
    
    matches = vl_ubcmatch(dleft, dright, 1.4);

    % Remove scale and orientation information for the matches points
    LeftMatches = fleft(1:2,matches(1,:))';
    RightMatches = fright(1:2,matches(2,:))';

    % Remove duplicate matching pairs
    CombineReduce = unique([LeftMatches RightMatches],'rows');
    Points_2D_pic_a = CombineReduce(:,1:2);
    Points_2D_pic_b = CombineReduce(:,3:4);

end

