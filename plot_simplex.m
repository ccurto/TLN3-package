function area_simplex = plot_simplex(colors,dot_size)

% function area_simplex = plot_simplex(colors,dot_size)
%
% colors = 3x3 matrix, each row is RGB color
%          for points corresponding to e1, e2, e3
% dot_size = MarkerSize for points e1, e2, e3
% area_simplex = area of the simplex (2-d)
%
% calls: proj2simplex
%
% created by Carina on june 22, 2022
% updated on jun 30, 2022 to make it easier to read, add area_simplex
% updated on jul 20, 2024 to add "hold off" at the end


if nargin < 1 || isempty(colors)
    colors = [.1 .2 1; .9 0 0; 0 .7 0];
end

if nargin < 2 || isempty(dot_size)
    dot_size = 30;
end

% compute projected vertices, ei's, and area of simplex
e1 = proj2simplex([1 0 0]');
e2 = proj2simplex([0 1 0]');
e3 = proj2simplex([0 0 1]');
P = [e1 e2 e3];
X = P(1,:);
Y = P(2,:);
area_simplex = polyarea(X,Y);

% plot coordinate axes in light gray
plot([0,e1(1)],[0,e1(2)],'-','Color',[.7 .7 .7])
hold on
plot([0,e2(1)],[0,e2(2)],'-','Color',[.7 .7 .7])
plot([0,e3(1)],[0,e3(2)],'-','Color',[.7 .7 .7])
ylim([-0.6,1.1]) % give some vertical margin to the plot

% plot simplex boundary in thick black
plot([e1(1),e2(1)],[e1(2),e2(2)],'k','LineWidth',2)
plot([e1(1),e3(1)],[e1(2),e3(2)],'k','LineWidth',2)
plot([e2(1),e3(1)],[e2(2),e3(2)],'k','LineWidth',2)

% plot vertices in color: blue, red, green
plot(e1(1),e1(2),'.','MarkerSize',dot_size,'Color',colors(1,:))
plot(e2(1),e2(2),'.','MarkerSize',dot_size,'Color',colors(2,:))
plot(e3(1),e3(2),'.','MarkerSize',dot_size,'Color',colors(3,:))
hold off