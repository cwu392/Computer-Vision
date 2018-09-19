function [ x1,y1,x2,y2 ] = get_coordinates(loc1,loc2,matched)
k=1;
x1=0;
x2=0;
y1=0;
y2=0;

for i = 1: size(matched,2)
    if k<=100
        if (matched(i) > 0)
            x1(k,1)=loc1(i,2);
            x2(k,1)=loc2(matched(i),2);
            y1(k,1)=loc1(i,1);
            y2(k,1)=loc2(matched(i),1);
            k=k+1
        end
    end
end

end