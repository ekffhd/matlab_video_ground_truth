close all; clc; clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
workingDir = 'video';               % 작업 폴더 이름
outFolder = 'groundtruth';          % gt정보를 저장할 폴더 이름
ext = 'mat';
div = ',';
path = './data/images/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fileID =fopen('data_train.txt', 'w');
people_file_out = dir([outFolder '_people' '\*.' ext]);

max_len = length(people_file_out);

for i=1:1:max_len
    text = '';
    load([outFolder '_people' '\' people_file_out(i).name]);
 
    filename = people_file_out(i).name(1: length(people_file_out(i).name) - 4);
    text = strcat(text, path);
    text = strcat(text,filename);
    text = strcat(text,".bmp ");
    for j=1:1:length(pnt_1)

        xmin = string(round(min(pnt_1(j).x)));
        text = strcat(text, xmin);
        text = strcat(text, div);
        
        ymin = string(round(min(pnt_1(j).y)));
        text = strcat(text, ymin);
        text = strcat(text, div);
        
        xmax = string(round(max(pnt_1(j).x)));
        text = strcat(text, xmax);
        text = strcat(text, div);
        
        ymax = string(round(max(pnt_1(j).y)));
        text = strcat(text, ymax);
        text = strcat(text, div);
        
        text = strcat(text, '1');
        text = strcat(text, " ");
    end
    text
    fprintf(fileID, text);
    fprintf(fileID, '\r\n');

   
    
end