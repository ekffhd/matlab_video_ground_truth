close all; clc; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%
startNum = 1;
interval = 1;

out_ext = 'mat';
in_ext = 'bmp';
inFolder = 'video\images';
outFolder = 'groundtruth';
%%%%%%%%%%%%%%%%%%%%%%%%%

file_out = dir([outFolder '\*.' out_ext]);
file_in = dir([inFolder '\*.' in_ext]);

for i=startNum:interval:length(file_out)
    load([outFolder '\' file_out(i).name]);
    img = imread([inFolder '\' file_in(i).name]);
    imshow(img);
    file_out(i).name
    while(1)  
         for j=1:1:length(pnt)
                xmin = pnt(j).rect(1);
                ymin = pnt(j).rect(2);
                width = pnt(j).rect(3);
                height = pnt(j).rect(4);
                hold on; plot(pnt(j).x,pnt(j).y,'rx');
                line([xmin xmin+width xmin+width xmin xmin],[ymin ymin ymin+height ymin+height ymin],'Color','g');
         end
         w = waitforbuttonpress;
         switch w
             case 1
                 key = get(gcf,'currentcharacter');
                    switch key
                        case 13
                            disp()
                            break
                        otherwise
                    end
         end
         
         break

    end
end

