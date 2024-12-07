function [areas, area_simplex] = plot_Rsigma_simplex(W,titlestr,colors,fill_flag)

% function [areas, area_simplex] = plot_Rsigma_simplex(W,titlestr,colors,fill_flag)
% 
% W = matrix for the TLN, output of graph2net(sA,e,d)
% titlestr = string with title for plot, like "3-cycle CTLN"
% colors = 3x3 matrix, each row is RGB color
% fill_flag = 1 to fill in all R_sigma regions except full support
%             (default is 1, choose 0 to not fill anything in)
%
% areas = vector of areas for each R_sigma, 
%         using sigma order: 1, 2, 3, 12, 13, 23, 123
% area_simplex = area of full simplex
%
% makes simplex plot for R_sigma regions for n=3 TLN defined by W
% calls: plot_simplex, get_Rsigma, get_ubar, get_idx
%
% created by Carina on june 22, 2022
% updated june 27, 2022 to make fill_flag = 1 the default
% updated june 29, 2022 to compute areas for each R_sigma
% updated june 30, 2022 to use new version of get_ubar, streamline, 
%   and make the code more readable
% updated july 1, 2022 to make titlestr default print indices

if nargin<2 || isempty(titlestr)
    idx = get_idx(W);
    titlestr = ['idx = ' int2str(idx)]; % used idx as default title
end

if nargin<3 || isempty(colors)
    colors = [.1 .2 1; .9 0 0; 0 .7 0];
end

if nargin<4 || isempty(fill_flag)
    fill_flag = 1;
end

% first, plot e1, e2, e3 and boundary of simplex, and get area
area_simplex = plot_simplex(colors);
hold on

% next, shade in R1, R2, and R3 regions, so later lines pop more
% and compute areas for each R_sigma
if fill_flag
    for j=1:3
        P = get_Rsigma(W,j);
        X = P(1,:);
        Y = P(2,:);
        h = fill(X,Y,colors(j,:));
        set(h,'facealpha',.25);
        areas(j) = polyarea(X,Y);
    end
    % shade in R12, R13, R23 regions
    for k=1:3
        P = get_Rsigma(W,setdiff([1:3],k));
        X = P(1,:);
        Y = P(2,:);
        h = fill(X,Y,[.5 .5 .5]);
        set(h,'facealpha',.25);
        areas(7-k) = polyarea(X,Y);
    end
    % don't shade R123, but get area
    P = get_Rsigma(W,[1 2 3]);
    X = P(1,:);
    Y = P(2,:);
    areas(7) = polyarea(X,Y);
else
    areas = []; % don't return areas if fill_flag = 0
end

% finally, plot all the special points and line segments
% U = I-W, columns U(:,i) are the ui vectors defining the cones Rsigma
U = eye(3)-W; 

% plot "uij" vectors on the boundary of the simplex
% uij comes from line(ui,ej)
for i=1:3
    for j = setdiff([1:3],i)
        uij = get_ubar(U(:,i),j);
        plot(uij(1),uij(2),'.','Color',colors(i,:),'Markersize',20)
    end
end

% now plot lines from ui's to uij's
for i=1:3
    ui = get_ubar(U(:,i));
    for j = setdiff([1:3],i)
        uij = get_ubar(U(:,i),j);
        plot([uij(1),ui(1)],[uij(2),ui(2)],'-',...
            'Color',colors(i,:),'LineWidth',2)
    end
end

% plot inner (black) triangle bounding R_123 region
for i=1:3
    ui = get_ubar(U(:,i));
    uj = get_ubar(U(:,mod(i,3)+1));
    plot([ui(1),uj(1)],[ui(2),uj(2)],'k','LineWidth',2)
end

% finally, plot u1, u2, and u3 as colored *'s
for i = 1:3
    ui = get_ubar(U(:,i));
    plot(ui(1),ui(2),'.','Color',colors(i,:),'Markersize',15)
    plot(ui(1),ui(2),'*','Color',colors(i,:),'Markersize',15)
end
title(titlestr)
hold off