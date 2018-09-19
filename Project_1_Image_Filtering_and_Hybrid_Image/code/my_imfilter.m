function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

%Padding%
[m,n]=size(filter);
[x,y,z]=size(image);
image_padding=zeros(x+m-1,y+n-1,z);

%% Time for Padding 0.016 sec %%
%tic;
%for a=1:x
%    for b=1:y
%        for c=1:z
%            image_padding(a+(m-1)/2,b+(n-1)/2,c)=image(a,b,c);
%        end
%    end
%end
%toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Time for Padding 0.012 sec %%
%tic;
image_padding=padarray(image,[(m-1)/2,(n-1)/2]);
%toc

output=zeros(x,y,z);
%% Time for Convolution 6.88 sec %%
%tic;
for a=1:x
    for b=1:y
        for c=1:z
            for d=1:m
                for e=1:n
                    output(a,b,c)=output(a,b,c)+image_padding(a+d-1,b+e-1,c)*filter(d,e);
                end
            end
        end
    end
end
%toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
