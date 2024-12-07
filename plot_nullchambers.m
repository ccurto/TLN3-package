function seq_vec = plot_nullchambers(soln,colors,ymax,permflag);

% function seq_vec = plot_nullchambers(soln,colors,ymax,permflag);
%
% soln = the structure which is the output of sA2soln or Wb2soln
% colors = matrix of RGB colors for neurons
% permflag = 1 to permute grays in C_colors, 0 not to (default)
%
% created July 19, 2020
% updated Aug 8, 2020, to use find_nullchambers.m
% updated Oct 10, 2020, to be compatible with new find_nullchambers.m
% updated Oct 25, 2020, to make nullchamber colors consistent 
%   and return seq_vec
% updated Dec 27, 2020, to improve the colors
% updated Jan 16, 2020 to add ymax option for fixing ylim
% updated May 5, 2022 to allow random perm for C_colors

n = size(soln.X,2); % number of neurons

if nargin < 2 || isempty(colors)
    colors = [0 .5 .7; .15 .6 0; .5 .5 .5; .8 .55 0; .8 0 0];
    if n > 5
        colors = lines(n);
    end;
end;

if nargin < 3 || isempty(ymax)
    ymax = 1.2;
end

if nargin < 4 || isempty(permflag)
    permflag=0;
end

% first, plot rate curves
for i=1:n
    plot(soln.time,soln.X(:,i),'-','color',colors(i,:),'LineWidth',1.5);
    hold on
end;
xlabel('time')
ylabel('firing rate')
ylim([0 ymax]);

% get nullcline chambers C and times at which one crosses between 
% them, t_idx; seq_vec is full sequence of nullchambers from 0,...,2^n-1
[seq_vec,seqC,t_idx,C] = find_nullchambers(soln.X);

% Create color code for chambers, C_colors(i,:) is color for chamber i-1
%[distinct_C, IA, IC] = unique(C,'rows');
C_colors = zeros(2^n,3);
C_colors(2:2^n-1,:) = gray(2^n-2); % one color per chamber vector 
C_colors = .1*C_colors + .9; % whiten the colors to make them pastel
C_colors(1,:) = [1 1 1]; % all + chamber is white (chamber 0)
C_colors(2^n,:) = [.7 .7 .7]; % all - chamber is gray (chamber 2^n-1)

% permute colors in case adjacent chambers are hard to distinguish
if permflag
    C_colors = C_colors(randperm(2^n),:);
end

% now plot shaded rectangles for nullcline chambers
for i = 1:length(t_idx)-1
    t0 = soln.time(t_idx(i));
    t1 = soln.time(t_idx(i+1));
    t = [t0 t0 t1 t1 t0];
    y = [0 ymax ymax 0 0];
    col = C_colors(seq_vec(i)+1,:);
    fill(t,y,col,'Linestyle','none'); 
end;

% finally, overplot the rate curves
for i=1:n
    plot(soln.time,soln.X(:,i),'-','color',colors(i,:),'LineWidth',1.5);
    hold on
end;
hold off