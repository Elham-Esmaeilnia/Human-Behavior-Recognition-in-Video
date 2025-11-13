function Label = concat(params)

% This function implements a concatenated ditionary based classification.
%--------------------------------------------------------------------------
% INPUT: 
% params.data = an M x N array with vectorized patches in columns, where M
%               is the dimension of an input patch and N is the number of
%               patches.
% params.dict = an M x K array formed by concatenating all class-specific 
%               dictionaries learned.
% params.Tdata = sparsity constant for OMP
% params.Nclass = number of dictionaries = number of classes
%
% OUTPUT:
% Label = a scalar value indicating class label
%
% Use:
% params.data = P; params.dict = D; params.Tdata = 8, params.Nclass = 10;
% Label = concat(params);
%--------------------------------------------------------------------------
% Author: T. Guha, ECE, UBC
% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%-------------------------------------------------------------------------

% patch vectors
if (~isfield(params,'data'))
    error('no data to classify');
else
    P = params.data;
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

% initialize
 Sim = zeros(1,cls);

% solve the sparse optimization problem (OMP)
%** This part needs OMPbox **%
X = omp(D'*P,D'*D,S);

% count number of non-zeros associate with each dictionary coefficients
for n = 1:cls
    Xn = X((n-1)*Dind+1:n*Dind,:);
    Sim(1,n) = nnz(Xn);
end
    
% choose the dictionary associated with max number of non-zeros
[~, Label] = max(Sim);
        
% display result
fprintf(1,'class label = %d \n', Label);


