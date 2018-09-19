% Before trying to construct hybrid images, it is suggested that you
% implement my_imfilter.m and then debug it using proj1_test_filtering.m

% Debugging tip: You can split your MATLAB code into cells using "%%"
% comments. The cell containing the cursor has a light yellow background,
% and you can press Ctrl+Enter to run just the code in that cell. This is
% useful when projects get more complex and slow to rerun from scratch

close all; % closes all figures
clear all;
tic;

%% Setup
% read images and convert to floating point format
image1 = im2single(imread('../data/motorcycle.bmp'));
image2 = im2single(imread('../data/bicycle.bmp'));

for i=1:5
    for j=1:5
            filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
            filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
            low_frequencies = imfilter(image1, filter_low);
            high_frequencies = image2-imfilter(image2, filter_high);
            hybrid_image = low_frequencies+high_frequencies;
            imwrite(hybrid_image,sprintf('../html/Hybrid/Bicycle_Motorcycle/Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            imwrite(imresize(hybrid_image,0.5^4,'bilinear'),sprintf('../html/Hybrid/Bicycle_Motorcycle/Hybrid_Small_%d_%d.jpg',i,j), 'quality', 95);
            Reshape_image1=reshape(image1,[1,numel(image1)]);
            Reshape_image2=reshape(image2,[1,numel(image2)]);
            Reshape_hybrid=reshape(hybrid_image,[1,numel(hybrid_image)]);
            S2(i,j)=pdist2(Reshape_image2,Reshape_hybrid,'euclidean');
            Y2(i,j)=pdist2(Reshape_image1,Reshape_hybrid,'euclidean');
            S1(i,j)=pdist2(imresize(Reshape_image1,0.5^4,'bilinear'),imresize(Reshape_hybrid,0.5^4,'bilinear'),'euclidean');
            Y1(i,j)=pdist2(imresize(Reshape_image2,0.5^4,'bilinear'),imresize(Reshape_hybrid,0.5^4,'bilinear'),'euclidean');
    end
end

S2_min=min(min(S2));
Y2_min=min(min(Y2));
S1_min=min(min(S1));
Y1_min=min(min(Y1));

S2_norm=max(max(S2-S2_min));
Y2_norm=max(max(Y2-Y2_min));
S1_norm=max(max(S1-S1_min));
Y1_norm=max(max(Y1-Y1_min));

     
S2_R=(S2-S2_min)/S2_norm;       
Y2_R=(Y2-Y2_min)/Y2_norm;
S1_R=(S1-S1_min)/S1_norm;
Y1_R=(Y1-Y1_min)/Y1_norm;
S_total=S1_R+S2_R-Y1_R-Y2_R;

S_min=min(min(S_total));

for i=1:5
    for j=1:5
        if S_total(i,j)==S_min
            filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
            filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
            low_frequencies = imfilter(image1, filter_low);
            high_frequencies = image2-imfilter(image2, filter_high);
            hybrid_image = low_frequencies+high_frequencies;
            imwrite(hybrid_image,sprintf('../html/Hybrid/Best/Bicycle_Motorcycle_Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            vis = vis_hybrid_image(hybrid_image);
            imwrite(vis, sprintf('../html/Hybrid/Best/Bicycle_Motorcycle_Hybrid_VIS_%d_%d.jpg',i,j), 'quality', 95);
        end
    end
end
            

toc