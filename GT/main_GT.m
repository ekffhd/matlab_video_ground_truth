close all; clc; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%
startNum = 1;
interval = 1;

ext = 'pgm';
inFolder = 'sample';
outFolder = 'groundtruth';
%%%%%%%%%%%%%%%%%%%%%%%%%

file = dir([inFolder '\*.' ext]);
im = imread([inFolder '\' file(1).name]);
[H W] = size(im);

for i=startNum:interval:length(file)
    i
    figure(1);
    pnt = [];
    im = imread([inFolder '\' file(i).name]);
    hold on; imshow(im);
    b = 1;  n = 0;  j = 0;
    while(b==1)        
        j = j + 1;
        [x(j) y(j) b] = ginput(1);
        if b==3
            break;
        else
            x(j) = min(x(j),W);     x(j) = max(x(j),1);
            y(j) = min(y(j),H);     y(j) = max(y(j),1);
            hold on; plot(x(j),y(j),'rx');
            if mod(j,4)==0
                n = n + 1;
                xmax = max(x);  xmin = min(x);
                ymax = max(y);  ymin = min(y);
                pnt(n).x = x;   pnt(n).y = y;
                pnt(n).rect = [xmin ymin xmax-xmin+1 ymax-ymin+1];
                line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color','g');
                j = 0;
                clear x y;                
            end            
        end
    end
    save([outFolder '\' file(i).name(1:end-length(ext)-1) '.mat'], 'pnt');
    clear pnt;
end