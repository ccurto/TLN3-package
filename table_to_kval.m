function [k idx123 K] = table_to_kval(M,perm_flag)

% function [k idx123 K] = table_to_kval(M,perm_flag)
% 
% M = chirotope table (entries are all +1/-1)
% perm_flag = 1 to return K (for all permutation-equiv tables),
%    otherwise 0 (default).
%
% function to input a 3x3 chirotope table and return the label k,
% the idx(123), and the labels K = [k,k1,...,kn] for all 
% permutation-equivalent tables (if perm_flag = 1)
%
% created by carina on dec 1, 2023

if nargin<2 || isempty(perm_flag)
    perm_flag = 0;
end

% load precomputed set of chirotope tables
load('chirotope_tables.mat','s_Mcell','TF_minus1','TF_plus1','TF_pm1')

% identify the k value (1...512) in the ordered set of chirotope tables
k = [];
for i = 1:length(s_Mcell)
    if sum(sum(abs(s_Mcell{i}-M))) == 0
        k = i;
    end
end

% identify idx(123)
idx123 = [TF_plus1(k),TF_minus1(k),TF_pm1(k)];

if perm_flag

% identify permutation-equivalent chirotope tables
sig_vec = [1 2 3;2 3 1;3 1 2;1 3 2;3 2 1;2 1 3];
K = zeros(1,6);

for j=1:6
    sig = sig_vec(j,:);
    Mj = M(sig,sig);
    for i = 1:length(s_Mcell)
        if sum(sum(abs(s_Mcell{i}-Mj))) == 0
            K(j) = i;
        end
    end
end

end