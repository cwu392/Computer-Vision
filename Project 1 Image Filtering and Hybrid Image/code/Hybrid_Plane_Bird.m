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
image1 = im2single(imread('../data/bird.bmp'));
image2 = im2single(imread('../data/plane.bmp'));

% Several additional test cases are provided for you, but feel free to make
% your own (you'll need to align the images in a photo editor such as
% Photoshop). The hybrid images will differ depending on which image you
% assign as image1 (which will provide the low frequencies) and which image
% you asign as image2 (which will provide the high frequencies)

%% Filtering and Hybrid Image construction
%cutoff_frequency_low = 7; 

%This is the standard deviation, in pixels, of the 
% Gaussian blur that will remove the high frequencies from one image and 
% remove the low frequencies from another image (by subtracting a blurred
% version from the original version). You will want to tune this for every
% image pair to get the best results.
%for i=1:5
%filter_low = fspecial('Gaussian', i*6*2+1, 2*i);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE BELOW. Use my_imfilter to create 'low_frequencies' and
% 'high_frequencies' and then combine them to create 'hybrid_image'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it. The amount of
% blur that works best will vary with different image pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%low_frequencies = imfilter(image1, filter_low);
%subplot(1,5,i); imshow(imresize(low_frequencies,0.5^2,'bilinear'));
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the low frequencies from image2. The easiest way to do this is to
% subtract a blurred version of image2 from the original version of image2.
% This will give you an image centered at zero with negative values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cutoff_frequency_high= 7;
%for j=1:2
%filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
%high_frequencies = image2-imfilter(image2, filter_high);
%high_frequencies2 = imfilter(image2, filter_high);
%subplot(1,5,j); imshow(high_frequencies+0.5);
%figure(3); imshow(high_frequencies2);
%imwrite(high_frequencies+0.5,sprintf('Fish_Submarine_%d.jpg',j), 'quality', 95);
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:5
    for j=1:5
            filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
            filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
            low_frequencies = imfilter(image1, filter_low);
            high_frequencies = image2-imfilter(image2, filter_high);
            hybrid_image = low_frequencies+high_frequencies;
            imwrite(hybrid_image,sprintf('../html/Hybrid/Plane_Bird/Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            imwrite(imresize(hybrid_image,0.5^4,'bilinear'),sprintf('../html/Hybrid/Plane_Bird/Hybrid_Small_%d_%d.jpg',i,j), 'quality', 95);
            Reshape_image2=reshape(image2,[1,numel(image2)]);
            Reshape_hybrid=reshape(hybrid_image,[1,numel(hybrid_image)]);
            S2(i,j)=pdist2(Reshape_image2,Reshape_hybrid,'euclidean');
            Reshape_image1=reshape(image1,[1,numel(image1)]);
            S1(i,j)=pdist2(imresize(Reshape_image1,0.5^4,'bilinear'),imresize(Reshape_hybrid,0.5^4,'bilinear'),'euclidean');
            S_total(i,j)=S1(i,j)+S2(i,j);
    end
end

S_min=min(min(S_total));
for i=1:5
    for j=1:5
        if S_total(i,j)==S_min
            filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
            filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
            low_frequencies = imfilter(image1, filter_low);
            high_frequencies = image2-imfilter(image2, filter_high);
            hybrid_image = low_frequencies+high_frequencies;
            imwrite(hybrid_image,sprintf('../html/Hybrid/Best/Plane_Bird_Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            vis = vis_hybrid_image(hybrid_image);
            imwrite(vis, sprintf('../html/Hybrid/Best/Plane_Bird_Hybrid_VIS_%d_%d.jpg',i,j), 'quality', 95);
        end
    end
end
            

%%Curious%%


%% Visualize and save outputs
%figure(1); imshow(low_frequencies)
%figure(2); imshow(high_frequencies + 0.5);
%vis = vis_hybrid_image(hybrid_image);
%figure(3); imshow(vis);
%subplot(2,3,1); imshow(image1);
%subplot(2,3,2); imshow(image2);
%subplot(2,3,4); imshow(low_frequencies);
%subplot(2,3,5); imshow(high_frequencies+0.5);
%subplot(2,3,6); imshow(vis);
%imwrite(low_frequencies, 'low_frequencies5.jpg', 'quality', 95);
%imwrite(high_frequencies + 0.5, 'high_frequencies5.jpg', 'quality', 95);
%imwrite(hybrid_image, 'hybrid_image5.jpg', 'quality', 95);
%imwrite(vis, 'hybrid_image_scales5.jpg', 'quality', 95);
toc