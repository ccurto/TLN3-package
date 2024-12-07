function [M idx123 k Mext] = get_chirotope_table(W)

% function [M idx123 k Mext] = get_chirotope_table(W)
%
% W = 3x3 matrix for TLN on n=3 nodes
% M = 3x3 chirotope table
% idx123 = idx(123), the 10th "free" chirotope element not in the table
% k = number corresponding to chirotope table in sorted set of 512 tables
% Mext = 6x4 extended chirotope table, adding elements with q = [1 1 1]'.
% 
% created by carina on nov 28, 2023
% updated dec 17, 2023 to use table_to_kval.m
% updated dec 27, 2023 to compute extended chirotope table Mext
%    and remove kflag, which isn't used.

n = size(W,1);
if n~=3
    error('W needs to be 3x3')
end

% make the vectors for the chirotope
U = eye(3)-W;
u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
e1 = [1 0 0]';
e2 = [0 1 0]';
e3 = [0 0 1]';
q = [1 1 1]';

% make the chirotope table
M = zeros(3);
M(1,1) = sign(det([e1,u2,u3])); % idx(23)
M(1,2) = sign(det([e2,u2,u3]));
M(1,3) = sign(det([e3,u2,u3]));
M(2,1) = sign(det([u1,e1,u3]));
M(2,2) = sign(det([u1,e2,u3])); % idx(13)
M(2,3) = sign(det([u1,e3,u3]));
M(3,1) = sign(det([u1,u2,e1]));
M(3,2) = sign(det([u1,u2,e2]));
M(3,3) = sign(det([u1,u2,e3])); % idx(12)

% finally, compute idx(123) = sgn det(u1,u2,u3)
idx123 = sign(det([u1,u2,u3]));

% identify the k value (1...512) in the ordered set of chirotope tables
k = table_to_kval(M);

% make extended chirotope table - new on 12/27/23
Mext = zeros(6,4);
Mext(1:3,1:3) = M; % copy over the small chirotope table
Mext(1,4) = sign(det([q,u2,u3]));
Mext(2,4) = sign(det([u1,q,u3]));
Mext(3,4) = sign(det([u1,u2,q]));
Mext(4,1) = sign(det([q,u1,e1]));
Mext(5,1) = sign(det([q,u2,e1]));
Mext(6,1) = sign(det([q,u3,e1]));
Mext(4,2) = sign(det([q,u1,e2]));
Mext(5,2) = sign(det([q,u2,e2]));
Mext(6,2) = sign(det([q,u3,e2]));
Mext(4,3) = sign(det([q,u1,e3]));
Mext(5,3) = sign(det([q,u2,e3]));
Mext(6,3) = sign(det([q,u3,e3]));
