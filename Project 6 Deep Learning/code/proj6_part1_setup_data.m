function imdb = proj6_part1_setup_data()
%code for Computer Vision, Georgia Tech by James Hays

%This path is assumed to contain 'test' and 'train' which each contain 15
%subdirectories. The train folder has 100 samples of each category and the
%test has an arbitrary amount of each category. This is the exact data and
%train/test split used in Project 4.
SceneJPGsPath = '../data/15SceneData/';

num_train_per_category = 100;
num_test_per_category  = 100; %can be up to 110
total_images = 15*num_train_per_category + 15 * num_test_per_category;

image_size = [64 64]; %downsampling data for speed and because it hurts
% accuracy surprisingly little

imdb.images.data   = zeros(image_size(1), image_size(2), 1, total_images, 'single');
imdb.images.labels = zeros(1, total_images, 'single');
imdb.images.set    = zeros(1, total_images, 'uint8');
image_counter = 1;

categories = {'bedroom', 'coast', 'forest', 'highway', ...
              'industrial', 'insidecity', 'kitchen', ...
              'livingroom', 'mountain', 'office', 'opencountry', ...
              'store', 'street', 'suburb', 'tallbuilding'};
          
sets = {'train', 'test'};

fprintf('Loading %d train and %d test images from each category\n', ...
          num_train_per_category, num_test_per_category)
fprintf('Each image will be resized to %d by %d\n', image_size(1),image_size(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cal. Image Sum %%
%Read each image and resize it to image_size
%image_sum=0;
%for category = 1:length(categories)
%    cur_path = fullfile( SceneJPGsPath, sets{1}, categories{category});
%    cur_images = dir( fullfile( cur_path,  '*.jpg') );        
%    cur_images = cur_images(1:num_train_per_category);


%    for i = 1:length(cur_images)
%        cur_image = imread(fullfile(cur_path, cur_images(i).name));
%        cur_image = single(cur_image);
%        if(size(cur_image,3) > 1)
%            fprintf('color image found %s\n', fullfile(cur_path, cur_images(i).name));
%            cur_image = rgb2gray(cur_image);
%        end
%        cur_image = imresize(cur_image, image_size);
%        image_sum=image_sum+mean(mean(cur_image));
%    end
%end
%image_sum=image_sum./length(cur_images)./length(categories);
%fprintf('image sum = %d\n',image_sum);
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image_sum=116.2081;
%Read each image and resize it to image_size
for set = 1:length(sets)
    for category = 1:length(categories)
        cur_path = fullfile( SceneJPGsPath, sets{set}, categories{category});
        cur_images = dir( fullfile( cur_path,  '*.jpg') );
        
        if(set == 1)
            fprintf('Taking %d out of %d images in %s\n', num_train_per_category, length(cur_images), cur_path);
            cur_images = cur_images(1:num_train_per_category);
        elseif(set == 2)
            fprintf('Taking %d out of %d images in %s\n', num_test_per_category, length(cur_images), cur_path);
            cur_images = cur_images(1:num_test_per_category);
        end

        for i = 1:length(cur_images)

            cur_image = imread(fullfile(cur_path, cur_images(i).name));
            cur_image = single(cur_image);
            if(size(cur_image,3) > 1)
                fprintf('color image found %s\n', fullfile(cur_path, cur_images(i).name));
                cur_image = rgb2gray(cur_image);
            end
            cur_image = imresize(cur_image, image_size);
            cur_image=cur_image-image_sum;           
            % Stack images into a large image_size x 1 x total_images matrix
            % images.data
            imdb.images.data(:,:,1,image_counter) = cur_image;            
            imdb.images.labels(  1,image_counter) = category;
            imdb.images.set(     1,image_counter) = set; %1 for train, 2 for test (val)
            
            image_counter = image_counter + 1;
        end
    end
end

