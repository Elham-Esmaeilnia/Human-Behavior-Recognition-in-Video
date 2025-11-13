%% UCF Dataset
% Elham Esmaeelnia Shirvani

clear all; close all; clc;

%% UCF Dataset
datapath = 'UCF-Sport\';
list = ls(datapath);
[num,~] = size(list);
d = cell(num-2,2);      % Whole UCF Dataset
for i=3:num
    sub_list = ls(strcat(datapath,list(i,:),'\',list(i,:),'\'));
    [sub_num,~] = size(sub_list);
    for j=3:sub_num
     d{i-2,1} = list(i,:);
     V_col = load(strcat(datapath,list(i,:),'\',list(i,:),'\',sub_list(j,:)));
     [rv,cv] = size(V_col.tmpVideo);
     rv = sqrt(rv);
     V = reshape(V_col.tmpVideo,rv,rv,cv);
     d{i-2,2}.(strcat('data_',num2str(j-2)))= V;
    end
end
%% UCF With 9 class
%% class 1
ucf_data = cell(9,2);
ucf_data{1,1} = d{1,1};
ucf_data{1,2} = d{1,2};
%% class 2
ucf_data{2,1} = 'Golf-Swinging';
ucf_data{2,2} = d{2,2};
r2 = size(fieldnames(d{2,2}),1);
r3 = size(fieldnames(d{3,2}),1);
r4 = size(fieldnames(d{4,2}),1);
for i=r2+1:r2+r3
ucf_data{2,2}.(strcat('data_',num2str(i))) = d{3,2}.(strcat('data_',num2str(i-r2)));
end

for i=r2+r3+1:r2+r3+r4
ucf_data{2,2}.(strcat('data_',num2str(i))) = d{4,2}.(strcat('data_',num2str(i-(r2+r3))));
end
%% class 3
ucf_data{3,1} = 'Kicking';
ucf_data{3,2} = d{5,2};
r5 = size(fieldnames(d{5,2}),1);
r6 = size(fieldnames(d{6,2}),1);
for i=r5+1:r5+r6
ucf_data{3,2}.(strcat('data_',num2str(i))) = d{6,2}.(strcat('data_',num2str(i-r5)));
end

%% class 4
ucf_data{4,1} = d{7,1};
ucf_data{4,2} = d{7,2};
%% class 5
ucf_data{5,1} = d{8,1};
ucf_data{5,2} = d{8,2}
%% class 6
ucf_data{6,1} = d{9,1};
ucf_data{6,2} = d{9,2}
%% class 7
ucf_data{7,1} = d{10,1};
ucf_data{7,2} = d{10,2}
%% class 8
ucf_data{8,1} = 'Swinging';
ucf_data{8,2} = d{11,2};
r11 = size(fieldnames(d{11,2}),1);
r12 = size(fieldnames(d{12,2}),1);
for i=r11+1:r11+r12
ucf_data{8,2}.(strcat('data_',num2str(i))) = d{12,2}.(strcat('data_',num2str(i-r11)));
end
%% class 9
ucf_data{9,1} = d{13,1};
ucf_data{9,2} = d{13,2}



%% raw Descriptor
for j = 1:size(d,1)
    disp(d{j,1});
    names = fieldnames(d{j,2});  
    UCF_DesTr{1,j}= char(d{j,1});
    for jj = 1:size(names,1)
        % get the clip
        fprintf(1,'video %d \n',jj);
        V = double((d{j,2}.(names{jj,1}))); % each video in each class
        UCF_DesTr{jj+1,j} = V;
    end
end
%%