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
image1 = im2single(imread('../data/dog.bmp'));
image2 = im2single(imread('../data/cat.bmp'));

for j=1:4:5
filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
high_frequencies=image2-imfilter(image2,filter_high);
filter_high_ref=padarray(1,[j*4 j*4])-filter_high;
high_freq_ref=imfilter(image2,filter_high_ref);
ans=sum(sum(sum(high_frequencies-high_freq_ref)));
surf(filter_high_ref);
shading interp
xlim([0 40]);
ylim([0 40]);
%axis tight
xlabel('X Size');
ylabel('Y Size');
zlabel('Height');
F = getframe;
%imwrite(F.cdata,sprintf('../html/Analysis/CAT_Filter_%d.jpg',j),'jpg');
%subplot(1,2,1);
%imshow(high_frequencies);
%subplot(1,2,2);
%imshow(high_freq_ref);
%imwrite(high_frequencies+0.5,sprintf('../html/Analysis/CAT_%d.jpg',j), 'quality', 95);
%print(2,'-djpg',sprintf('../html/Analysis/CAT_Filter_%d.jpg',j));
end

for i=1:5
filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
low_frequencies = imfilter(image1, filter_low);
%subplot(1,5,i);
%imshow(low_frequencies);
%imwrite(low_frequencies,sprintf('../html/Analysis/DOG_%d.jpg',i), 'quality', 95);
surf(filter_low);
shading interp
xlim([0 40]);
ylim([0 40]);
%axis tight
xlabel('X Size');
ylabel('Y Size');
zlabel('Height');
F = getframe;
imwrite(F.cdata,sprintf('../html/Analysis/DOG_Filter_%d.jpg',i),'jpg');
end

for i=1:5
    for j=1:5
            filter_low = fspecial('Gaussian', i*4*2+1, 2*i);
            filter_high = fspecial('Gaussian', j*4*2+1, 2*j);
            low_frequencies = imfilter(image1, filter_low);
            high_frequencies = image2-imfilter(image2, filter_high);
            hybrid_image = low_frequencies+high_frequencies;
            imwrite(hybrid_image,sprintf('../html/Hybrid/Cat_Dog/Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            imwrite(imresize(hybrid_image,0.5^4,'bilinear'),sprintf('../html/Hybrid/Cat_Dog/Hybrid_Small_%d_%d.jpg',i,j), 'quality', 95);
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
            imwrite(hybrid_image,sprintf('../html/Hybrid/Best/Cat_Dog_Hybrid_%d_%d.jpg',i,j), 'quality', 95);
            vis = vis_hybrid_image(hybrid_image);
            imwrite(vis, sprintf('../html/Hybrid/Best/Cat_Dog_Hybrid_VIS_%d_%d.jpg',i,j), 'quality', 95);
        end
    end
end
            

toc