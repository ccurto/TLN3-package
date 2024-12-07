function [seq_vec,seqC,t_idx,C] = find_nullchambers(X);

% function [seq_vec,seqC,t_idx,C] = find_nullchambers(X)
%
% X = solution trajectory, T x n, where n = # neurons and T = # time steps
%     can use soln.X or output of threshlin_ode
%
% seq_vec = vector of seqC chambers turning binary into decimal 
%           to get a single integer for each chamber (for comparisons)
% seqC = a submatrix of C with full sequence of chambers = C(t_idx,:)
% t_idx = time step indices at which chamber switches
% C = binary matrix of same size as X, each row has 0/1 to denote -/+
%
% example: 0 0 1 0 1 indicates the nullcline chamber where
%     the solution is on the + side of the 3 and 5 nullclines and
%     on the - side of the others, so only x_3 and x_5 have + derivative
%
% created Aug 8, 2020
% last modified Oct 10, 2020, to simplify and just find for whole soln

% compute nullcline chambers
dX = diff(X); % produces row differences (time derivatives)
dX = [dX(1,:); dX]; % repeat first row so time length matches X
C = dX>0; % make binary matrix w/ a "1" for each + derivative, 0 otherwise

% find time indices at which the chambers switch
dC = diff(C);
dC = [dC(1,:); dC]; 
t_idx = find(sum(abs(dC),2)>0); % chamber switching times

% add start and end to t_idx, then find the sequence of chambers seqC
t_idx = [1;t_idx;size(X,1)];
seqC = C(t_idx,:);

% make vector with an integer for each chamber, using binary->decimal,
seq_vec = bin2dec(int2str(seqC))';