% Sliding window face detection with linear SVM. 
% All code by James Hays, except for pieces of evaluation code from Pascal
% VOC toolkit. Images from CMU+MIT face database, CalTech Web Face
% Database, and SUN scene database.

% Code structure:
% proj5.m <--- You code parts of this
%  + get_positive_features.m  <--- You code this
%  + get_random_negative_features.m  <--- You code this
%   [classifier training]   <--- You code this
%  + report_accuracy.m
%  + run_detector.m  <--- You code this
%    + non_max_supr_bbox.m
%  + evaluate_all_detections.m
%    + VOCap.m
%  + visualize_detections_by_image.m
%  + visualize_detections_by_image_no_gt.m
%  + visualize_detections_by_confidence.m

% Other functions. You don't need to use any of these unless you're trying
% to modify or build a test set:
%  Training and Testing data related functions:
%   test_scenes/visualize_cmumit_database_landmarks.m
%   test_scenes/visualize_cmumit_database_bboxes.m
%   test_scenes/cmumit_database_points_to_bboxes.m %This function converts
%    from the original MIT+CMU test set landmark points to Pascal VOC
%    annotation format (bounding boxes).

%   caltech_faces/caltech_database_points_to_crops.m %This function extracts
%    training crops from the Caltech Web Face Database. The crops are
%    intentionally large to contain most of the head, not just the face.
%    The test_scene annotations are likewise scaled to contain most of the
%    head.

% set up paths to VLFeat functions. 
% See http://www.vlfeat.org/matlab/matlab.html for VLFeat Matlab documentation
% This should work on 32 and 64 bit versions of Windows, MacOS, and Linux
close all
clear all

ATT_Pos = 'False';
Min_Hard_Negative ='False';
Classifier='SVM'; %NN%

run('../../vlfeat-0.9.20/toolbox/vl_setup')

[~,~,~] = mkdir('visualizations');

data_path = '../data/'; 
train_path_pos = fullfile(data_path, 'caltech_faces/Caltech_CropFaces'); %Positive training examples. 36x36 head crops
non_face_scn_path = fullfile(data_path, 'train_non_face_scenes'); %We can mine random or hard negatives from here
test_scn_path = fullfile(data_path,'test_scenes/test_jpg'); %CMU+MIT test scenes
%test_scn_path = fullfile(data_path,'extra_test_scenes'); %Bonus scenes
label_path = fullfile(data_path,'test_scenes/ground_truth_bboxes.txt'); %the ground truth face locations in the test set

%The faces are 36x36 pixels, which works fine as a template size. You could
%add other fields to this struct if you want to modify HoG default
%parameters such as the number of orientations, but that does not help
%performance in our limited test.
feature_params = struct('template_size', 36, 'hog_cell_size', 4);
%Cell size:3 Acc:93.4 w/o Hard Negative Mining

%% Step 1. Load positive training crops and random negative examples
%YOU CODE 'get_positive_features' and 'get_random_negative_features'
% if ~exist('features_pos_new.mat', 'file')
%     fprintf('No existing feature_pos found. Computing one from training images\n')
    features_pos = get_positive_features( train_path_pos, feature_params );
%     save('features_pos_new.mat', 'features_pos')
% else
%     load('features_pos_new.mat','features_pos')
% end

switch lower(ATT_Pos)
    case true
        if ~exist('features_pos_ATT_new.mat', 'file')
            fprintf('No existing feature_pos_ATT found. Computing one from training images\n')
            features_pos_ATT = get_ATT_features( '../data/att_faces', feature_params );
            save('features_pos_ATT_new.mat', 'features_pos_ATT')
        else
            load('features_pos_ATT_new.mat','features_pos_ATT')
        end
end

num_negative_examples = 10000; %Higher will work strictly better, but you should start with 10000 for debugging
% if ~exist('features_neg_new.mat', 'file')
%     fprintf('No existing feature_neg found. Computing one from training images\n')    
    features_neg = get_random_negative_features( non_face_scn_path, feature_params, num_negative_examples);
%     save('features_neg_new.mat', 'features_neg')
% else
%     load('features_neg_new.mat','features_neg')
% end
    
%% step 2. Train Classifier
% Use vl_svmtrain on your training features to get a linear classifier
% specified by 'w' and 'b'
% [w b] = vl_svmtrain(X, Y, lambda) 
% http://www.vlfeat.org/sandbox/matlab/vl_svmtrain.html
% 'lambda' is an important parameter, try many values. Small values seem to
% work best e.g. 0.0001, but you can try other values

