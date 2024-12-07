function [Uproj Pinv binv] = proj2simplex(U)

% function [Uproj Pinv binv] = proj2simplex(U)
% 
% U = [u1 u2 ... uN] is a 3xN matrix of 3-d column vectors ui
%
% Uproj = [u1_proj u2_proj ... uN_proj] is a 2xN matrix where
%         each 3-d vector u1 has been projected to the unit simplex
% [Pinv,binv] = matrix and affine shift for inverting the transform
%         P^-1(x) = Pinv*x + binv, for x in 2-d simplex
%         and P*P^-1(x) = x
%
% created by Carina on june 22, 2022
% updated july 1, 2022, to return a pseudoinverse for P
% updated by carina on mar 26, 2024 to fix the pseudoinverse for P


% define 2x3 projection matrix from R^3 to sum x_i = 1 simplex
P = [-sqrt(3)/2 sqrt(3)/2 0; -1/2 -1/2 1];

% define Pinv,binv
Pinv = [-1/sqrt(3) -1/3; 1/sqrt(3) -1/3; 0 2/3];
binv = [1/3 1/3 1/3]';

% compute all projections
Uproj = P*U;