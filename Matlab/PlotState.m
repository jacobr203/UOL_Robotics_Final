function PlotState(app)
scan = Sense(app); %
map_width_m = 10;  % 10 meters wide
map_height_m = 5;  % 5 meters tall
cell_size = 0.01;   % Each cell is 1 cm
map_width = map_width_m / cell_size;   % 1000 cells
map_height = map_height_m / cell_size; 

% On Startup, initalize values during first plot
if (~app.mapInit)    
    app.currentTheta = 0;    
    app.dt = 0.2;    
    app.step = 0;
    app.LogOddsMap = zeros(map_height, map_width); 
    app.mapInit = true;
end

%break apart scn into relative cartesian coordinates
[x_global, y_global] = scan_to_globalCarte(app, scan);
% Log-odds parameters
log_odds_occupied = 0.85;
log_odds_free = -0.4;

x_global = round(x_global);
y_global = round(y_global);
x_global = x_global + 500;
y_global = y_global + 250;

%plot changes
for i = 1:684
    % Compute line points from robot (0,0) to the detected obstacle
   % c = CalcLine(0, 0, X_grid(i), Y_grid(i));
    
    % Mark free space along the ray (excluding the last point)
   % for j = 1:size(c, 1) 
    %    if c(j,1) > 0 && c(j,1) <= map_width && c(j,2) > 0 && c(j,2) <= map_height
   %         app.LogOddsMap(c(j,2), c(j,1)) = app.LogOddsMap(c(j,2), c(j,1)) + log_odds_free;                
 %       end
  %  end
    
    % Mark the final detected obstacle cell
    if x_global(i) > 0 && x_global(i) <= map_width && y_global(i) > 0 && y_global(i) <= map_height
        app.LogOddsMap(y_global(i), x_global(i)) = app.LogOddsMap(y_global(i), x_global(i)) + log_odds_occupied;
    end
end

% Clamp log-odds values to keep them within the valid range
app.LogOddsMap = max(min(app.LogOddsMap, 10), -10);

% Convert log-odds to probability
app.LogOddsMap = 1 ./ (1 + exp(-app.LogOddsMap)); 

% Display the map
imshow(app.LogOddsMap, 'Parent', app.UIAxes2);  
colormap(app.UIAxes2, 'gray');
title(app.UIAxes2, 'Global Occupancy Grid');
linkdata on
end