function Label = RSR(params)

% This function implements a classification algorithm known as the Randon
% Sample Reconstruction (RSR).
%--------------------------------------------------------------------------
% INPUT: 
% params.data = an M x N array with vectorized patches in columns, where M
%               is the dimension of an input patch and N is the number of
%               patches.
% params.dict = an M x K array formed by concatenating all class-specific 
%               dictionaries learned.
% params.Tdata = sparsity constant for OMP
% params.Nclass = number of dictionaries = number of classes
% params.thresh = error threshold
% params.iter = maximum number of iterations
%
% OUTPUT:
% Label = a scalar value indicating class label
%
% Use:
% params.data = P; params.dict = D; params.Tdata = 8, params.Nclass = 10;
% params.thresh = 0.4; Label = RSR(params);
%--------------------------------------------------------------------------
% Author: T. Guha, ECE, UBC
% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%-------------------------------------------------------------------------

% CHECK/GET REQUIRED INPUTS

% patch vectors
if (~isfield(params,'data'))
    error('no data to classify');
else
    P = params.data;
    P = normc(P);
end

% dictionaries
if (~isfield(params,'dict'))
    error('need dictionaries');
else
    D = params.dict;
end

% sparsity constraint
if (~isfield(params,'Tdata'))
    S = ceil(0.1*size(P,1)); % default
else
    S = params.Tdata;
end

% number of classes
if (~isfield(params,'Nclass'))
    error('specify number of classes');
else
    cls = params.Nclass;
    % number of elements in a dictionary 
    %(assuming all dictionaries are of same size)
    Dind = size(D,2)/cls;
    if(rem(size(D,2),cls)~=0)
        error('number of basis in a dictionary must be an integer');
    end
end

% error threshold
if (~isfield(params,'thresh'))
    thresh = 0.5;
else
    thresh = params.thresh;
end

% maximum iterations
if (~isfield(params,'iter'))
    params.iter = 200;
end
MaxK = params.iter + 1;

% INITIALIZE 

% size of the random subset = 1% of the total number of inputs
ProbInlier = ceil(size(P,2)*0.01);

% number of inlisers
Inliers = 0;

% parameter w = probability of selecting a good datapoint
w = (ProbInlier + Inliers)/length(P);

% probability with which the final solution should converge
prob = 0.9;

% no. of trials
Lambda = Inf;

while Lambda > 0      
    % select random datapoints to construct the subset
    Rd = randperm(size(P,2));
    Psub = P(:,Rd(1:ProbInlier));

    % solve the optimization problem (OMP)
    %** This part needs OMPbox **%
    Sim = zeros(1,cls);
    for n = 1:cls
        Dn = D(:,(n-1)*Dind+1:n*Dind);
        xn = omp(Dn'*Psub,Dn'*Dn,S); % 'omp' is a part of the OMPBox
        Sim(1,n) = norm(Psub - Dn*xn);
    end
    
    % choose the temporary label as the label of the dictionary that
    % produces the min error for the subset
    [~, ind] = min(Sim);
    Dprob = D(:,(ind-1)*Dind+1:ind*Dind);  
    
    % count data points that agree with the chosen label
    % select those datapoints for which the reconstruction error is below
    % some thershold
    Prest = P(:, Rd(ProbInlier+1:size(P,2)));
    X = omp(Dprob'*Prest,Dprob'*Dprob,S);
    Res = Prest - Dprob*X;
    % threshold
    R = zeros(n,1);
    for n = 1:size(Prest,2)
        R(n,1) = norm(Res(:,n));
    end    
    R = R<=thresh;
    count = nnz(R);
        
    % compare the number of inliers for the previous label and the current
    % label
    if (Inliers<count)
        Inliers = count;
        Label = ind;
        w = (ProbInlier + Inliers)/size(P,2);
        Lambda = round(log(1-prob)/log(1-w^ProbInlier));
    else
        Lambda = Lambda - 1;
    end
    if (MaxK==1)
         break
    else
        MaxK = MaxK-1;
    end
end

% display results
if (MaxK==1) 
    disp('reached maximum number of iterations');
    fprintf(1,'solution has probability lower than %f \n', prob);
    fprintf(1,'class label = %d \n',Label);   
else
    fprintf(1,'class label = %d \n', Label);
    fprintf(1,'converged with probability %f \n', prob);
    fprintf(1,'iterations = %d \n',params.iter + 1 - MaxK);
end
 

