function [W,class_str,sA,graph_str,k,idx123] = get_Wchir_graph(U)

% function [W,class_str,sA,graph_str,k,idx123] = get_Wchir_graph(U)
% 
% U = 3x3 matrix, columns in the positive orthant
%     not necessarily scaled to have 1's on the diagonal
% W = corresponding W matrix, for U = I-W, where U has 1s on diag
%     so this is the W for a TLN with W_ii = 0
% class_str = chirotope class label ('P12','M2', etc.)
% sA = graph, given as a binary adjacency matrix
% graph_str = graph label ('g1', 'g2', etc.)
%
% created by carina on mar 28, 2024
% calls: get_Ugraph.m, get_chirotope_table.m, kval_to_equiv_class.m
% updated on mar 30, 2024 to return graph_str
% updated on july 14, 2024 to return chirotope table number k and idx123

n = size(U,1);
if n ~= size(U,2) || n ~= 3
    error('U is not 3x3!')
end

% compute W
% normalize cols so U matrix has 1s on diagonal
for j=1:n
    U(:,j) = U(:,j)/U(j,j);
end
W = eye(n)-U;

% get chirotope and class_str
[M,idx123,k] = get_chirotope_table(W);
class_str = kval_to_equiv_class(k,idx123);

% load all 16 n=3 graphs, record all 6 permuations
load('n3_digraphs.mat','sAcell');
sig_vec = [1 2 3;2 3 1;3 1 2;1 3 2;3 2 1;2 1 3]; % perms

% get graph and graph number (1-16)
sA = get_Ugraph(U);
for j=1:size(sig_vec,1)
    perm = sig_vec(j,:);
    Gj = sA(perm,perm);
    for l=1:length(sAcell)
        if Gj == sAcell{l}
              graph_str = ['g' int2str(l)];
        end
    end
end