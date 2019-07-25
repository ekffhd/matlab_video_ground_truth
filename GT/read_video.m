close all; clc; clear all;
% ���� ���
% videoFReader = vision.VideoFileReader('./video/sample.avi');
% 
% videoPlayer = vision.VideoPlayer;
% 
% while ~isDone(videoFReader)
%     frame = step(videoFReader);
%     step(videoPlayer, frame);
% end
% 
% release(videoFReader);
% release(videoPlayer);


%%%%%%%%%%%%%%%%%%%%%%%

start = 0;                     % ���� ������ ����
% class = 0;                    % (�̱���) 0: ���, 1: ��
workingDir = 'video';           % �۾� ���� �̸�
outFolder = 'groundtruth';      % gt������ ������ ���� �̸�
vName = 'sample';               % �������� ������ �̹��� ���� �̸�
ext = 'bpm';                    % �������� ������ �̹��� Ȯ���ڸ�                                    
mkdir(workingDir);              % �۾� ���� ����
mkdir(workingDir, 'images');    % �۾����� �ȿ� ���� �������� ������ ���� ���� 
interval = 30;                  % ������ ���� ����
time_to_remember = [];          % ���� �ð��� ������ �迭

%%%%%%%%%%%%%%%%%%%%%%%

shuttleVideo = VideoReader([workingDir '\sample.avi']);
Video = VideoReader([workingDir '\sample.avi']);
% shuttleVideo = vision.VideoFileReader('sample_video.mov');
                        
global ii;      % ������ �ε���
global index;   

ii = 1;
index = 1;                          
back = 0;


while hasFrame(shuttleVideo)
    
    figure(1);
    pnt = [];
    line_remember = [];
    plot_remember = [];

  
    if mod(ii, interval) == 0
        1 + (ii-interval) + start
        ii
        img = read(Video,1 + (ii-interval) + start);
        index = ii/interval;
        index
        if back == 0
            time_to_remember(index) = shuttleVideo.CurrentTime;
        else
             back = 0;
        end
        ((ii-interval) + start)
        filename = [vName '_' sprintf('%08d',(ii-interval) + start) '.bmp'];
        % ������ ���� Ȯ���� : bmp
        fullname = fullfile(workingDir, 'images', filename);
    
        imwrite(img, fullname);
        im = imread(fullname);
        [H W] = size(im);
        hold on; imshow(im);

        b = 1;  n = 0;  j = 0; cnt = 0; making = 0; back = 0;
        
        while(b==1)        
            j = j + 1;
            [x(j) y(j) b] = ginput(1);
            
            if b==3
                break;
            end
            
            if b==66 || b==98
                
                ii = ii - interval;
                if ii < 1
                    ii = 1;
                end
                
                index = ii/interval
                if index < 1
                    index = 1;
                end
                
                shuttleVideo.CurrentTime = time_to_remember(index);
                back = 1;
                break;
            end
            if b==2 % �ֱٿ� ������ gt ����
                if n ~= 0
                    if making == 0
                        delete(line_remember(n));
                        pnt(n) = [];
                        n = n-1;  
                    else
                        while j ~= 0
                            x(j) = NaN;
                            y(j) = NaN;
                            j = j - 1;
                        end
                        making = 0;
                    end
    
                end
                if cnt ~= 0
                    while 1
                            delete(plot_remember(cnt));
                            cnt = cnt - 1;
                            if mod(cnt, 4) == 0
                                break;
                            end
                    end
                end
                j = 0;
                b=1;
                
            else
                making = 1;
                cnt = cnt + 1;
                x(j) = min(x(j),W);     x(j) = max(x(j),1);
                y(j) = min(y(j),H);     y(j) = max(y(j),1);
                hold on;
                plot_remember(cnt) = plot(x(j),y(j),'rx');
                if mod(j,4)==0
                    n = n + 1;
                    xmax = max(x);  xmin = min(x);
                    ymax = max(y);  ymin = min(y);
                    pnt(n).x = x;   pnt(n).y = y;
                    pnt(n).rect = [xmin ymin xmax-xmin+1 ymax-ymin+1];
                    line_remember(n) = line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color','g');
                    making = 0;
                    j = 0;
                    clear x y;                
                end            
            end
        end
        if back == 0
            save([outFolder '\' filename(1:end-length(ext)-1) '.mat'], 'pnt');
            filename
        else 
            ii = ii - 1;
        end
        clear pnt;
        
    end
    ii = ii+1;
end
    