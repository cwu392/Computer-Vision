function output=diff_percentage(image1,image2)
    [m,n,o]=size(image1);
    output=zeros(m,n,o)
    
    
    for i=1:m
        for j=1:n
            for k=1:o
                output(i,j,k)=(single(image1(i,j,k))-image2(i,j,k))/image1(i,j,k);
            end
        end
    end
    