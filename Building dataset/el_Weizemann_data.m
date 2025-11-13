%% Wiezemann Dataset
% Elham Esmaeelnia Shirvani

clear all; close all; clc;

%% 
datapath = 'Weizemann\';
Wi_name = ls(strcat(datapath,datapath));
Wi_orig = load(strcat(datapath,datapath,Wi_name(3,:)));
% 
% get alighgned data...
%
%%
load('WISdemo.mat');
Wi_data = WIStrain;
for i=1:10
    temp = fieldnames(Wi_data{i,2});
    temp(end+1,1) = fieldnames(WIStest{i,2});
    Wi_data{i,2}.(temp{end,1}) = WIStest{i,2}.(temp{end,1});
end

