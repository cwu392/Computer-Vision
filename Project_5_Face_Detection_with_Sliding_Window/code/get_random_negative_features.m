% Starter code prepared by James Hays for CS 4476, Georgia Tech
% This function should return negative training examples (non-faces) from
% any images in 'non_face_scn_path'. Images should be converted to
% grayscale because the positive training data is only available in
% grayscale. For best performance, you should sample random negative
% examples at multiple scales.

function features_neg = get_random_negative_features(non_face_scn_path, feature_params, num_samples)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
% 'num_samples' is the number of random negatives to be mined, it's not
%   important for the function to find exactly 'num_samples' non-face
%   features, e.g. you might try to sample some number from each image, but
%   some images might be too small to find enough.

% 'features_neg' is N by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
num_images = length(image_files);
cell_size=feature_params.hog_cell_size;
temp_size = feature_params.template_size;
D=(temp_size/cell_size)^2*31;
features_neg=zeros(num_samples,D);
k=1; %Total
scale_factor=0.9;

for i=1:num_images
    img = imread(fullfile(image_files(i).folder, image_files(i).name ));
    img = single(img)/255;
    if (size(img,3)>1)
        img = rgb2gray(img);
    end
    
    %cur_x_min = int16(rand(40,1) * size(img,2));
    %cur_y_min = int16(rand(40,1) * size(img,1));
    %for x=1:size(cur_x_min,1)
    %    if cur_x_min(x)+35 >= size(img,2)
    %        cur_x_min(x)=size(img,2)-35;
    %    elseif cur_x_min(x)==0
    %        cur_x_min(x)=1;
    %    end
    %    if cur_y_min(x)+35 >= size(img,1)
    %        cur_y_min(x)=size(img,1)-35; 
    %    elseif cur_y_min(x)==0
    %        cur_y_min(x)=1;
    %    end
    %end

    %cur_bboxes = [cur_x_min, cur_y_min, cur_x_min + 35, cur_y_min + 35];
    %for j=1:size(cur_bboxes,1)
    %    box=img(cur_bboxes(j,2):cur_bboxes(j,4),cur_bboxes(j,1):cur_bboxes(j,3));
    %    hog=vl_hog(single(box),cell_size,'verbose');
    %    features_neg(k,:)=reshape(hog,[1,6*6*31]);
    %    k=k+1;
    %end
    num_of_feat=floor(size(img,1)/temp_size)*floor(size(img,2)/temp_size);
    while (size(img,1)>=temp_size) && (size(img,2)>=temp_size) && (k<=num_samples)
        for j = 1 : num_of_feat
            x = ceil(rand() * (size(img,1) - temp_size)) + 1;
            y = ceil(rand() * (size(img,2) - temp_size)) + 1;
            box = img(x : x + temp_size - 1, y : y + temp_size - 1);
            hog = vl_hog(single(box), cell_size);
            hog = reshape(hog,[1,D]);
            features_neg(k, :) = hog;
            k = k + 1;
        end
        img = imresize(img, scale_factor);
        num_of_feat=floor(size(img,1)/temp_size)*floor(size(img,2)/temp_size);
    end    
end
% placeholder to be deleted. 100 random features.
%features_neg = hog;