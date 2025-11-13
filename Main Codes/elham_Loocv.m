%% Results
%Elham Esmaeelnia Shirvani
clear all; close all; clc;
load('el_Weizemann');
%%
% Weizemann dataset
temp = Wi_data;
[num_classes,~] = size(temp);
class_fname = cell(num_classes,1);
for i=1:num_classes
class_fname{i,1} = temp{i,1};
end

%%
for i=1:num_classes
max_V(i) = length(fieldnames(temp{i,2}));
end
max_v = max(max_V);
for i=1:num_classes
    [num_sbj,~] = size(fieldnames(temp{i,2}));
    V_test{1,1} = temp{i,1};
    eval = [];
    for j=1:num_sbj
        V_train = temp;
        Vl_name = fieldnames(temp{i,2});
        V_test{1,2}.(Vl_name{j,1}) = temp{i,2}.(Vl_name{j,1});
        V_train{i,2} = rmfield(V_train{i,2},Vl_name{j,1});
        %classificaton
        des_result = elham_MakeDes(V_train,max_v,num_classes);
        [dict,ran_mat] = elham_DicLearning(des_result,num_classes);
        eval(j) = elham_Classification(V_test,class_fname,ran_mat,dict);
        %
        V_test{1,2} = rmfield(V_test{1,2},Vl_name{j,1});
    end 
    result(i) = sum(eval)/num_sbj;
end
%% Final result
final_result = sum(result(i))/num_classes;