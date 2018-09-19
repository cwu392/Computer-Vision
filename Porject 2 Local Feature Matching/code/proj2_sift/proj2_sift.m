% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% This script 
% (1) Loads and resizes images
% (2) Finds interest points in those images                 (you code this)
% (3) Describes each interest point with a local feature    (you code this)
% (4) Finds matching features                               (you code this)
% (5) Visualizes the matches
% (6) Evaluates the matches based on ground truth correspondences

close all

%% A) Load stuff
% There are numerous other image sets in the supplementary data on the
% project web page. You can simply download images off the Internet, as
% well. However, the evaluation function at the bottom of this script will
% only work for three particular image pairs (unless you add ground truth
% annotations for other image pairs). It is suggested that you only work
% with the two Notre Dame images until you are satisfied with your
% implementation and ready to test on additional images. A single scale
% pipeline works fine for these two images (and will give you full credit
% for this project), but you will need local features at multiple scales to
% handle harder cases.
clear all
tic
%img1 = imread('/home/chiamin/ComputerVision/proj2/data/Notre Dame/921919841_a30df938f2_o.jpg');
%img2 = imread('/home/chiamin/ComputerVision/proj2/data/Notre Dame/4191453057_c86028ce1f_o.jpg');
%eval_file = '/home/chiamin/ComputerVision/proj2/data/Notre Dame/921919841_a30df938f2_o_to_4191453057_c86028ce1f_o.mat';
% =====86%===== %
% %This pair is relatively easy (still harder than Notre Dame, though)
  img1 = imread('/home/chiamin/ComputerVision/proj2/data/Mount Rushmore/9021235130_7c2acd9554_o.jpg');
  img2 = imread('/home/chiamin/ComputerVision/proj2/data/Mount Rushmore/9318872612_a255c874fb_o.jpg');
 eval_file = '/home/chiamin/ComputerVision/proj2/data/Mount Rushmore/9021235130_7c2acd9554_o_to_9318872612_a255c874fb_o.mat';
% =====98%===== %
 %This pair is relatively difficult
%  img1 = imread('/home/chiamin/ComputerVision/proj2/data/Episcopal Gaudi/4386465943_8cf9776378_o.jpg');
%  img2 = imread('/home/chiamin/ComputerVision/proj2/data/Episcopal Gaudi/3743214471_1b5bbfda98_o.jpg');
%  eval_file = '/home/chiamin/ComputerVision/proj2/data/Episcopal Gaudi/4386465943_8cf9776378_o_to_3743214471_1b5bbfda98_o.mat';
% =====82%===== %
img1 = single(img1)/255;
img2 = single(img2)/255;

%make images smaller to speed up the algorithm. This parameter gets passed
%into the evaluation code so don't resize the images except by changing
%this parameter.

scale_factor = 0.5; 
img1 = imresize(img1, scale_factor, 'bilinear');
img2 = imresize(img2, scale_factor, 'bilinear');

%imwrite(image1, '/home/chiamin/ComputerVision/Reference/sift_anatomy_20141201/bin/image1.png');
%imwrite(image2, '/home/chiamin/ComputerVision/Reference/sift_anatomy_20141201/bin/image2.png');
% You don't have to work with grayscale images. Matching with color
% information might be helpful.

img1_bw = rgb2gray(img1);
img2_bw = rgb2gray(img2);
%% B) Find distinctive points in each image. Szeliski 4.1.1
% !!! You will need to implement get_interest_points. !!!
% % Use cheat_interest_points only for development and debugging!
%[x1f, y1f, x2f, y2f] = cheat_interest_points(eval_file, scale_factor);

%% C) Create feature vectors at each interest point. Szeliski 4.1.2
% !!! You will need to implement get_features. !!!
[des1,loc1] = get_points_features(img1_bw);
[des2,loc2] = get_points_features(img2_bw);

%% D) Match features. Szeliski 4.1.3
% !!! You will need to implement get_features. !!!
matched = match_features(des1,des2);

count_matched=count_matches(matched);

[x1,y1,x2,y2]=get_coordinates(loc1,loc2,matched);

%% E) Visualization
% You might want to set 'num_pts_to_visualize' and 'num_pts_to_evaluate' to
% some constant (e.g. 100) once you start detecting hundreds of interest
% points, otherwise things might get too cluttered. You could also
% threshold based on confidence.

% There are two visualization functions. You can comment out one of both of
% them if you prefer.
show_correspondence(img1, img2, x1,y1,x2,y2);
show_correspondence2(img1, img2, x1,y1,x2,y2);
%% 6) Evaluation
% This evaluation function will only work for the Notre Dame, Episcopal
% Gaudi, and Mount Rushmore image pairs. Comment out this function if you
% are not testing on those image pairs. Only those pairs have ground truth
% available. You can use collect_ground_truth_corr.m to build the ground
% truth for other image pairs if you want, but it's very tedious. It would
% be a great service to the class for future years, though!
evaluate_correspondence(img1, img2, eval_file, scale_factor, x1,y1,x2,y2);

toc