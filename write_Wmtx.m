function write_Wmtx(W,x,y)

% function write_Wmtx(W,x,y)
%
% W is the 3x3 matrix to print on a plot
% [x,y] = location for top left corner
%
% created nov 19, 2024 by Carina.
% last updated on dec 5, 2024

if nargin < 2 || isempty(x)
    x = 0;
end

if nargin < 2 || isempty(y)
    y = .85;
end

% make array of strings for W matrix
for i = 1:3
    for j = 1:3
        Wcell(i,j) = {num2str(W(i,j),'%.2f')};
        if W(i,j) == 0
            Wcell(i,j) = {'  0'};
        end
    end
end

% print W matrix
text(x+.25,y+.09,'W matrix','FontSize',12);
xvals = x+[0 .35 .7]; % correspond to columns j
yvals = y+[0 -.07 -.14]; % correspond to rows i
for i=1:3
    for j=1:3
        text(xvals(j),yvals(i),Wcell{i,j},'FontSize',12,...
            'FontName','fixedwidth');
    end
end

set(gca,'XTick',[]); % to remove tick marks on x-axis
set(gca,'YTick',[]); % to remove tick marks on y-axis