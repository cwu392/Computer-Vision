function output=verify(image1,image2)
    [m,n,o]=size(image1);
    [p,q,r]=size(image2);
    
    %Check image1 and image2 have the same size%
    if m~=p
        if n~=q
            if o~=r
                output=0;
            end
        end
    end
    
    output=1;
    for i=1:m
        for j=1:n
            for k=1:o
                if image1(i,j,k)~= image2(i,j,k)
                    output=0;
                end
            end
        end
    end
    
    
            