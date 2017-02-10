clear;close all;fclose all ;clc;
VID_Type = 'avi';
load('FirstImpressionsV2.mat');
VID_NUM = length(data);
DIR = 'faces\\';
IMG_Type = 'png';
Features={'LBP','LPQ','BSIF'};
Space = {'YCbCr','Lab','RGB','Grey'};
tic
for num_blocks = 7
for F =2
for pas = 1
for thresh=1
for co = 4%:size(Space,2)
filename=sprintf('%s_params',Features{F});
load(filename)
for chanell = 1%:3
for EFF=450
frame = EFF;
for imsize =128
    for jj = 4%:size(params,2)
        tic
        opFolder = fullfile(cd, 'Feature');
        if ~exist(opFolder, 'dir')
            mkdir(opFolder);
        end
        for i=1:VID_NUM
            disp(i)
            eeee=[DIR,num2str(data(i).video),'\*.',IMG_Type];
            files=dir(eeee);clear eeee;
            if EFF>numel(files)
                frame = numel(files);
            end
            for y1=2:pas:frame;
                imgname = sprintf(strcat(DIR, '\\',num2str(data(i).video)...
                    ,'\\%d.',IMG_Type),y1-1);        
                Previous=imread(imgname);
                Previous = rgb2gray(Previous);
                Previous=imresize(Previous(:,:,chanell),[imsize imsize]);
                imgname = sprintf(strcat(DIR, '\\',num2str(data(i).video)...
                    ,'\\%d.',IMG_Type),y1);
                curentr=imread(imgname);
                curentr = rgb2gray(curentr);
                curentr=imresize(curentr(:,:,chanell),[imsize imsize]);
                img = frame_difference(Previous,curentr,thresh);
                clear curentr Previous;
                if(strcmp(Features{F},'LBP'))
                    filename=sprintf('mapping_%d',params(jj).b);
                    load(filename);
                    name = sprintf('Feature/LBP_block_FD_%d_%d_%d_%d_%d_%d_%d_%s_%d',num_blocks,imsize,pas,thresh,params(jj).a,params(jj).b,params(jj).c,Space{co},chanell);
                    mapp = params(jj).b * (params(jj).b -1) + 3;
                    I=lbp(img,params(jj).c,params(jj).b,mapping,'i');
                    feature = Multi_block(I,num_blocks,mapp);
                elseif(strcmp(Features{F},'LPQ'))
                    name = sprintf('Feature/LPQ_block_FD_%d_%d_%d_%d_%d_%d_%d_%s_%d',num_blocks,imsize,pas,thresh,params(jj).a,params(jj).b,params(jj).c,Space{co},chanell);
                    I = lpq(img,params(jj).a,params(jj).b,params(jj).c,'im');
                    feature = Multi_block(I,num_blocks,256);
                elseif(strcmp(Features{F},'BSIF'))
                     filename=sprintf('texturefilters/ICAtextureFilters_%dx%d_%dbit',params(jj).a,params(jj).b,params(jj).c);
                     load(filename, 'ICAtextureFilters');                     
                     name = sprintf('Feature/BSIF_block_FD_%d_%d_%d_%d_%d_%d_%d_%s_%d',num_blocks,imsize,pas,thresh,params(jj).a,params(jj).b,params(jj).c,Space{co},chanell);
                     numScl=size(ICAtextureFilters,3);%length(scl);
                     mapp = 2^numScl;
                     I= bsif(img,ICAtextureFilters,'im');                                     
                     feature = Multi_block(I,num_blocks,mapp);
                end
                 featureVector_all(y1,1:numel(feature)) = feature;
                 clear img I feature;
            end
            featureVector_mean = mean(featureVector_all);clear featureVector_all;
            FTRS(i,1:numel(featureVector_mean)) = featureVector_mean;clear featureVector_mean;
        end
        save(sprintf('%s.mat',name),'FTRS','-v7.3');clear FTRS;
        fprintf('%s \n',name);
        toc
        clear FTRS      
    end
end
end
end
end
end
end
end
end