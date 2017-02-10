function [fg,width ,height ] = frame_difference(Previous,curentr,thresh)
[height, width,~] = size(curentr); 
fr_diff = abs(curentr-Previous);
for j = 1:width
    for k = 1:height
        if (fr_diff(k,j)>thresh)
            fg(k,j) = curentr(k,j);
        else
            fg(k,j) = 0;
        end
    end
end
% subplot(2,2,1) , imshow(uint8(curentr)), title ('Previous Frame');
% subplot(2,2,2) , imshow(uint8(Previous)), title ('Next Frame');
% subplot(2,2,[3,4]) , imshow(uint8(fg)), title ('Foreground');