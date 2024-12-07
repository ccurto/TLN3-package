function P = get_Rsigma(W,sigma)

% function P = get_Rsigma(W,sigma)
% 
% W = matrix for the TLN, output of graph2net(sA,e,d)
% sigma = subset of [1,2,3] defining R_sigma region
%
% P = 2xk matrix whose columns are projected coordinates of 
%     the points bounding the R_sigma region in the standard simplex
%
% calls: get_ubar, proj2simplex
% 
% created by Carina on june 22, 2022
% updated jun 30, 2022 to make more readable

% U = I-W, columns of U are the ui vectors defining the cones Rsigma
U = eye(3)-W; 

% project ui's to 2d simplex picture
u1 = get_ubar(U(:,1));
u2 = get_ubar(U(:,2));
u3 = get_ubar(U(:,3));

% define standard unit vectors (corners of simplex)
e1 = proj2simplex([1 0 0]');
e2 = proj2simplex([0 1 0]');
e3 = proj2simplex([0 0 1]');

% get points on boundary of simplex: uij comes from line(ui,ej)
% these are already projected onto 2d simplex picture
u12 = get_ubar(U(:,1),2);
u13 = get_ubar(U(:,1),3);
u21 = get_ubar(U(:,2),1);
u23 = get_ubar(U(:,2),3);
u31 = get_ubar(U(:,3),1);
u32 = get_ubar(U(:,3),2);

% set P = [] by default, then update for good sigma
% note that the order matters to get a nice "fill" of the convex hull!
P = [];

if length(sigma) == 1
    if sigma == [1]
        P = [u1 u12 e1 u13];
    end
    if sigma == [2]
        P = [u2 u21 e2 u23];
    end
    if sigma == [3]
        P = [u3 u31 e3 u32];
    end
end

if length(sigma) == 2
    if sigma == [1,2]
        P = [u1 u2 u23 u13];
    end
    if sigma == [1,3]
        P = [u1 u3 u32 u12];
    end
    if sigma == [2,3]
        P = [u2 u3 u31 u21];
    end
end

if length(sigma) == 3
    if sigma == [1,2,3]
        P = [u1 u2 u3];
    end
end