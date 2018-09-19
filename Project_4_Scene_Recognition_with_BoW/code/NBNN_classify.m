function predicted_categories = NBNN_classify(train_image_feats, train_labels, test_image_feats)


[m,n]=size(train_image_feats);
total_SIFT_features=[];
total_SIFT_features=zeros(128,:);
count=0;
j=1;
for i=1:m
    img=imread(image_paths{i});
    [~, SIFT_features] = vl_dsift(single(img),'Fast','Step',10); 
    total_SIFT_features(j)=[total_SIFT_features(j) SIFT_features];
    if count>=100:
      j=j+1;
      count=0;
    end
end
[centers, ~] = vl_kmeans(single(total_SIFT_features), vocab_size);
vocab=centers';

[m,n]=size(train_image_feats);
D = vl_alldist2(train_image_feats',test_image_feats'); 
predicted_categories=cell(m,1);
row_min=0;
for i=1:m
    row_min=min(D(i,:));
    for j=1:m
        if D(i,j)==row_min
            predicted_categories{i}=char(train_labels(j));
        end
    end
end


