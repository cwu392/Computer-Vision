img=imread(test_image_paths{101});
[W,L]=size(img);
subplot(1,3,1);
imshow(img);

subplot(1,3,3);
imshow(img);
x=linspace(1,L,5);
hold on; plot([int16(x(2)),int16(x(2))],[1,W],'--','LineWidth',3);
hold on; plot([int16(x(3)),int16(x(3))],[1,W],'--','LineWidth',3);
hold on; plot([int16(x(4)),int16(x(4))],[1,W],'--','LineWidth',3);
y=linspace(1,W,5);
hold on; plot([1,L],[int16(y(2)),int16(y(2))],'--','LineWidth',3);
hold on; plot([1,L],[int16(y(3)),int16(y(3))],'--','LineWidth',3);
hold on; plot([1,L],[int16(y(4)),int16(y(4))],'--','LineWidth',3);

subplot(1,3,2);
imshow(img);
[W,L]=size(img);
imshow(img);
x=linspace(1,L,3);
hold on; plot([int16(x(2)),int16(x(2))],[1,W],'--','LineWidth',3);
y=linspace(1,W,3);
hold on; plot([1,L],[int16(y(2)),int16(y(2))],'--','LineWidth',3);
