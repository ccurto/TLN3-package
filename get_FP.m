function [FP,FP_str,fixpts,idx] = get_FP(W,b,print_flag)

% function [FP,FP_str,fixpts,idx] = get_FP(W,b,print_flag)
%
% (W,b) define the TLN, as usual; b = ones(n,1) by default
% print_flag = 1 to print FP(W,b) and |FP(W,b)| (size)
%
% FP = cell array with all fixed point supports, 
%      e.g., FP{1} = [1 2 3], FP{2} = [2 4] => FP(W,b) = {123,24}
% FP_str = string that gets printed with print_flag
% fixpts = matrix whose rows are the actual fixed points
%          fixpts(i,:) is the i-th fixed point with support FP{i}
% idx = column vector s.t. idx(i) is the index of the i-th fixed point
%
% this is a wrapper for "get_fixedpt", which inputs (W,b,sig).
% here we only input (W,b) as we want all fixed points
%
% created by carina on june 20, 2024

n = size(W,1);

if nargin < 2 || isempty(b)
    b = ones(n,1);
end

if isscalar(b)
    b = b*ones(n,1);
end

if nargin < 3 || isempty(print_flag)
    print_flag = 1;
end

% compute FP(W,b) and save actual fixed points x_fp in fixpts array

FP = cell([]); % initialize as empty cell array
fixpts = [];
idx = [];
j = 0; % counts number of fixed points found

for k=1:n
    sets=nchoosek(1:n,k); % create all the subsets of 1..n of size k
    for i=1:size(sets,1)
        sig = sets(i,:);
        [x_fp,y_fp,tau,TF] = get_fixedpt(W,b,sig);
        if TF
            j = j+1;
            FP(j) = {sig};
            fixpts = [fixpts; x_fp'];
            idx(j) = sign(det(eye(length(sig))-W(sig,sig)));
        end
    end
end

% make FP string and print, along with |FP(W,b)|, if print_flag = 1

N = length(FP); % number of fixed points
if N == 0
    FP_str = 'FP(W,b) = emptyset';
else
    FP_str = ['FP(W,b) = {'];
    for i=1:N-1
        FP_str = [FP_str '[' int2str(FP{i}) ']'];
        if idx(i) == 1
            FP_str = [FP_str '^+,'];
        else
            FP_str = [FP_str '^-,'];
        end
    end
    FP_str = [FP_str '[' int2str(FP{N}) ']'];
    if idx(N) == 1
        FP_str = [FP_str '^+}'];
    else
        FP_str = [FP_str '^-}'];
    end
end

if print_flag
    fprintf([FP_str '\n']);
    fprintf(['|FP(W,b)| = ' int2str(N) '\n']);
end