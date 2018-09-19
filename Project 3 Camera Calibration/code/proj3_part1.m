% Camera Calibration Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% This script 
% (1) Loads 2D and 3D data points
% (2) Calculates the projection matrix from those points    (you code this)
% (3) Computes the camera center from the projection matrix (you code this)

% Relationship between coordinates in the world and coordinates in the
% image defines the camera calibration. See Szeliski 6.2, 6.3 for reference

% 2 pairs of corresponding points files are provided
% Ground truth is provided for pts2d-norm-pic_a and pts3d-norm pair
% You need to report the values calculated from pts2d-pic_b and pts3d

clear
close all

formatSpec = '%f';
size2d_norm = [2 Inf];
size3d_norm = [3 Inf];

file_2d_norm_a = fopen('../data/pts2d-norm-pic_a.txt','r');
file_3d_norm   = fopen('../data/pts3d-norm.txt','r');
Points_2D = fscanf(file_2d_norm_a,formatSpec,size2d_norm)';
Points_3D = fscanf(file_3d_norm,formatSpec,size3d_norm)';

% % (Optional) Uncomment these four lines once you have your code working
% % with the easier, normalized points above.
% file_2d_pic_b = fopen('../data/pts2d-pic_b.txt','r');
% file_3d = fopen('../data/pts3d.txt','r');
% Points_2D = fscanf(file_2d_pic_b,formatSpec,size2d_norm)';
% Points_3D = fscanf(file_3d,formatSpec,size3d_norm)';


%% Calculate the projection matrix given corresponding 2D and 3D points
% !!! You will need to implement calculate_projection_matrix. !!!
M = calculate_projection_matrix(Points_2D,Points_3D);

disp('The projection matrix is:')
disp(M);

[Projected_2D_Pts, Residual] = evaluate_points( M, Points_2D, Points_3D);
fprintf('\nThe total residual is: <%.4f>\n\n',Residual);

visualize_points(Points_2D,Projected_2D_Pts);

%% Calculate the camera center using the M found from previous step
% !!! You will need to implement compute_camera_center. !!!
Center = compute_camera_center(M);

fprintf('The estimated location of camera is: <%.4f, %.4f, %.4f>\n',Center);
plot3dview(Points_3D, Center)






