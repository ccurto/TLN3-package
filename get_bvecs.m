function [P,B,FP_str] = get_bvecs(W,m,titlestr)

% function [P,B,FP_str] = get_bvecs(W,m,titlestr)
%
% W = matrix for an n=3 TLN
% m = number of points for user to select (m=0 for simplex plot only)
% titlestr = string with title for the plot
%
% P = m x 2 matrix of selected points in 2d simplex, every row is a point
% B = 3 x m matrix of points in 3d positive orthant, every column a point
%     these are the b vectors to use in threshlin_ode for dynamics
% FP_str = cell array of strings for FP(W,b)
%          where FP_str{i} is FP(W,b) for b = B(:,i)
% note: the points in B project to those in P under proj2simplex
%       i.e., proj2simplex(B) = P' (that's the sanity check)
%
% this is a wrapper for plot_Rsigma_simplex.m allowing user to select bs
% also calls: get_ubar, proj2simplex, get_FP, and get_chirotope_table
%
% created by carina on dec 6, 2024 from get_simplex_thetas.m,
% to simplify the code, rename thetas to bs, and remove barycenter default

if nargin < 2 || isempty(m)
    m = 0;
end

if nargin < 3 || isempty(titlestr)
    titlestr = [];
end

% plot R_sigma simplex for W
plot_Rsigma_simplex(W,titlestr);

% let user select b values...............................................
P = zeros(m,2);
B = zeros(3,m);

if m > 0

% let user pick b values if m > 0
fprintf('Resize window, then hit space bar \n')
pause % allow user to resize window

for i=1:m 
    fprintf(['Pick another point on simplex ' ...
        '(' int2str(i) ' of ' int2str(m) ')\n'])
    P(i,:) = ginput(1);
end

% compute B, whose cols are b's - need Pinv for this.....................
U = eye(3)-W;
[Uproj,Pinv,binv] = proj2simplex(U(:,1));
for i = 1:m
    B(:,i) = Pinv*P(i,:)' + binv; % 3d column vector of b values
end

% annotate simplex plot with FP(W,b) for selected b's in B mtx...........
hold on
for i=1:m
    b = B(:,i); % these are selected thetas (b's)
    plot(P(i,1),P(i,2),'.m','Markersize',12);
    text(P(i,1)+.005,P(i,2)+.015,num2str(i),'FontSize',12);
    [FP,FP_str{i},fixpts,idx] = get_FP(W,b,0); % 0 = don't print
    text(-0.95,1.02-.05*i,[int2str(i) '. ' FP_str{i}],'FontSize',12);
end
hold off
text(-0.95,1.05,titlestr,'FontSize',12)

end   % end of stuff if m > 0

% annotate simplex plot with chirotope table............................

% get chirotope table, turn into cell array of strings
[M,idx123,k] = get_chirotope_table(W);

% make index string
if idx123 == 1
    idxstr = 'idx(123) = +1';
else if idx123 == -1
        idxstr = 'idx(123) = -1';
else idxstr = ['idx(123) = ' int2str(idx123)];
end
end

% make array of +/- strings for chirotope table
for i = 1:3
    for j = 1:3
        if M(i,j) == 1
            Mcell(i,j) = {'+'};
        else if M(i,j) == -1
                Mcell(i,j) = {'-'};
        else
            Mcell(i,j) = {''}; % shouldn't happen!
        end
    end
    end
end

% add chirotope table to simplex plot at top right
xvals = [.65 .73 .81]; % correspond to columns j
yvals = [.97 .91 .85]; % correspond to rows i
text(xvals(1),1.05,['chir (k = ' int2str(k) ')'],'FontSize',12)
for i=1:3
    for j=1:3
        text(xvals(j),yvals(i),Mcell{i,j},'FontSize',20,...
            'FontName','fixedwidth');
    end
end
text(xvals(1),.76,idxstr,'FontSize',12)