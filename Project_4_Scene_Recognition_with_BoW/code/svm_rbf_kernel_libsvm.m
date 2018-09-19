% Starter code prepared by James Hays for Computer Vision

%This function will train a linear SVM for every category (i.e. one vs all)
%and then use the learned linear classifiers to predict the category of
%every test image. Every test feature will be evaluated with all 15 SVMs
%and the most confident SVM will "win". Confidence, or distance from the
%margin, is W*X + B where '*' is the inner product or dot product and W and
%B are the learned hyperplane parameters.

function predicted_categories = svm_rbf_kernel_libsvm(train_image_feats, train_labels, test_image_feats, test_labels)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

%{
Useful functions:
 matching_indices = strcmp(string, cell_array_of_strings)
 
  This can tell you which indices in train_labels match a particular
  category. This is useful for creating the binary labels for each SVM
  training task.

[W B] = vl_svmtrain(features, labels, LAMBDA)
  http://www.vlfeat.org/matlab/vl_svmtrain.html

  This function trains linear svms based on training examples, binary
  labels (-1 or 1), and LAMBDA which regularizes the linear classifier
  by encouraging W to be of small magnitude. LAMBDA is a very important
  parameter! You might need to experiment with a wide range of values for
  LAMBDA, e.g. 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10.

  Matlab has a built in SVM, see 'help svmtrain', which is more general,
  but it obfuscates the learned SVM parameters in the case of the linear
  model. This makes it hard to compute "confidences" which are needed for
  one-vs-all classification.

%}

%unique() is used to get the category list from the observed training
%category list. 'categories' will not be in the same order as in proj4.m,
%because unique() sorts them. This shouldn't really matter, though.

%predicted_categories=zeros(num_test,1); %1500x1
categories = unique(train_labels); 
num_categories = length(categories);
%bestc=200;bestg=2; %75.5%
%bestc=100;bestg=1; %78.6%
%bestc=50;bestg=0.5; %79.5%
bestc=200; bestg=0.1;
%bestc=[3125 625 125 25 5];
%bestg=[2.0=75.4 1.0=78.6 0.5=79.5 0.25=79.8 0.125=80.2 0.1=80.1333 0.001=75.77];
%bestg=[0.01 0.001];
%bestg=[0.05=80.0 0.025=80.06 0.01=79.86];
bestcv=0;
train_labels_double=[];
test_labels_double=[];
train_labels_double = -ones(size(train_image_feats,1),1);
test_labels_double = -ones(size(train_image_feats,1),1);
predicted_categories={};
for i=1:num_categories   
    train_labels_double(strcmp(categories{i}, train_labels)) = i;
    test_labels_double(strcmp(categories{i}, test_labels)) = i;
end

total_acc=[];
%for j=1:length(bestg)
%    options=sprintf('-s 0 -t 2 -c %f -b 1 -g %f -q',bestc,bestg(j));
%    model=svmtrain(train_labels_double, train_image_feats, options);
%    [~, accuracy , ~] = svmpredict(test_labels_double,test_image_feats, model,'-b 1');
%    total_acc(j)=accuracy(1);
%end

options=sprintf('-s 0 -t 2 -c %f -b 1 -g %f -q',bestc,bestg);
model=svmtrain(train_labels_double, train_image_feats, options);
[predicted_categories_double, accuracy , dec_values] = svmpredict(test_labels_double,test_image_feats, model,'-b 1');

for i=1:length(predicted_categories_double)
    for j=1:num_categories
        if j == predicted_categories_double(i)
            predicted_categories{i,1}=categories{j};
        end
    end
end

end



