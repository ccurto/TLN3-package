function sA = get_Ugraph(U)

% function sA = get_Ugraph(U)
%
% U = I-W, matrix that feeds into chirotope
%     we can also use a scaled version of U = [u1 u2 ... un]
%     provided relative ordering within each column ui is preserved
%
% sA = adjacency matrix for graph G
%
% in the graph G:
% j -> i iff (uj)_i < (uj)_j (i.e., U_ij > U_jj); in this case sA(i,j) = 1.
% we forbid self loops, so sA(j,j) = 0 for all j.
% finally, in the case of ties, U_ij = U_jj, then sA(i,j) = 0.5.
%
% created by carina on dec 19, 2023

n = size(U,1);
sA = zeros(n);

for j=1:n
    for i=1:n
        if U(i,j) < U(j,j)
            sA(i,j) = 1;
        else 
            if U(i,j) == U(j,j) && i ~= j
                sA(i,j) = 0.5;
            end
        end
    end
end