%YOU CODE classifier training. Make sure the outputs are 'w' and 'b'.
%w = rand((feature_params.template_size / feature_params.hog_cell_size)^2 * 31,1); %placeholder, delete
%b = rand(1); %placeholder, delete
lambda=0.00001;
X_pos=features_pos;
X_pos_label=ones(size(X_pos,1),1);
X_neg=features_neg;
X_neg_label=-ones(size(X_neg,1),1);
X=vertcat(X_pos,X_neg);
Y=vertcat(X_pos_label,X_neg_label);
%X DxN matrix, Y N element
[w b]=vl_svmtrain(X',Y,lambda); %wo HNM:88.4%

%% step 3. Examine learned classifier
% You don't need to modify anything in this section. The section first
% evaluates _training_ error, which isn't ultimately what we care about,
% but it is a good sanity check. Your training error should be very low.

fprintf('Initial classifier performance on train data:\n')
confidences = [features_pos; features_neg]*w + b;
label_vector = [ones(size(features_pos,1),1); -1*ones(size(features_neg,1),1)];
[tp_rate, fp_rate, tn_rate, fn_rate] =  report_accuracy( confidences, label_vector );

% Visualize how well separated the positive and negative examples are at
% training time. Sometimes this can idenfity odd biases in your training
% data, especially if you're trying hard negative mining. This
% visualization won't be very meaningful with the placeholder starter code.
non_face_confs = confidences( label_vector < 0);
face_confs     = confidences( label_vector > 0);
figure(2); 
plot(sort(face_confs), 'g','linewidth',3); hold on
plot(sort(non_face_confs),'r','linewidth',3); 
plot([0 size(non_face_confs,1)], [0 0], 'b','linewidth',3);
legend('Face Confidences','Non-face Confidences','Thershold','Location','northwest');
xlabel('Number of Examples:','FontSize',10,'FontWeight','bold');
ylabel('Sorted Confidence:','FontSize',10,'FontWeight','bold');
title('SVM Training Result:','FontSize',12); grid on;
hold off;

% Visualize the learned detector. This would be a good thing to include in
% your writeup!
n_hog_cells = sqrt(length(w) / 31); %specific to default HoG parameters
imhog = vl_hog('render', single(reshape(w, [n_hog_cells n_hog_cells 31])), 'verbose') ;
figure(3); imagesc(imhog) ; colormap gray; set(3, 'Color', [.988, .988, .988])

pause(0.1) %let's ui rendering catch up
hog_template_image = frame2im(getframe(3));
% getframe() is unreliable. Depending on the rendering settings, it will
% grab foreground windows instead of the figure in question. It could also
% return a partial image.
imwrite(hog_template_image, 'visualizations/hog_template.png')
    
 
%% step 4. (optional extra credit) Mine hard negatives
% Mining hard negatives is graduate credit / extra credit. You can get very
% good performance by using random negatives, so hard negative mining is
% somewhat unnecessary for face detection. If you implement hard negative
% mining, you probably want to modify 'run_detector', run the detector on
% the images in 'non_face_scn_path', and keep all of the features above
% some confidence level. Hard negative mining would probably be more
% important if you had a strict budget of negative training examples or a
% more expressive, non-linear classifier that can benefit from more
% trianing data.
switch lower(Min_Hard_Negative)
    case true
%         if ~exist('mine_hard_negative_new.mat','file')
%             fprintf('No existing mine_hard_negative_new.mat found. Computing one for training examples\n')
            [mhn_features, mhn_bboxes, mhn_confidences, mhn_image_ids] = mine_hard_negative(non_face_scn_path, w, b, feature_params);
 
            %Re-train SVM with additional hard negative features: 
            lambda=0.000001;
            %lambda=0.000001; 92.9%
            %lambda=0.0001; 77.2%
            X_pos=[features_pos; features_pos_ATT];
            X_pos_label=ones(size(X_pos,1),1);
            X_neg=[features_neg; mhn_features];
            X_neg_label=-ones(size(X_neg,1),1);
            X=vertcat(X_pos,X_neg);
            Y=vertcat(X_pos_label,X_neg_label);
            %X DxN matrix, Y N element
            [w b]=vl_svmtrain(X',Y,lambda);
%           save('mine_hard_negative_new.mat','mhn_features','X','Y','w','b')
%         else
%             load('mine_hard_negative_new.mat','mhn_features','X','Y','w','b')
%         end
end
%% Step 5. Run detector on test set.
% YOU CODE 'run_detector'. Make sure the outputs are properly structured!
% They will be interpreted in Step 6 to evaluate and visualize your
% results. See run_detector.m for more details.
switch lower(Classifier)
    case 'svm'
%         if ~exist ('detector_nn_new.mat','file')
%             fprintf('No existing detector_new.mat found. Computing one from testing images\n')
            [bboxes, confidences, image_ids] = run_detector(test_scn_path, w, b, feature_params);
%             save('detector_nn_new.mat', 'bboxes', 'confidences', 'image_ids');
%         else
%             load('detector_nn_new.mat','bboxes','confidences','image_ids');
%         end


    case 'nn'
        if ~exist ('detector_new.mat','file')
            fprintf('No existing detector_new.mat found. Computing one from testing images\n')
            [bboxes, confidences, image_ids] = run_detector_NN(test_scn_path, X, Y, feature_params);
            save('detector_new.mat', 'bboxes', 'confidences', 'image_ids');
        else
            load('detector_new.mat','bboxes','confidences','image_ids');
        end
    otherwise
        error('Unknown feature type')
end


% run_detector will have (at least) two parameters which can heavily
% influence performance -- how much to rescale each step of your multiscale
% detector, and the threshold for a detection. If your recall rate is low
% and your detector still has high precision at its highest recall point,
% you can improve your average precision by reducing the threshold for a
% positive detection.


%% Step 6. Evaluate and Visualize detections
% These functions require ground truth annotations, and thus can only be
% run on the CMU+MIT face test set. Use visualize_detectoins_by_image_no_gt
% for testing on extra images (it is commented out below).

% Don't modify anything in 'evaluate_detections'!
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections] = ...
    evaluate_detections(bboxes, confidences, image_ids, label_path);

visualize_detections_by_image(bboxes, confidences, image_ids, tp, fp, test_scn_path, label_path)
% visualize_detections_by_image_no_gt(bboxes, confidences, image_ids, test_scn_path)

% visualize_detections_by_confidence(bboxes, confidences, image_ids, test_scn_path, label_path);

% performance to aim for
% random (stater code) 0.001 AP
% single scale ~ 0.2 to 0.4 AP
% multiscale, 6 pixel cell size and detector step ~ 0.83 AP
% multiscale, 4 pixel cell size and detector step ~ 0.89 AP
% multiscale, 3 pixel cell size and detector step ~ 0.92 AP