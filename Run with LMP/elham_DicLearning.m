function [Tr,R] = elham_DicLearning(DesTr,num_class)
% Dictionary Learning
% Elham Esmaeelnia Sirvani

R = randn(128,1728);
R = normc(R);
nclass = num_class;
% Initialize
Tr = cell(1,nclass);
row = size(DesTr,1);
% loop for each class
disp('TRAINING');
disp('Learning class-specific dictionaries ...');
for j = 1:nclass
    fprintf(1,' class %s \n', DesTr{1,j});
    % collect all descriptors from a class
    Y = [];
    Y = [Y DesTr{2:row,j}];
     
    % remove mean
    Y = Y - repmat(mean(Y,2),[1,size(Y,2)]);     
    
    % reduce dimensionality by random projection
    Y = R*Y;
    
    % learn dictionary using KSVD algorithm
    % ** requires KSVDbox and OMPbox ** %
    params.iternum = 20;
    params.data = Y;
    params.dictsize = size(Y,1)*2; % overcompleteness factor 2
    params.Tdata = 12;
    [D,X] = ksvd(params); % to mute this function use  ksvd(params,'');
    Tr{1,j} = D;
end

end