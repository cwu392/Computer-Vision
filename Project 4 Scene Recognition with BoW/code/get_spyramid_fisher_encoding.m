function image_feats = get_spyramid_fisher_encoding(image_paths)

load('stats.mat')
means = stats(:, 1:128)';
covariances = stats(:, 129:256)';
priors = stats(:, 257);

% Parameters 
step_size = 5;
bin_size = 8;

image_feats = [];
SIFT_featuresL_L0=[];
for i = 1 : size(image_paths)
    img = imread(image_paths{i});
    [W,L]=size(img);
    %Level=0: (original image)
    [~, SIFT_featuresL_L0] = vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    image_feats_L0(i, :) = vl_fisher(single(SIFT_featuresL_L0), means, covariances, priors, 'Improved');
    %Level=1: (1/4 original images)
    img_L1_1=img(1:int16(W/2),1:int16(L/2));
    img_L1_2=img(1:int16(W/2),int16(L/2)+1:L);
    img_L1_3=img(int16(W/2)+1:W,1:int16(L/2));
    img_L1_4=img(int16(W/2)+1:W,int16(L/2)+1:L);

	[~, SIFT_features_L1_1] = vl_dsift(single(img_L1_1), 'fast', 'step', step_size, 'size', bin_size);
	[~, SIFT_features_L1_2] = vl_dsift(single(img_L1_2), 'fast', 'step', step_size, 'size', bin_size);
	[~, SIFT_features_L1_3] = vl_dsift(single(img_L1_3), 'fast', 'step', step_size, 'size', bin_size);
	[~, SIFT_features_L1_4] = vl_dsift(single(img_L1_4), 'fast', 'step', step_size, 'size', bin_size);   
	image_feats_L1_1(i, :) = vl_fisher(single(SIFT_features_L1_1), means, covariances, priors, 'Improved');
	image_feats_L1_2(i, :) = vl_fisher(single(SIFT_features_L1_2), means, covariances, priors, 'Improved');
	image_feats_L1_3(i, :) = vl_fisher(single(SIFT_features_L1_3), means, covariances, priors, 'Improved');
	image_feats_L1_4(i, :) = vl_fisher(single(SIFT_features_L1_4), means, covariances, priors, 'Improved');
    %Level=2: (1/16 images)
    img_L2_1=img(1:int16(W/4),1:int16(L/4));
    img_L2_2=img(1:int16(W/4),int16(L/4)+1:int16(L/2));
    img_L2_3=img(1:int16(W/4),int16(L/2)+1:int16(3*L/4));
    img_L2_4=img(int16(W/4)+1:int16(W/2),int16(3*L/4)+1:L);
    
    img_L2_5=img(int16(W/4)+1:int16(W/2),1:int16(L/4));
    img_L2_6=img(int16(W/4)+1:int16(W/2),int16(L/4)+1:int16(L/2));
    img_L2_7=img(int16(W/4)+1:int16(W/2),int16(L/2)+1:int16(3*L/4));
    img_L2_8=img(int16(W/4)+1:int16(W/2),int16(3*L/4)+1:L);
    
    img_L2_9=img(int16(W/2)+1:int16(3*W/4),1:int16(L/4));
    img_L2_10=img(int16(W/2)+1:int16(3*W/4),int16(L/4)+1:int16(L/2));
    img_L2_11=img(int16(W/2)+1:int16(3*W/4),int16(L/2)+1:int16(3*L/4));
    img_L2_12=img(int16(W/2)+1:int16(3*W/4),int16(3*L/4)+1:L);
    
    img_L2_13=img(int16(3*W/4)+1:W,1:int16(L/4));
    img_L2_14=img(int16(3*W/4)+1:W,int16(L/4)+1:int16(L/2));
    img_L2_15=img(int16(3*W/4)+1:W,int16(L/2)+1:int16(3*L/4));
    img_L2_16=img(int16(3*W/4)+1:W,int16(3*L/4)+1:L);

    [~, SIFT_features_L2_1] = vl_dsift(single(img_L2_1), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_2] = vl_dsift(single(img_L2_2), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_3] = vl_dsift(single(img_L2_3), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_4] = vl_dsift(single(img_L2_4), 'fast', 'step', step_size, 'size', bin_size);
    
    [~, SIFT_features_L2_5] = vl_dsift(single(img_L2_5), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_6] = vl_dsift(single(img_L2_6), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_7] = vl_dsift(single(img_L2_7), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_8] = vl_dsift(single(img_L2_8), 'fast', 'step', step_size, 'size', bin_size);
    
    [~, SIFT_features_L2_9] = vl_dsift(single(img_L2_9), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_10] = vl_dsift(single(img_L2_10), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_11] = vl_dsift(single(img_L2_11), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_12] = vl_dsift(single(img_L2_12), 'fast', 'step', step_size, 'size', bin_size);
    
    [~, SIFT_features_L2_13] = vl_dsift(single(img_L2_13), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_14] = vl_dsift(single(img_L2_14), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_15] = vl_dsift(single(img_L2_15), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_16] = vl_dsift(single(img_L2_16), 'fast', 'step', step_size, 'size', bin_size);

	image_feats_L2_1(i, :) = vl_fisher(single(SIFT_features_L2_1), means, covariances, priors, 'Improved');
	image_feats_L2_2(i, :) = vl_fisher(single(SIFT_features_L2_2), means, covariances, priors, 'Improved');
	image_feats_L2_3(i, :) = vl_fisher(single(SIFT_features_L2_3), means, covariances, priors, 'Improved');
	image_feats_L2_4(i, :) = vl_fisher(single(SIFT_features_L2_4), means, covariances, priors, 'Improved');
	image_feats_L2_5(i, :) = vl_fisher(single(SIFT_features_L2_5), means, covariances, priors, 'Improved');
	image_feats_L2_6(i, :) = vl_fisher(single(SIFT_features_L2_6), means, covariances, priors, 'Improved');
	image_feats_L2_7(i, :) = vl_fisher(single(SIFT_features_L2_7), means, covariances, priors, 'Improved');
	image_feats_L2_8(i, :) = vl_fisher(single(SIFT_features_L2_8), means, covariances, priors, 'Improved');
	image_feats_L2_9(i, :) = vl_fisher(single(SIFT_features_L2_9), means, covariances, priors, 'Improved');
	image_feats_L2_10(i, :) = vl_fisher(single(SIFT_features_L2_10), means, covariances, priors, 'Improved');
	image_feats_L2_11(i, :) = vl_fisher(single(SIFT_features_L2_11), means, covariances, priors, 'Improved');
	image_feats_L2_12(i, :) = vl_fisher(single(SIFT_features_L2_12), means, covariances, priors, 'Improved');
	image_feats_L2_13(i, :) = vl_fisher(single(SIFT_features_L2_13), means, covariances, priors, 'Improved');
	image_feats_L2_14(i, :) = vl_fisher(single(SIFT_features_L2_14), means, covariances, priors, 'Improved');
	image_feats_L2_15(i, :) = vl_fisher(single(SIFT_features_L2_15), means, covariances, priors, 'Improved');
	image_feats_L2_16(i, :) = vl_fisher(single(SIFT_features_L2_16), means, covariances, priors, 'Improved');

	image_feats=[image_feats_L0 image_feats_L1_1 image_feats_L1_2 image_feats_L1_3 image_feats_L1_4];
	image_feats=[image_feats image_feats_L2_1 image_feats_L2_2 image_feats_L2_3 image_feats_L2_4 ...
							image_feats_L2_5 image_feats_L2_6 image_feats_L2_7 image_feats_L2_8 ...
							image_feats_L2_9 image_feats_L2_10 image_feats_L2_11 image_feats_L2_12 ...
							image_feats_L2_13 image_feats_L2_14 image_feats_L2_15 image_feats_L2_16];

end


end
