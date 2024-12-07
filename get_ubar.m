function ubar = get_ubar(u,idx)

% function ubar = get_ubar(u,idx)
% 
% u = a vector in R^n (typically n=3), like a column of I-W matrix
% idx = coordinate to be zeroed out
%       if empty, don't zero anything out and just return ubar
%       as the normalized projected point on the simplex
%
% ubar = a vector obtained by zeroing out u(idx)
%        and normalizing to put on unit simplex, sum x_i = 1,
%        then projecting onto 2-d picture of simplex
%
% calls: proj2simplex
%
% created by Carina on june 22, 2022
% updated jun 30, 2022 to allow idx = [], return interior point

if nargin < 2 
    idx = [];
end

if ~isempty(idx)
    u(idx) = 0; % zero out chosen coordinate
end

ubar = u/sum(u); % normalize to put on simplex
ubar = proj2simplex(ubar);