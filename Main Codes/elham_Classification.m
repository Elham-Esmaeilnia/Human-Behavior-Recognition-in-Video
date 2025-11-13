function eval_test = elham_Classification(data_te,class_names,d_mat,Tr)
% classification
% Elham Esmaeelnia Shirvani

rec = 0;
% set feature extraction parameters
% specify temporal resolutions (multiscale)
N_sq = [8, 10, 12];
% specify spatial resolution (single scale demo)
w = 24;
[n_class,~] = size(class_names);
% classify
disp('CLASSIFICATION');
disp('algortihm');
for j = 1:size(data_te,1)
    disp(j);
    fprintf(1,'Original class = %s \n', data_te{j,1});
    names = fieldnames(data_te{j,2});  
    for jj = 1:size(names,1)
        % get the test video
        V = double(data_te{j,2}.(names{jj,1}));
        
        % extract LMP features
        des = [];
        % loop for each temporal scale
        for k = 1:length(N_sq)
            % detect keypoints in the video 
            [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq(k), w);
            % compute descriptors
            p = lmpDes(Patch, Patch_sq, Pts_sq, N_sq(k));
            des = [des p]; 
        end
        
        % reduce dimenionality of the descriptors
        des = d_mat*des; 
        
        % classify using RSR %
        % parameters
        Tparams.data = des; 
        % concatenate all class-specific dictionaries
        D =[]; D = [D Tr{1,:}];
        Tparams.dict = D; 
        Tparams.Tdata = 12; 
        Tparams.Nclass = n_class;
        Tparams.thresh = 0.4; 
        
        Label = RSR(Tparams);% any algorithm for classification
        if(strcmp(class_names{Label,1},data_te{j,1})),rec=rec+1;end
        fprintf(1,'Classified as = %s \n \n', class_names{Label,1});
        
    end
end
%fprintf(1,'classification accuracy %d%% \n',rec*100/n_class);

%eval_test = rec*100/n_class;
eval_test = rec;
end