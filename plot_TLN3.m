function plot_TLN3(W,b,X0,T)

% function plot_TLN3(W,b,X0,T)
%
% W = 3x3 matrix for the TLN
% b = 3x1 vector choice of b in TLN (W,b)
% X0 = 3x1 vector or 3x3 array of X0 choices (init conds)
% T = length of simulation
%
% created by Carina on Nov 11, 2024 to make simple n=3 TLN
% simplex + dynamics plots for a catalogue of neuromodulation examples
% updated on 11/19/24 by nikki and carina to have only one choice of b
% updated by carina on 12/1/24 to fix FP(W,b) on simplex plot + ymax
% updated by carina and nikki on 12/5/24

% define colors
colors = [.1 .2 1; .9 0 0; 0 .7 0];

if nargin<2 || isempty(b)
    b = ones(3,1); % default
end

if nargin<3 || isempty(X0)
    X0 = .1*rand(3,3);
end
   
if size(X0,2)<3
    X0 = [X0 .1*rand(3,3)]; % ensure at least 3 init conds
end

if nargin<4 || isempty(T)
    T = 100;
end

% first, add additional b choices to ensure at least 3

% project b vector(s) onto 2d simplex
b_proj = proj2simplex(b);

% print W matrix
subplot(1,5,1)
hold on
write_Wmtx(W,.02,.87)
hold off

% get chirotope table, turn into cell array of strings
[M,idx123,k] = get_chirotope_table(W);
[Wt,class_str] = get_Wchir_graph(eye(3)-W);

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

% add chirotope table to first panel
xvals = [0.1 .25 .4]; % correspond to columns j
yvals = [.45 .38 .31]; % correspond to rows i
text(.1,.54,[class_str ' (k = ' int2str(k) ')'],'FontSize',12)
for i=1:3
    for j=1:3
        text(xvals(j),yvals(i),Mcell{i,j},'FontSize',19,...
            'FontName','fixedwidth');
    end
end
text(.1,.22,idxstr,'FontSize',12)

% add lambda_max to first panel
lambda_max = max(real(eig(-eye(3)+W))); % compute lambda_max 
text(.25,.05, ['\lambda_{max} = ' num2str(lambda_max)],'FontSize',12)

% plot simplex
subplot(1,5,2:3)
plot_Rsigma_simplex(W);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[])
ylim([-0.65,1.15])
hold on
plot(b_proj(1),b_proj(2),'.m','MarkerSize',18)
text(-.92,-.58,['b = [' num2str(b') ']'],'FontSize',12)
title('b-simplex')
[FP,FP_str,fixpts,idx] = get_FP(W,b,0);
text(-.92,1.1,FP_str,'FontSize',12);
text(.85,1.1,class_str,'FontSize',12);
hold off

% plot solns for 3 initial conditions X0
ymax = 1.1;
plot_num = {[4:5],[9:10],[14:15]};
for j=1:3
    soln = threshlin_ode(W,b,T,X0(:,j));
    subplot(3,5,plot_num{j})
    plot_linchambers(soln,colors,ymax);
    title(['X0 = [' num2str(X0(:,j)') ']'])
    if j~=3
        xlabel('');
        set(gca,'XTickLabel',[]);
    end
end