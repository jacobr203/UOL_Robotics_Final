%ideal environment is the map with its walls completely filled
%scoring for detection is as follows

grid_width = 1000;
grid_height = 500;
ideal_environment = zeros(grid_width,grid_height);
grid_center_x = 0;
grid_center_y = 0;

%perimeter walls
%walls are 5cm thick
ideal_environment(1:500,1:5) = 10;
ideal_environment(1:500,995:1000) = 10;
ideal_environment(1:5,1:1000) = 10;
ideal_environment(495:500,1:1000) = 10;

%objects in environment
% use point sampler (modules) to get the x, y coordinates. Add offset = the
% position
ideal_environment(round(-80 +250): round(-75 +250) ,round(280) :round(649)) = 10;




figure;
imagesc(ideal_environment);
colormap([1 1 1; 0 0 0]);  % 0 = white (free space), 1 = black (obstacle)
axis equal;
axis([1 grid_width 1 grid_height]);

xticks(0:100:grid_width);
yticks(0:100:grid_height);
xticklabels(-grid_center_x:100:grid_center_x);
yticklabels(flip(-grid_center_y:100:grid_center_y));
xlabel('X (Cartesian)');
ylabel('Y (Cartesian)');
title('Grid with Cartesian Coordinates');
