function seq_vec = plot_linchambers(soln,colors,ymax)

% function seq_vec = plot_linchambers(soln,colors,ymax)
%
% soln = the structure which is the output of threshlin_ode
% colors = matrix of RGB colors for neurons
% ymax = to set y-axis limits on ratecurves plot
%
% seq_vec = vector of seqC chambers turning binary into decimal 
%           to get a single integer for each chamber (for comparisons)
%
% calls: find_linchambers.m
%
% created by carina on apr 19, 2024, to plot linear chambers of a TLN
% (based on the may 5, 2023 version of plot_nullchambers.m)
%
% updated on apr 20, 2024 to change default ymax from 1.2 to 1,
% fix colors, and get rid of permflag

n = size(soln.X,2); % number of neurons

if nargin < 2 || isempty(colors)
    colors = [0 .5 .7; .15 .6 0; .5 .5 .5; .8 .55 0; .8 0 0];
    if n > 5
        colors = lines(n);
    end
end

if nargin < 3 || isempty(ymax)
    ymax = 1;
end

% first, plot rate curves
for i=1:n
    plot(soln.time,soln.X(:,i),'-','color',colors(i,:),'LineWidth',1.5);
    hold on
end
xlabel('time')
ylabel('firing rate')
ylim([0 ymax]);

% get linear chambers C and times at which one crosses between 
% them, t_idx; seq_vec is full sequence of linear chambers 
% from 0,...,2^n-1 (0 is all - chamber, 2^n-1 is all + chamber)
[seq_vec,seqC,t_idx,C] = find_linchambers(soln.Y);

% Create color code for chambers, C_colors(i,:) is color for chamber i-1
C_colors = gray(2^n); % gray scale starts at [0 0 0] and ends at [1 1 1]
C_colors = .4*C_colors + .6; % lighten the colors 
C_colors(1,:) = [.4 .4 .4]; % make all - chamber dark gray (chamber 0)
C_colors(2^n,:) = [1 1 1];  % make all + chamber white (chamber 2^n-1)

% now plot shaded rectangles for nullcline chambers
for i = 1:length(t_idx)-1
    t0 = soln.time(t_idx(i));
    t1 = soln.time(t_idx(i+1));
    t = [t0 t0 t1 t1 t0];
    y = [0 ymax ymax 0 0];
    col = C_colors(seq_vec(i)+1,:);
    fill(t,y,col,'Linestyle','none'); 
end

% finally, overplot the rate curves
for i=1:n
    plot(soln.time,soln.X(:,i),'-','color',colors(i,:),'LineWidth',1.5);
    hold on
end
hold off