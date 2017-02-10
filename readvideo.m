clear;close all;fclose all ;clc;
%% Toolbox 
addpath(genpath('F:\compitition\'));
addpath(genpath('E:\doctorat_azeddine\toolbox_azeddine\'));
%% Warning
load('FirstImpressionsV2.mat')
load('landmarks.mat')
VID_NUM = length(data);
%%
false = [];
cof = 2; cpt = 1;
for i=1:2%VID_NUM
    disp(i)
    if isempty(landmarks(i).landmarks{1,1})
        false(cpt,:) = i ;
        cpt = cpt+1;
    else
        vidname = sprintf(strcat('database/',data(i).video));
        opFolder = fullfile(cd, 'crop',data(i).video);%read frame  [480] Done in 711s
        mov = VideoReader(vidname); clear vidname;
        if ~exist(opFolder, 'dir');
            mkdir(opFolder);
        end
        numFrames = mov.NumberOfFrames;
        for t = 1:numFrames
            disp(t)
            currFrame = read(mov, t); 
            %figure(1),imshow(currFrame);
            %hold on
            %pause(5)
            if ~isempty(landmarks(i).landmarks{1,t})
                Reyex = (landmarks(i).landmarks{1,t}(1,1)+landmarks(i).landmarks{1,t}(2,1))/2;
                Reyey = (landmarks(i).landmarks{1,t}(1,2)+landmarks(i).landmarks{1,t}(2,2))/2;
                Leyex = (landmarks(i).landmarks{1,t}(3,1)+landmarks(i).landmarks{1,t}(4,1))/2;
                Leyey = (landmarks(i).landmarks{1,t}(3,2)+landmarks(i).landmarks{1,t}(4,2))/2;
                pos = [Leyex Reyex; Leyey Reyey];  %// Y 
                axe_x=[Leyex Reyex];
                axe_y=[Leyey Reyey];
                [New_lan_x New_lan_y IMG_rotate]=rotate_crop(currFrame,pos,axe_x,axe_y,2);clear IMG;
                right_eyex = New_lan_x(1,1);left_eyex = New_lan_x(2,1);
                right_eyey = New_lan_y(1,1);left_eyey = New_lan_y(2,1);
                %figure(2),imshow(IMG_rotate);
                %hold on;
                %plot(New_lan_x,New_lan_y,'-','LineWidth',2);
                %plot(New_lan_x,New_lan_y,'g+','LineWidth',2);
                x=[ left_eyex right_eyex];y=[ left_eyey right_eyey];
                pos = [x(1,2) x(1,1); y(1,2) y(1,1)];  %// Y 
                A=abs(diff(pos(1,:)));
                xxx=[x(1,1)-(A/cof) x(1,2)+(A/cof) x(1,1)-(A/cof) x(1,2)+(A/cof)];
                yyy=[y(1,1)-(A/cof) y(1,2)-(A/cof) y(1,1)+(A*1.5) y(1,2)+(A*1.5)];
                maxx = max(xxx); maxy = max(yyy); minx = min(xxx); miny = min(yyy);
                IMG3 = imcrop(IMG_rotate,[minx miny maxx-minx maxy-miny]);clear IMG_rotate;
            
            else
                [New_lan_x New_lan_y IMG_rotate]=rotate_crop(currFrame,pos,axe_x,axe_y,2);clear IMG;
                right_eyex = New_lan_x(1,1);left_eyex = New_lan_x(2,1);
                right_eyey = New_lan_y(1,1);left_eyey = New_lan_y(2,1);
                x=[ left_eyex right_eyex];y=[ left_eyey right_eyey];
                pos = [x(1,2) x(1,1); y(1,2) y(1,1)];  %// Y 
                A=abs(diff(pos(1,:)));
                xxx=[x(1,1)-(A/cof) x(1,2)+(A/cof) x(1,1)-(A/cof) x(1,2)+(A/cof)];
                yyy=[y(1,1)-(A/cof) y(1,2)-(A/cof) y(1,1)+(A*1.5) y(1,2)+(A*1.5)];
                maxx = max(xxx); maxy = max(yyy); minx = min(xxx); miny = min(yyy);
                IMG3 = imcrop(IMG_rotate,[minx miny maxx-minx maxy-miny]);clear IMG_rotate;
            end
            opBaseFileName = sprintf(strcat( '\\%d.','png'),t);
            opFullFileName = fullfile(opFolder, opBaseFileName);
            imwrite(IMG3, opFullFileName, 'png');
            clear opFullFileName opBaseFileName currFrame IMG3
        end
        
    end
    clear mov;
end
save false false