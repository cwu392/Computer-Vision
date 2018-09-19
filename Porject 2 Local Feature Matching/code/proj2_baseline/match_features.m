% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the interest points as additional features.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
threshold=1.0; %Filter Nothing
num_features = min(size(features1, 1), size(features2,1));

dist_matrix=pdist2(features1,features2);
[sorted_dist_matrix,indices]=sort(dist_matrix,2);
inverse_confidences=(sorted_dist_matrix(:,1)./sorted_dist_matrix(:,2));

confidences=1./inverse_confidences(inverse_confidences<threshold)

matches = zeros(size(confidences,1), 2);
matches(:,1)=find(inverse_confidences<threshold)
matches(:,2)=indices(inverse_confidences<threshold,1)

[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);
matches = matches(1:100,:); %Cofidence Sorting