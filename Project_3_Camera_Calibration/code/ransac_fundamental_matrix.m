% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
% # of points used to cal. F
s=8; %Choose 8 or 9 (from HW3 Website)
% Threshold
threshold=0.01; %Guess
% Probability at least one random sample is free from outlier
p=0.99;
% outlier ratio
e=0.6; %Guess

N=log(1-p)/log(1-(1-e)^s); %7024
%N=100;

No_Pairs=size(matches_a,1);

no_best_correct_match=0;
best_correct_match=[];
Best_Fmatrix=zeros(3,3);

for i=1:N
	%Randomly select 8 pairs from A and B
	sample=randperm(No_Pairs,8);
	tmp_Fmatrix = estimate_fundamental_matrix(matches_a(sample,:), matches_b(sample,:));

	correct_match=[];
	
	for j=1:No_Pairs
		cal_error=[matches_b(j,1),matches_b(j,2),1]*tmp_Fmatrix*[matches_a(j,1);matches_a(j,2);1];
		if abs(cal_error)<=threshold
			correct_match=[correct_match;j];
		end
	end

	if size(correct_match,1)>no_best_correct_match
		Best_Fmatrix=tmp_Fmatrix;
		best_correct_match=correct_match;
		no_best_correct_match=size(correct_match,1);
	end

end

inliers_a = matches_a(best_correct_match,:);
inliers_b = matches_b(best_correct_match,:);

end

