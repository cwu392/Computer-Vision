function stats = build_gaussian_gmm(image_paths, vocab_size )

% Parameters
step_size = 15;
bin_size = 8;

% Gaussian Parameter
level=3; %Gaussian Pyramid Level: 0, 1/2, 1/4

data = [];
for i = 1 : size(image_paths)
	for j=1 : level
	    img = imread(char(image_paths(i)));
	    filter_img=imgaussfilt(img,2); %Gaussian std=2
	    resize_img=imresize(filter_img,0.5^(j-1),'bilinear');
	    [~, SIFT_features] = vl_dsift(single(resize_img), 'fast', 'step', step_size, 'size', bin_size);
	    data = horzcat(data, SIFT_features);
	end
end
[means, covariances, priors] = vl_gmm(single(data), vocab_size);

stats = [means' covariances' priors];

end
