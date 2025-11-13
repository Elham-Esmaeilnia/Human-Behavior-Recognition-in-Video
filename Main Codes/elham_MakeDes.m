function   final_des = elham_MakeDes(data_tr,Max_nV,num_class)

% Make Descriptors
% Elham Esmaeelnia Shirvani

%% Set Parameters

Des_row = Max_nV + 1; % Maximum number of Video in each class 
Des_col = num_class; % number of classes

% specify temporal resolutions (multiscale)
N_sq = [8, 10, 12];
% specify spatial resolution (single scale demo)
w = 24;

% initialize cell structure to store descriptors
DesTr = cell(Des_row,Des_col);

%% extract features from each video
disp('*TRAINING*');
disp('Extracting features ...');
for j = 1:size(data_tr,1)
    disp(data_tr{j,1});
    names = fieldnames(data_tr{j,2});  
    DesTr{1,j}= char(data_tr{j,1});
    for jj = 1:size(names,1)
        % get the clip
        fprintf(1,'video %d \n',jj);
        V = double(data_tr{j,2}.(names{jj,1}));
        des = [];
        % loop for each temporal scale
        for k = 1:length(N_sq)
            % detect keypoints in the video 
            [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq(k), w);
            % compute descriptors
            p = lmpDes(Patch, Patch_sq, Pts_sq, N_sq(k));
            des = [des p]; 
        end
        fprintf(1,'computed %d descriptors! \n', size(des,2));
        DesTr{jj+1,j} = des;
    end
 end
final_des = DesTr;
end