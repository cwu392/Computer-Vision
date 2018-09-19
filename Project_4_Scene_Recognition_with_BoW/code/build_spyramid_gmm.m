function stats = build_spyramid_gmm(image_paths, vocab_size )

% Parameters
step_size = 15;
bin_size = 8;

% Gaussian Parameter
level=2; %Spatial Pyramid Level: 1, 4, 16
W=0;
L=0;
data = [];
for i = 1 : size(image_paths)
    %Level=0: (original image)
    img = imread(image_paths{i});
    [W,L]=size(img);
    [~, SIFT_features_L0] = vl_dsift(single(img), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features_L0);
    %Level=1: (1/4 original images)
    img_L1_1=img(1:int16(W/2),1:int16(L/2));
    img_L1_2=img(1:int16(W/2),int16(L/2)+1:L);
    img_L1_3=img(int16(W/2)+1:W,1:int16(L/2));
    img_L1_4=img(int16(W/2)+1:W,int16(L/2)+1:L);    
    [~, SIFT_features_L1_1] = vl_dsift(single(img_L1_1), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L1_2] = vl_dsift(single(img_L1_2), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L1_3] = vl_dsift(single(img_L1_3), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L1_4] = vl_dsift(single(img_L1_4), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features_L1_1, SIFT_features_L1_2, SIFT_features_L1_3, SIFT_features_L1_4);
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
    data = horzcat(data, SIFT_features_L2_1, SIFT_features_L2_2, SIFT_features_L2_3, SIFT_features_L2_4);
    
    [~, SIFT_features_L2_5] = vl_dsift(single(img_L2_5), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_6] = vl_dsift(single(img_L2_6), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_7] = vl_dsift(single(img_L2_7), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_8] = vl_dsift(single(img_L2_8), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features_L2_5, SIFT_features_L2_6, SIFT_features_L2_7, SIFT_features_L2_8);
    
    [~, SIFT_features_L2_9] = vl_dsift(single(img_L2_9), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_10] = vl_dsift(single(img_L2_10), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_11] = vl_dsift(single(img_L2_11), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_12] = vl_dsift(single(img_L2_12), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features_L2_9, SIFT_features_L2_10, SIFT_features_L2_11, SIFT_features_L2_12);
    
    [~, SIFT_features_L2_13] = vl_dsift(single(img_L2_13), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_14] = vl_dsift(single(img_L2_14), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_15] = vl_dsift(single(img_L2_15), 'fast', 'step', step_size, 'size', bin_size);
    [~, SIFT_features_L2_16] = vl_dsift(single(img_L2_16), 'fast', 'step', step_size, 'size', bin_size);
    data = horzcat(data, SIFT_features_L2_13, SIFT_features_L2_14, SIFT_features_L2_15, SIFT_features_L2_16);
end

[means, covariances, priors] = vl_gmm(single(data), vocab_size);

stats = [means' covariances' priors];

end
