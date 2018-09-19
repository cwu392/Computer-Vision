% Starter code prepared by James Hays for CS 4476, Georgia Tech
% This function should return all positive training examples (faces) from
% 36x36 images in 'train_path_pos'. Each face should be converted into a
% HoG template according to 'feature_params'. For improved performance, try
% mirroring or warping the positive training examples to augment your
% training data.

function features_pos = get_positive_features(train_path_pos, feature_params)
% 'train_path_pos' is a string. This directory contains 36x36 images of
%   faces
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
%      (although you don't have to make the detector step size equal a
%      single HoG cell).


% 'features_pos' is N by D matrix where N is the number of faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( train_path_pos, '*.jpg') ); %Caltech Faces stored as .jpg
num_images = length(image_files);
cell_size=feature_params.hog_cell_size;
temp_size = feature_params.template_size;
D=(temp_size/cell_size)^2*31;
hog={};
%imhog={};
features_pos=zeros(num_images,D);
for i=1:2*num_images
    %img_path{i}=[image_files(i).folder '\' image_files(i).name];
    %img{i}=imread(img_path{i});
    img =imread( fullfile( image_files(ceil(i/2)).folder, image_files(ceil(i/2)).name));
    img=single(img)/255;
    if(size(img,3)>1)
        img = rgb2gray(img);
    end
    
    if mod(i, 2) == 0
        hog=vl_hog(single(fliplr(img)),cell_size,'verbose'); %If i%2==0: flip image
    else
        hog=vl_hog(single(img),cell_size,'verbose');
    end
    
    %imhog{i}=vl_hog('render',hog{i},'verbose');
    features_pos(i,:)=reshape(hog,[1,D]);
end

%clf ; imagesc(img{1}) ; colormap gray ;
% placeholder to be deleted. 100 random features.
%features_pos = rand(100, D);


%Plot for report:
%=========================%
%cell_size=2;
%%cell_size=4;
%%cell_size=6;

%i=1; %Plot Image 1 in Caltech Faces
%img_path{1}=[image_files(1).folder '\' image_files(1).name];
%img{1}=imread(img_path{1});
%hog{1}=vl_hog(single(img{1}),cell_size,'verbose');
%imhog{1}=vl_hog('render',hog{1},'verbose');
%clf ; imagesc(imhog{1}) ; colormap gray ;
%=========================%
