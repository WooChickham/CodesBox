clc;clear;close all;



%%

% place this .m file in video file
% The following content is divided into several sections,
% including different functions
% For example, .jpg ---> .avi means transfer JPG pictures into AVI videos

%% .jpg ---> .avi

% 'list_name' is a list containing all subfolder names
% Those subfolders are folders that contain JPG pictures
% list.txt should contain filenames like: 
% GOT-10k_Train_000001
% GOT-10k_Train_000002
% GOT-10k_Train_000003
% GOT-10k_Train_000004
% GOT-10k_Train_000005
% GOT-10k_Train_000006
% GOT-10k_Train_000007
% GOT-10k_Train_000008
% GOT-10k_Train_000009
list_name = 'list.txt';     
list = importdata(list_name);
for folder_index = 1 : length(list)
    folder_name = list{folder_index};
    % Change to the path of the folder
    folder_path = ['.\',folder_name];
    video_name = ['video_',folder_name];
    CreatVideoFromPic(folder_path,'jpg',video_name)
  
end

%% .avi ---> .mat(shifted frames)
% This part can transfer AVI videos to shifted frames stored in MAT files
% If you want to use this part, please note the below part
video_list=[];
for i = 1 : length(list)
    video_list = [video_list,list{i}];
end


H = 256; W = 256;   % The size of the frames expected to be generated
nF = 10;            % The number of the frames expected to be generated
num_loop = size(list,1);

for index = 1 : num_loop

    file_name = list{index};
    [rec_video]=chief_gen_dataset(H,W,nF,file_name);
    
    gen_name = [file_name,'.mat'];
    patch_save = rec_video;

    % the key name is 'patch_save', you can change it as you want
    save(['.\',gen_name],'patch_save');       
end


%% .avi ---> .mat(original frames)
% This part can transfer AVI videos to original frames stored in MAT files
% If you want to use this part, please note the above part
video_list=[];
for i = 1 : length(list)
    video_list = [video_list,list{i}];
end
H = 256; W = 256;
nF = 200;
num_loop = size(list,1);

for index = 1 : num_loop
    file_name = [list{index}];
    abs_path = ['F:\SummerProject_Train_Data\full_data\train_data\GOT_Videos_Dataset\',...
        'video_',file_name,'.avi'];
    [original_fr]=AVI2MAT(abs_path,H,W,nF);
    % If the number of video frames is less than the value of nF in this part, 
    % the mat file converted from this video will not be saved
    if original_fr == 0
        continue
    end
    
    gen_name = [file_name,'.mat'];
    patch_save = original_fr;
    
    % fill your desired file storage location
    save(['./',gen_name],'patch_save');       
end




%% function that transfer JPG pictures to AVI videos
function CreatVideoFromPic(dn, picformat,aviname)
% CreatVideoFromPic(dn, picformat,aviname)
% dn : Folder where pictures are stored
% picformat : picture form
% aviname   : File name of the stored video
% example : CreatVideoFromPic( './', 'png','presentation.avi');

    if ~exist(dn, 'dir')
        error('dir not exist!!!!');
    end
    picname=fullfile( dn, strcat('*.',picformat));
    picname=dir(picname);

    aviobj = VideoWriter(aviname);

    open(aviobj);

    for i=1:length(picname)
        picdata=imread( fullfile(dn, (picname(i,1).name)));
        if ~isempty( aviobj.Height)
            if size(picdata,1) ~= aviobj.Height || size(picdata,2) ~= aviobj.Width
                close(aviobj);
                delete( aviname )
                error('The size of all pictures must be the same!');
            end
        end
        writeVideo(aviobj,picdata);
    end
    close(aviobj);
end

%% function that transfer AVI to shifted frames
% 'chief_dataset_gen' generates the compressed frames from one video
% main compression algrithm is from Jinzhao's shared .m file and other part
% is from Qihang

function [rec_video] = chief_gen_dataset(H,W,cr,file_name)

[M_,N_] = deal(H,W);  % size of each frame
cr_val = cr;                % compression ratio
video_name = ['video_',file_name,'.avi'];
raw_video = [];


%%< import desired .avi file, edit `file_name_list` to change source
raw_file = struct2cell(importdata(video_name));
%%< exchange dimension to big-endian form: $264\times2\times1$
raw_file = permute(raw_file, [3, 1, 2]);
%%< pre-allocation for 3-D array
raw_video = cat(3, zeros([M_, N_, size(raw_file, 1)]), raw_video);
for index_0 = 1:size(raw_file, 1)
    %%< all RGB images are changed into gray scale in this stage
    %%< assign each cell element into 3-D array
    raw_video(:, :, index_0) = imresize(rgb2gray(raw_file{index_0, 1}), [M_, N_]);
end

% _*2.1. Initialization of Parameters and *_$\mathbf{TCA}$_ Matrices/Operations_

%%< the pre-defined compression ratio
raw_video(:, :, floor(size(raw_video, 3)/cr_val)*cr_val + 1:end) = [];
%%< for enlarging the video data set
%%< circ_num = 4;
%%< for index_circ = int64(size(raw_video, 3)/circ_num):int64(size(raw_video, 3)/circ_num):size(raw_video, 3)
%%<     raw_video = cat(3, raw_video, circshift(raw_video, [0, 0, index_circ]));
%%< end
%%< the T (vectorized, frame shifting and overlapping) operation
T_vec = (0:cr_val - 1)';
    %%< X-scaler
    T_scaler = 1; T_vec = T_vec*T_scaler;
%%< the C (vectorized, motion profile from calibration points on encoder) operation
C_vec = rand(cr_val, 1)*5;
C_vec((C_vec >= 1) & (C_vec < 2)) = -1; C_vec(C_vec < 1) = -2;
C_vec((C_vec >= 2) & (C_vec < 3)) = 0;
C_vec((C_vec >= 3) & (C_vec < 4)) = 1; C_vec(C_vec >= 4) = 2;
    %%< Y-scaler
    C_scaler = 1; C_vec = C_vec*C_scaler;
%%< the A (encoding pattern) operation as a binary matrix
A_mat = rand(size(raw_video,1));
A_mat(A_mat < 0.5) = 0; A_mat(A_mat >= 0.5) = 1;
% _*2.2. Perform Forward Model *_$\mathbf{y}=(\mathbf{TCA})\mathbf{x}+\mathbf{n}=\mathbf\Theta\mathbf{x}+\mathbf{n}$
% *$$< notice that both the input (*$\mathbf{x}$*) and output (*$\mathbf{y}$*) 
% are matrices here*
% 
% *$$< on the other hand, *$\mathbf{T}$* and *$\mathbf{C}$* are matrices shifting 
% in *$Y$* and *$X$* direction respectively*
% 
% _*2.2.1. *_$\mathbf{A}\times\mathbf{x}$_* Operation, Masking*_

%%< pre-allocation [M, N, F]
res_1 = zeros(size(raw_video));
for index_1 = 1:size(raw_video, 3)
    %%< directly apply the mask on data
    res_1(:, :, index_1) = raw_video(:, :, index_1).*A_mat;
end
%% 
% _*2.2.2. *_$\mathbf{C}\times(\mathbf{A}\times\mathbf{x})$_* Operation, Up-Down 
% Shifting (Y-shift)*_

%%< pre-allocation [M, N, F]
res_2 = zeros(size(raw_video));
for index_2 = 1:size(raw_video, 3)
    %%< shift up and down corresponding the C vector (y_shift)
    y_shift = C_vec(mod(index_2 - 1, cr_val) + 1);
    if y_shift ~= 0
        %%< if a Y-shift exist in current frame, perform Y-shifting
        res_2(:, :, index_2) = circshift(res_1(:, :, index_2), [y_shift, 0]);
        if y_shift > 0
            res_2(1:y_shift, :, index_2) = 0;
        else
            res_2(end + y_shift:end, :, index_2) = 0;
        end
    else
        res_2(:, :, index_2) = res_1(:, :, index_2);
    end
end
%% 
% _*2.2.3. *_$\mathbf{T}\times(\mathbf{C}\times\mathbf{A}\times\mathbf{x})$_* 
% Operation, Right Shifting (X-shift) and Overlapping*_

%%< pre-allocation [M, N + (CR - 1)*T_scaler, F]
res_3 = zeros(size(raw_video, 1), size(raw_video, 2)...
    + (cr_val - 1)*T_scaler, size(raw_video, 3));
for index_3 = 1:size(raw_video, 3)
    %%< shift towards right corresponding the T vector (x_shift)
    x_shift = T_vec(mod(index_3 - 1, cr_val) + 1);
    if x_shift ~= 0
        %%< if a X-shift exist in current frame, perform X-shifting
        res_3(:, :, index_3) = circshift(cat(2, res_2(:, :, index_3),...
            zeros(size(res_2, 1), (cr_val - 1)*T_scaler)), [0, x_shift]);
        res_3(:, 1:x_shift, index_3) = 0;
    else
        res_3(:, :, index_3) = cat(2, res_2(:, :, index_3),...
            zeros(size(res_2, 1), (cr_val - 1)*T_scaler));
    end
end
%%< pre-allocation [M, N + (CR - 1)*T_scaler, floor(F/CR)]
res_4 = zeros(size(raw_video, 1), size(raw_video, 2)...
    + (cr_val - 1)*T_scaler, floor(size(raw_video, 3)/cr_val));
for index_4 = 1:size(res_4, 3)
    %%< overlap each frame corresponding to compression ratio
    for index_5 = 1:cr_val
        %%< X-shift obtained by vectorized T
        x_shift = T_vec(index_5);
        %%< matrix addtion applied for corresponding indices position
        res_4(:, :, index_4) = res_4(:, :, index_4) +...
            res_3(:, :, (index_4 - 1)*cr_val + index_5);
    end
end

% _*2.2.4. Applying Noise *_$(\cdot)+\mathbf{n}$_* and Assign to Received Video
% Data*_

%%< assign (Gaussian, zero-mean, -5~5) addictive random matrices
%%< on the generated data/video (by the 3-sigma principle)
mu_ = 0;
sigma_ = (5 - mu_)/3;
norm_noise = normrnd(mu_, sigma_, size(res_4));
%%< apply on the received data as final result
rec_video = res_4 + norm_noise;
for index_0_previous = 1 : size(rec_video,3)
    rec_video(:, :, index_0_previous) = rec_video(:, :, index_0_previous)...
    ./max(max(rec_video(:, :, index_0_previous)));

end

end

%% function that transfers AVI to original frames
function [mat_file]=AVI2MAT(filename,H,W,nF)
mat_file = 0;
video_OBJ = VideoReader(filename);
if video_OBJ.NumFrames < nF
    return;
end

mat_file=zeros(H, W);

% read frame k, convert to gray img, 3D array
for k = 1 : nF
      imgdata=read(video_OBJ,k);
      graydata=imresize(rgb2gray(imgdata),[H,W]);
      mat_file(:,:,k)=double(graydata)./255;
end

end





