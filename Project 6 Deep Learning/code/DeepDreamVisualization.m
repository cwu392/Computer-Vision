close all;
clear all;
net=vgg19;
layers=[5 9 11 13 16 19];
%layers=5;
channels=1:30;
for layer = layers
    I=deepDreamImage(net,layer,channels,...
        'Verbose',false,...
        'PyramidLevels',1);
    figure
    montage(I)
    title(['Layer ' num2str(layer) ' Features'])
end