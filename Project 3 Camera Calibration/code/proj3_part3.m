% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% This script 
% (1) Loads and resizes images
% (2) Calls VLFeat's SIFT matching functions
% (3) Estimates the fundamental matrix using RANSAC 
%     and filters away spurious matches (you code this)
% (4) Draws the epipolar lines on images and corresponding matches

clear
close all

% This Mount Rushmore pair is easy. Most of the initial matches are
% correct. The base fundamental matrix estimation without coordinate
% normalization will work fine with RANSAC.
%pic_a = imread('../data/Mount Rushmore/9193029855_2c85a50e91_o.jpg');
%pic_b = imread('../data/Mount Rushmore/7433804322_06c5620f13_o.jpg');
%pic_a = imresize(pic_a, 0.25, 'bilinear');
%pic_b = imresize(pic_b, 0.37, 'bilinear');

% % The Notre Dame pair is difficult because the keypoints are largely on the
% % same plane. Still, even an inaccurate fundamental matrix can do a pretty
% % good job of filtering spurious matches.
% pic_a = imread('../data/Notre Dame/921919841_a30df938f2_o.jpg');
% pic_b = imread('../data/Notre Dame/4191453057_c86028ce1f_o.jpg');
% pic_a = imresize(pic_a, 0.5, 'bilinear');
% pic_b = imresize(pic_b, 0.5, 'bilinear');

% % The Gaudi pair doesn't find many correct matches unless you run at high
% % resolution, but that will lead to tens of thousands of sift features
% % which will be somewhat slow to process. Normalizing the coordinates
% % (extra credit) seems to make this pair work much better.
 pic_a = imread('../data/Episcopal Gaudi/3743214471_1b5bbfda98_o.jpg');
 pic_b = imread('../data/Episcopal Gaudi/4386465943_8cf9776378_o.jpg');
 pic_a = imresize(pic_a, 0.8, 'bilinear');
 pic_b = imresize(pic_b, 1, 'bilinear');

% % This pair of photos has a clearer relationship between the cameras (they
% % are converging and have a wide baseine between them) so the estimated
% % fundamental matrix is less ambiguous and you should get epipolar lines
% % qualitatively similar to part 2 of the project.
% pic_a = imread('../data/Woodruff Dorm/wood1.jpg');
% pic_b = imread('../data/Woodruff Dorm/wood2.jpg');
% pic_a = imresize(pic_a, 0.65, 'bilinear');
% pic_b = imresize(pic_b, 0.65, 'bilinear');

% Finds matching points in the two images using VLFeat's implementation of
% SIFT (basically project 2). There can still be many spurious matches,
% though.
[Points_2D_pic_a, Points_2D_pic_b] = sift_wrapper( pic_a, pic_b );
fprintf('Found %d possibly matching features\n',size(Points_2D_pic_a,1));
show_correspondence2(pic_a, pic_b, Points_2D_pic_a(:,1), Points_2D_pic_a(:,2), Points_2D_pic_b(:,1),Points_2D_pic_b(:,2));

%% Calculate the fundamental matrix using RANSAC
% !!! You will need to implement ransac_fundamental_matrix. !!!
[F_matrix, matched_points_a, matched_points_b] = ransac_fundamental_matrix(Points_2D_pic_a, Points_2D_pic_b);

%% Draw the epipolar lines on the images and corresponding matches
show_correspondence2(pic_a, pic_b, matched_points_a(:,1), matched_points_a(:,2), matched_points_b(:,1),matched_points_b(:,2));

draw_epipolar_lines(F_matrix, pic_a, pic_b, matched_points_a, matched_points_b);

% %optional - re estimate the fundamental matrix using ALL the inliers.
% [ F_matrix ] = estimate_fundamental_matrix_james(matched_points_a, matched_points_b);
% draw_epipolar_lines(F_matrix, pic_a, pic_b, matched_points_a, matched_points_b);
