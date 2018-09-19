function [ pyramid_all ] = create_spyramid(input_path, vocab, level )
%
%
%
pyramid_flag=1;
fprintf('Building Spatial Pyramid\n');

%% parameters
dictionarySize = vocab;
pyramidLevels = level;


if(pyramid_flag)
    binsHigh = 2^(pyramidLevels-1);
    pyramid_all = [];
    nimages=size(image_paths,1);           % number of images in data set
    
    for f = 1:nimages
        
        %% load texton indices
        %image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(f,8)); % location descriptor
        %load(inFName, 'texton_ind');
        img = imread(char(image_paths(f)));
        
        %% get width and height of input image
        wid = size(img,1); %220
        hgt = size(img,2); %293
        
        
        %% compute histogram at the finest level
        pyramid_cell = cell(pyramidLevels,1);
        pyramid_cell{1} = zeros(binsHigh, binsHigh, dictionarySize);
        
        for i=1:binsHigh
            for j=1:binsHigh
                
                % find the coordinates of the current bin
                x_lo = floor(wid/binsHigh * (i-1));
                x_hi = floor(wid/binsHigh * i);
                y_lo = floor(hgt/binsHigh * (j-1));
                y_hi = floor(hgt/binsHigh * j);
                
                sub_img = img(x_lo+1:x_hi,y_lo+1:y_hi);
                %texton_patch = texton_ind.data( (texton_ind.x > x_lo) & (texton_ind.x <= x_hi) & ...
                %    (texton_ind.y > y_lo) & (texton_ind.y <= y_hi));
                
                % make histogram of features in bin
                pyramid_cell{1}(i,j,:) = hist(sub_img, 1:dictionarySize)./length(texton_ind.data);
            end
        end
        
        %% compute histograms at the coarser levels
        num_bins = binsHigh/2;
        for l = 2:pyramidLevels
            pyramid_cell{l} = zeros(num_bins, num_bins, dictionarySize);
            for i=1:num_bins
                for j=1:num_bins
                    pyramid_cell{l}(i,j,:) = ...
                        pyramid_cell{l-1}(2*i-1,2*j-1,:) + pyramid_cell{l-1}(2*i,2*j-1,:) + ...
                        pyramid_cell{l-1}(2*i-1,2*j,:) + pyramid_cell{l-1}(2*i,2*j,:);
                end
            end
            num_bins = num_bins/2;
        end
        
        %% stack all the histograms with appropriate weights
        pyramid = [];
        for l = 1:pyramidLevels-1
            pyramid = [pyramid pyramid_cell{l}(:)' .* 2^(-l)];
        end
        pyramid = [pyramid pyramid_cell{pyramidLevels}(:)' .* 2^(1-pyramidLevels)];    
        pyramid_all = [pyramid_all; pyramid];
        
        fprintf('Pyramid: the %d th images.\n',f);
    end % f
    
    pyramid_all=pyramid_all';
end

end
