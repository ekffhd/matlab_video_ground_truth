close all; clc; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%
startNum = 1;
interval = 1;

out_ext = 'mat';
in_ext = 'bmp'
inFolder = 'video\images';
outFolder = 'groundtruth';
%%%%%%%%%%%%%%%%%%%%%%%%%

file_out = dir([outFolder '\*.' out_ext]);
file_in = dir([inFolder '\*.' in_ext]);

for i=startNum:interval:length(file_out)
    load([outFolder '\' file_out(i).name]);
    img = imread([inFolder '\' file_in(i).name]);
    hold on; imshow(img);

    while(1)  
         for j=1:1:length(pnt)
                xmin = min(pnt(j).x); xmax = max(pnt(j).x);
                ymin = min(pnt(j).y); ymax = max(pnt(j).y);
                hold on; plot(pnt(j).x,pnt(j).y,'rx');
                line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color','g');
         end
         pause(0.1);
         break

    end
end

