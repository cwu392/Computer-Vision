function [net, info] = proj6_part2()
%code for Computer Vision, Georgia Tech by James Hays
%based off the MNIST example from MatConvNet

run(fullfile('..','matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

%It might actually be problematic to run vl_setup, because VLFeat has a
%version of vl_argparse that conflicts with the matconvnet version. You
%shouldn't need VLFeat for this project.
% run(fullfile('vlfeat-0.9.20', 'toolbox', 'vl_setup.m'));

%opts.expDir is where trained networks and plots are saved.
opts.expDir = fullfile('..','data','part2') ;

%opts.batchSize is the number of training images in each batch. You don't
%need to modify this.
opts.batchSize = 50 ;

% opts.learningRate is a critical parameter that can dramatically affect
% whether training succeeds or fails. For most of the experiments in this
% project the default learning rate is safe.
 opts.learningRate = 0.0001 ;

% opts.numEpochs is the number of epochs. If you experiment with more
% complex networks you might need to increase this. Likewise if you add
% regularization that slows training.
 opts.numEpochs = 50 ;

% An example of learning rate decay as an alternative to the fixed learning
% rate used by default. This isn't necessary but can lead to better
% performance.
% opts.learningRate = logspace(-4, -5.5, 300) ;
% opts.numEpochs = numel(opts.learningRate) ;

%opts.continue controls whether to resume training from the furthest
%trained network found in opts.batchSize. If you want to modify something
%mid training (e.g. learning rate) this can be useful. You might also want
%to resume a network that hit the maximum number of epochs if you think
%further training can improve accuracy.
opts.continue = false ;

%GPU support is off by default.
opts.gpus = [] ;

% This option lets you control how many of the layers are fine-tuned.
 opts.backPropDepth = 2; %just retrain the last real layer (1 is softmax)
% opts.backPropDepth = 9; %just retrain the fully connected layers
% opts.backPropDepth = +inf; %retrain all layers [default]

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

net = proj6_part2_cnn_init();

% if exist(opts.imdbPath, 'file')
%   imdb = load(opts.imdbPath) ;
% else
imdb = proj6_part2_setup_data(net.meta.normalization.averageImage);
%   mkdir(opts.expDir) ;
%   save(opts.imdbPath, '-struct', 'imdb') ;
% end



%% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

[net, info] = cnn_train(net, imdb, @getBatch, ...
    opts, ...
    'val', find(imdb.images.set == 2)) ;

end

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
%getBatch is called by cnn_train.

%'imdb' is the image database.
%'batch' is the indices of the images chosen for this batch.

%'im' is the height x width x channels x num_images stack of images. If
%opts.batchSize is 50 and image size is 64x64 and grayscale, im will be
%64x64x1x50.
%'labels' indicates the ground truth category of each image.

%This function is where you should 'jitter' data.
% --------------------------------------------------------------------

%im = imdb.images.data(:,:,:,batch) ;
%labels = imdb.images.labels(1,batch) ;

% Add jittering here before returning im
indice=rand(1);
if indice >=0.5
    im = imdb.images.data(:,:,:,batch) ;
else
    im = fliplr(imdb.images.data(:,:,:,batch)) ;
end
labels = imdb.images.labels(1,batch) ;

end