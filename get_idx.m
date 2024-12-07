function [idx sigma] = get_idx(W,sigma)

% function [idx sigma] = get_idx(W,sigma)
%
% W = matrix for TLN
% sigma = single subset of {1,...,n} or cell array of supports
%
% idx = vector of indices, one per support, where
%       index(sigma) = sgn det(I-W_sigma) is the index associated 
%       to a fixed point with support sigma
% sigma = output cell array with sigmas (supports), 
%         even if input sigma wasn't a cell array
% note: idx(i) is the index for sigma{i}
% 
% this function returns indices associated to all possible fixed point
%   supports of a TLN with connectivity matrix W.
% note: the index does *not* depend on b, but the existence and position
%   of the fixed point with support sigma does depend on b.
%
% created by carina on jun 25, 2022

n = size(W,1);

% create cell array sigma with all subsets if nothing is passed
if nargin < 2 || isempty(sigma)
    j = 1;
    for k=1:n
        sets=nchoosek(1:n,k); % create all the subsets of 1..n of size k
        for i=1:size(sets,1)
            sigma{j} = sets(i,:);
            j = j+1;
        end
    end
end

% cycle through cell array of sigmas, or just get index for single sigma
if iscell(sigma)
    for i=1:length(sigma)
        sig = sigma{i};
        idx(i) = sign(det(eye(length(sig))-W(sig,sig)));
    end
else
    sig = sigma;
    idx = sign(det(eye(length(sig))-W(sig,sig)));
    sigma = {sig}; % return a cell array of length 1, for consistency
end