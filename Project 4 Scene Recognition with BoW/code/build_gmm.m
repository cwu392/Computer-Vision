function stats = build_gmm(image_paths, vocab_size )

% Parameters 
step_size=15;
bin_size=8;
[m,~]=size(image_paths);
data=[];
for i=1:m
    img=imread(image_paths{i});
    [~, SIFT_features]=vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    data=horzcat(data, SIFT_features);
end
[means, covariances, priors]=vl_gmm(single(data), vocab_size);
stats=[means' covariances' priors];

end
