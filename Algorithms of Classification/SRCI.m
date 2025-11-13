function Label = SRCI(params)

%------------ SRC-I Classification ------------------------
%INPUT: 
% params.data = an M x N array with vectorized patches in columns, where M
%               is the dimension of an input patch and N is the number of
%               patches.
% params.dict = an M x K array formed by concatenating all class-specific 
%               dictionaries learned.
% params.Tdata = sparsity constant for OMP
% params.Nclass = number of dictionaries = number of classes
%----------------------------------------------------------

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

%%-------------- Initialize -----------------------------

n = size(P,2);
count = zeros (1,cls);
for i=1:n
   xi = P(:,i);
   % solve the sparse optimization problem (OMP)
   %** This part needs OMPbox **%
   yi = omp(D'*xi,D'*D,S);
   for k=1:cls
       Sigma_k = zeros (size(D,2),1);
       Sigma_k((k-1)*Dind+1:k*Dind,1) = yi((k-1)*Dind+1:k*Dind,1);
       rk(k) = norm(D*Sigma_k - xi);
   end  
   [~,ind] = min (rk); 
   C_star(i) = ind;
   count(1,ind) = count(1,ind)+1;
end

[~,C_star] = max(count);

Label =  C_star;
end