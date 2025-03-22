
%ideal environment is the map with its walls completely filled
%scoring for detection is as follows
grid_width = 1000;
grid_height = 500;
ideal_environment = zeros(grid_height,grid_width);
grid_center_x = 0;
grid_center_y = 0;

Map4 = max(0, Map4);
%Map4(197:200,234:335) = 1;
imagesc(Map4);

save('drawn');


%perimeter walls
%walls are 5cm thickS
% ideal_environment(1:500,1:5) = 10;
% ideal_environment(1:500,995:1000) = 10;
% ideal_environment(1:5,1:1000) = 10;
% ideal_environment(495:500,1:1000) = 10;
% 
% ideal_environment(328:331,229:649) = 10; %-----
% ideal_environment(144:330,229:231) = 10; %|
% ideal_environment(144:147,128:229) = 10;%---

%large boox

%objects in environment
% use point sampler (modules) to get the x, y coordinates. Add offset = the
% position
%ideal_environment(round(-80 +250): round(-75 +250) ,round(280) :round(649)) = 10;

