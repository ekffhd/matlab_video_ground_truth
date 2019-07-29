close all; clc; clear all;
% 영상 재생
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

start = 150;                         % 시작 프레임 설정
class = 1;                          % (미구현) 1: 사람, 2: 차
workingDir = 'video';               % 작업 폴더 이름
outFolder = 'groundtruth';          % gt정보를 저장할 폴더 이름
vName = 'WRSO';                   % 프레임을 저장할 이미지 파일 이름
% bName = 'sample';                 % gt 찍은 이미지 파일 이름
ext = 'bpm';                        % 프레임을 저장할 이미지 확장자명                                    
mkdir(workingDir);                  % 작업 폴더 생성
mkdir(workingDir, 'images');        % 작업폴더 안에 영상 프레임을 저장할 폴더 생성
% mkdir(workingDir, 'boxes');       % 작업폴더 안에 gt 찍은 이미지를 저장할 폴더 생성
interval = 30;                      % 프레임 간격 설정
% time_to_remember = [];            % 영상 시간을 저장할 배열

%%%%%%%%%%%%%%%%%%%%%%%

% shuttleVideo = VideoReader([workingDir '\sample.avi']);
Video = VideoReader([workingDir '\WRSO.mp4']);
% shuttleVideo = vision.VideoFileReader('sample_video.mov');
                        
global ii;      % 프레임 인덱스
global index;   

ii = 1;
index = 1;                          
back = 0;


while 1
    
    fig = figure(1);
    pnt_1 = [];
    pnt_2 = [];
    line_remember = zeros(2,1);
    plot_remember = zeros(2,1);
    cnt = zeros(2, 1);
    n = zeros(2, 1);
  
    if mod(ii, interval) == 0
        1 + (ii-interval) + start
        img = read(Video,1 + (ii-interval) + start);
        index = ii/interval;
        back = 0;
        
        filename = [vName '_' sprintf('%08d',(ii-interval) + start) '.bmp'];
        filename
        % 무압축 저장 확장자 : bmp
        % boxname = [vName '_' sprintf('%08d',(ii-interval) + start) '.png'];
        
        fullname = fullfile(workingDir, 'images', filename);
        % boxname = fullfile(workingDir, 'boxes', boxname);
        
        imwrite(img, fullname);
        im = imread(fullname);
        [H W] = size(im);
        hold on; imshow(im);

        b = 1;    j = 0; making = 0; back = 0;

        while(b==1)        
            j = j + 1;
            [x(j) y(j) b] = ginput(1);
            
            if b==3
                % 우클릭 : 다음 프레임으로
                break;
            end
            
            if b==66 || b==98
                % 키보드 b : 이전 프레임으로
                ii = ii - interval;
                if ii < 1
                    ii = 1;
                end
                
                index = ii/interval;
                if index < 1
                    index = 1;
                end

                back = 1;
                break;
            end
            
            if b == 49
                if cnt(class) ~= 0 && making == 1
                        while 1
                                delete(plot_remember(class, cnt(class)));
                                cnt(class) = cnt(class) - 1;
                                if mod(cnt(class), 4) == 0
                                    break;
                                end
                        end
                        making = 0;
                end
                class = 1
                
                j = 0;
                b = 1;
            elseif b == 50
                if cnt(class) ~= 0 && making == 1
                        while 1
                                delete(plot_remember(class, cnt(class)));
                                cnt(class) = cnt(class) - 1;
                                if mod(cnt(class), 4) == 0
                                    break;
                                end
                        end
                        making = 0;
                end
                class = 2
                j = 0;
                b = 1;
            
            elseif b==2
                % 휠 : 최근에 생성된 gt 삭제

                    if n(class) ~= 0
                        if making == 0
                            delete(line_remember(class, n(class)));
                            if class == 1
                                pnt_1(n(class)) = [];
                            elseif class == 2
                                pnt_2(n(class)) = [];
                            end
                            n(class) = n(class) - 1;
                        else
                            while j ~= 0
                                x(j) = NaN;
                                y(j) = NaN;
                                j = j - 1;
                            end
                            making = 0;
                        end

                    end
                    if cnt(class) ~= 0
                        while 1
                                delete(plot_remember(class, cnt(class)));
                                cnt(class) = cnt(class) - 1;
                                if mod(cnt(class), 4) == 0
                                    break;
                                end
                        end
                    end
                    j = 0;
                    b=1;
            else
                making = 1;
                
                x(j) = min(x(j),W);     x(j) = max(x(j),1);
                y(j) = min(y(j),H);     y(j) = max(y(j),1);
                
                cnt(class) = cnt(class) + 1;
                hold on;
                
                if class == 1
                    plot_remember(class, cnt(class)) = plot(x(j),y(j),'rx');
                elseif class == 2
                    plot_remember(class, cnt(class)) = plot(x(j),y(j),'bx');
                end
                if mod(j, 4) == 0
                    n(class) = n(class) + 1;
                    xmax = max(x);  xmin = min(x);
                    ymax = max(y);  ymin = min(y);
                    
                    if class == 1
                        pnt_1(n(class)).x = x;   pnt_1(n(class)).y = y;
                        pnt_1(n(class)).rect = [xmin ymin xmax-xmin+1 ymax-ymin+1];
                        color = 'r';

                    elseif class ==2
                        pnt_2(n(class)).x = x; pnt_2(n(class)).y = y;
                        pnt_2(n(class)).rect = [xmin ymin xmax-xmin+1 ymax-ymin+1];
                        color = 'b';
                    end
                    
                    line_remember(class, n(class)) = line([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'Color',color);
                    making = 0;
                    j = 0;
                    clear x y;
                end
                    
            end
        end
        if back == 0

            save([outFolder '_people' '\' filename(1:end-length(ext)-1) '.mat'],'pnt_1');

            save([outFolder '_car' '\' filename(1:end-length(ext)-1) '.mat'], 'pnt_2');
            
        else 
            ii = ii - 1;
        end
        clear pnt_1;
        clear pnt_2
        % saveas(fig, boxname); 시간이 너무 오래걸린다
    end
    ii = ii+1;
end
    