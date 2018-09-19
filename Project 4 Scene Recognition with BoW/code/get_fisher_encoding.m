function image_feats = get_fisher_encoding(image_paths)

load('stats.mat')
means = stats(:, 1:128)';
covariances = stats(:, 129:256)';
priors = stats(:, 257);

% Parameters 
step_size = 5;
bin_size = 8;

image_feats = [];
for i = 1 : size(image_paths)
    img = imread(char(image_paths(i)));
    [~, SIFT_features] = vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    image_feats(i, :) = vl_fisher(single(SIFT_features), means, covariances, priors, 'Improved');
end


end
