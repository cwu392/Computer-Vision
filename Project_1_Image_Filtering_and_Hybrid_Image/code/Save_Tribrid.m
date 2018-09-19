image1 = im2single(imread('../html/Hybrid/TriBrid/Tri_CatDog_VanGogh_at_iteration_9.png'));
vis1 = vis_hybrid_image(image1);
[W1,H1,C1]=size(image1);
%figure(); imshow(vis1);
pig1 = im2single(imread('../html/Hybrid/TriBrid/VanGogh_StarryNight_449x356.jpg'));
pig1_resize=imresize(pig1,[W1 H1]);
imwrite(vis1, '../html/Hybrid/TriBrid/VIS_Tri_CatDog_VanGogh.jpg', 'quality', 95);
imwrite(pig1_resize, '../html/Hybrid/TriBrid/VanGogh_StarryNight_Resized.jpg', 'quality', 95);

image3 = im2single(imread('../html/Hybrid/TriBrid/Tri_EinsteinMarilyn_EdvardMunch_at_iteration_9.png'));
vis3 = vis_hybrid_image(image3);
[W3,H3,C3]=size(image3);
%figure(); imshow(vis3);
pig3 = im2single(imread('../html/Hybrid/TriBrid/EdvardMunch_TheScream.jpg'));
pig3_resize=imresize(pig3,[W3 H3]);
imwrite(vis3, '../html/Hybrid/TriBrid/VIS_Tri_EinsteinMarilyn_EdvardMunch.jpg', 'quality', 95);
imwrite(pig3_resize, '../html/Hybrid/TriBrid/EdvardMunch_TheScream_Resized.jpg', 'quality', 95);


image2 = im2single(imread('../html/Hybrid/TriBrid/Tri_FishSubmarine_DaVinci_at_iteration_9.png'));
vis2 = vis_hybrid_image(image2);
[W2,H2,C2]=size(image2);
%figure(); imshow(vis2);
pig2 = im2single(imread('../html/Hybrid/TriBrid/DaVinci_MonaLisa_345x514.jpg'));
pig2_resize=imresize(pig2,[W2 H2]);
imwrite(vis2, '../html/Hybrid/TriBrid/VIS_Tri_FishSubmarine_DaVinci.jpg', 'quality', 95);
imwrite(pig2_resize, '../html/Hybrid/TriBrid/DaVinci_MonaLisa_Resized.jpg', 'quality', 95);


image4 = im2single(imread('../html/Hybrid/TriBrid/Tri_MotorcycleBicycle_Picasso_at_iteration_9.png'));
vis4 = vis_hybrid_image(image4);
[W4,H4,C4]=size(image4);
%figure(); imshow(vis4);
pig4 = im2single(imread('../html/Hybrid/TriBrid/Picasso_Guernica_600x271.jpg'));
pig4_resize=imresize(pig4,[W4 H4]);
imwrite(vis4, '../html/Hybrid/TriBrid/VIS_Tri_MotorcycleBicycle_Picasso.jpg', 'quality', 95);
imwrite(pig4_resize, '../html/Hybrid/TriBrid/Picasso_Guernica_Resized.jpg', 'quality', 95);

image5 = im2single(imread('../html/Hybrid/TriBrid/Tri_PlaneBird_Monet_at_iteration_9.png'));
vis5 = vis_hybrid_image(image5);
%figure(); imshow(vis4);
[W5,H5,C5]=size(image5);
pig5 = im2single(imread('../html/Hybrid/TriBrid/ClaudeMonet_WomanWithParasol.jpg'));
pig5_resize=imresize(pig5,[W5 H5]);
imwrite(vis5, '../html/Hybrid/TriBrid/VIS_Tri_PlaneBird_Monet.jpg', 'quality', 95);
imwrite(pig5_resize, '../html/Hybrid/TriBrid/ClaudeMonet_WomanWithParasol_Resized.jpg', 'quality', 95);


