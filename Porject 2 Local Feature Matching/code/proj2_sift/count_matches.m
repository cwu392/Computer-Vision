function [ count ] = count_matches( matched )
j=1
for i =1:size(matched,2)
    if matched(1,i)>0
        count_matched(j,1)=matched(1,i);
        j=j+1;
    end
end
count=size(count_matched,1)
end