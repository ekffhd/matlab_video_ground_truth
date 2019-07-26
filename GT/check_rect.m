close all; clc; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%
startNum = 1;
interval = 1;

out_ext = 'mat';
in_ext = 'bmp';
inFolder = 'video\images';
outFolder = 'groundtruth';

cnt = sprintf('%08d',0)
%%%%%%%%%%%%%%%%%%%%%%%%%


people_file_out = dir([outFolder '_people' '\*.' out_ext]);
car_file_out = dir([outFolder '_car' '\*.' out_ext]);

file_in = dir([inFolder '\*.' in_ext]);

if (length(people_file_out) < length(car_file_out))
    max_len = length(car_file_out)
else
    max_len = length(people_file_out)
end
for i=startNum:interval:max_len
    load([outFolder '_people' '\' people_file_out(i).name]);
    load([outFolder '_car' '\' car_file_out(i).name]);
    
    img = imread([inFolder '\' file_in(i).name]);
    imshow(img);
    file_in(i).name
 
    while(1)
        for j = 1:1:length(pnt_1)
            xmin = pnt_1(j).rect(1);
            ymin = pnt_1(j).rect(2);
            width = pnt_1(j).rect(3);
            height = pnt_1(j).rect(4);
            hold on; plot(pnt_1(j).x,pnt_1(j).y,'rx');
            line([xmin xmin+width xmin+width xmin xmin],[ymin ymin ymin+height ymin+height ymin],'Color','r');
        end
        for j = 1:1:length(pnt_2)
            xmin = pnt_2(j).rect(1);
            ymin = pnt_2(j).rect(2);
            width = pnt_2(j).rect(3);
            height = pnt_2(j).rect(4);
            hold on; plot(pnt_2(j).x,pnt_2(j).y,'bx');
            line([xmin xmin+width xmin+width xmin xmin],[ymin ymin ymin+height ymin+height ymin],'Color','b');
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

