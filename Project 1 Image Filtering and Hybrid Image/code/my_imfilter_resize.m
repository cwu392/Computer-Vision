function output=my_imfilter_resize(image,filter)
[m,n,k]=size(image);
[x,y]=size(filter);

image_new1=[zeros((x-1)/2),reshape(image,[1,numel(image)]),zeros((x-1)/2)];
big_matrix1=zeros(3,numel(image_new1));

for i=1:3
   big_matrix1(i,:)=[zeros(1,i-1),image_new1(1:numel(image_new1)-i+1)];
end

ans1=filter*big_matrix1;
out_temp=zeros(1,m*n*k);
out_temp=ans1(1,:)+ans1(2,:)+ans1(3,:);
out_temp(1)=[];
out_temp(1)=[];

output=zeros(m,n,k);
output=reshape(out_temp,[m,n,k]);

