% this script has test cases to help you test my_imfilter() which you will
% write. You should verify that you get reasonable output here before using
% your filtering to construct a hybrid image in proj1.m. The outputs are
% all saved and you can include them in your writeup. You can add calls to
% imfilter() if you want to check that my_imfilter() is doing something
% similar.
clear all
close all
tic;

%% Identify filter
%This filter should do nothing regardless of the padding method you use.
identity_filter = [0 0 0 0 0 ; 0 0 0 0 0; 0 0 1 0 0; 0 0 0 0 0; 0 0 0 0 0];


%% Small blur with a box filter
%This filter should remove some high frequencies
blur_filter = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1];

blur_filter = blur_filter / sum(sum(blur_filter))+0.5; %making the filter sum to 1


%% Large blur
%This blur would be slow to do directly, so we instead use the fact that
%Gaussian blurs are separable and blur sequentially in each direction.

% %equivalent operation:
% tic %tic and toc run a timer and then print the elapsted time
large_blur_filter = fspecial('Gaussian', [25 25], 10);
large_blur_filter=large_blur_filter/max(max(large_blur_filter));
%figure(1);
%imshow(large_blur_filter*325);
%imshow(large_blur_filter);
% large_blur_image = my_imfilter(test_image, large_blur_filter);
% toc 

%% Oriented filter (Sobel Operator)
sobel_filter = [-2 -1 0 1 2; -3 -2 0 2 3;-4 -3 0 3 4;-3 -2 0 2 3;-2 -1 0 1 2]; %should respond to horizontal gradients

sobel_filter=sobel_filter/max(max(sobel_filter));
sobel_filter=sobel_filter+1;

%% High pass filter (Discrete Laplacian)
%laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];
laplacian_filter=[4 1 0 1 4 ;1 -2 -3 -2 1; 0 -3 -4 -3 0; 1 -2 -3 -2 1;4 1 0 1 4];
laplacian_filter=laplacian_filter/max(max(laplacian_filter))+1;

%0.5 added because the output image is centered around zero otherwise and mostly black

%% High pass "filter" alternative

toc

subplot(1,6,1); imshow(identity_filter);
subplot(1,6,2); imshow(blur_filter);
subplot(1,6,3); imshow(large_blur_filter);
subplot(1,6,4); imshow(sobel_filter*0.5);
subplot(1,6,5); imshow(laplacian_filter*0.5);
subplot(1,6,6); imshow(1-blur_filter);
%by James Hays