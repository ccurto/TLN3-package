function [seq_vec,seqC,t_idx,C] = find_linchambers(Y)

% function [seq_vec,seqC,t_idx,C] = find_linchambers(Y)
%
% Y = T x n matrix of y vectors, where each y = Wx+b is the argument
%     inside [ ]_+, and n = # neurons, T = # time steps
%     -> can use soln.Y output of threshlin_ode
%
% seq_vec = vector of seqC chambers turning binary into decimal 
%           to get a single integer for each chamber (for comparisons)
% seqC = a submatrix of C with full sequence of chambers = C(t_idx,:)
% t_idx = time step indices at which chamber switches
% C = binary matrix of same size as Y, each row has 0/1 to denote -/+
%
% example: 0 0 1 0 1 indicates the linear chamber where
%     the solution is on the + side of the 3 and 5 hyperplanes and
%     on the - side of the others
%
% created by carina on apr 18, 2024, to track linear chambers of a TLN
% (based on the oct 10, 2020 version of find_nullchambers.m)
%
% updated on apr 20, 2024 to add comments about numbering all + and
% all - chambers.

% compute linear chambers, each row is chamber codeword for a time step
C = Y>0; % make binary matrix tracking chamber membership

% find time indices at which the chambers switch
dC = diff(C);
dC = [dC(1,:); dC]; 
t_idx = find(sum(abs(dC),2)>0); % chamber switching times

% add start and end to t_idx, then find the sequence of chambers seqC
t_idx = [1;t_idx;size(Y,1)];
seqC = C(t_idx,:);

% make vector with an integer for each chamber, using binary->decimal
% note: bin2dec(int2str([1 1 1])) = 7, so all + is chamber 2^n-1,
% while bin2dec(int2str([0 0 0])) = 0, so all - is chamber 0.
seq_vec = bin2dec(int2str(seqC))';