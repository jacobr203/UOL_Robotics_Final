function PlotState(app)
scan = Sense(app); %
map_width_m = 10;  % 10 meters wide
map_height_m = 5;  % 5 meters tall
cell_size = 0.01;   % Each cell is 1 cm
map_width = map_width_m / cell_size ;   % 1000 cells
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
[x_original, y_original] = scan_to_globalCarte(app, scan);
x_global = x_original;
y_global = y_original;
% Log-odds parameters
log_odds_occupied = .5;
log_odds_free = -0.4;

x_global = round(x_global);
y_global = round(y_global);
x_global = x_global + 500;
y_global = y_global + 250;
x_global = max(x_global,1);  
y_global = max(y_global,1);

%plot changes
for i = 1:684
    if x_global(i) > 0 && x_global(i) <= map_width && y_global(i) > 0 && y_global(i) <= map_height
        app.LogOddsMap(y_global(i), x_global(i)) = app.LogOddsMap(y_global(i), x_global(i)) + log_odds_occupied;
    end
end

%decay points not at max
B = (app.LogOddsMap - 12);
app.LogOddsMap = app.LogOddsMap + B/50;


% Clamp log-odds values to keep them within the valid range
app.LogOddsMap = max(min(app.LogOddsMap, 12), 0);

% Convert log-odds to probability
%app.LogOddsMap = 1 ./ (1 + exp(-app.LogOddsMap)); 

% Display the map
imagesc(app.LogOddsMap);  
set(gca,'YDir','normal')
%saveme = app.LogOddsMap;
linkdata on


end