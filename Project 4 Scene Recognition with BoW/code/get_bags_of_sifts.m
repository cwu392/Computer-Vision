% Starter code prepared by James Hays for Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.

Or:

For speed, you might want to play with a KD-tree algorithm (we found it
reduced computation time modestly.) vl_feat includes functions for building
and using KD-trees.
 http://www.vlfeat.org/matlab/vl_kdtreebuild.html

%}

load('vocab.mat'); % d(128) x vocab(200)
%vocab=single(vocab);
vocab_size = size(vocab, 2);
[m,~]=size(image_paths);
image_feats=zeros(m,vocab_size); %1500x200
for i=1:m %image path 1500
    img=imread(image_paths{i});
    [~, SIFT_features] = vl_dsift(single(img),'Fast','Step',5);
    %SIFT_features=single(SIFT_features); %128xM
    %D = vl_alldist2(SIFT_features,vocab'); % 128xM vs 128x200->D(M,200)
    %[x,y]=size(D);
    [indices, ~] = knnsearch(single(vocab), single(SIFT_features)', 'K', 1); % find closest point
    image_feats(i,:) = histc(indices, 1:vocab_size)'; %Count appearance
    image_feats(i,:)=image_feats(i,:)/sum(image_feats(i,:)); %normalize
    %D_features=zeros(x,1);
%    for j=1:x %Features 60000
%        min_feat=min(abs(D(j,:)));
%        for k=1:y %vocab=200
%            if D(j,k)==min_feat
%                %D_features(j)=1; %D_features(M,1)
%                image_feats(i,k)=image_feats(i,k)+1;
%            end
%        end
%    end    
end

end



