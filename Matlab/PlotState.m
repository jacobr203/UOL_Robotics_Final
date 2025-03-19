function PlotState(app)
[img1,img2] = getVisionScanner(app); %this is not the name of the function, but yk
scn = [(img2),img1];
angles = linspace(0, pi, 512);
map_width_m = 10;  % 10 meters wide
map_height_m = 5;  % 5 meters tall
cell_size = 0.01;   % Each cell is 1 cm
map_width = map_width_m / cell_size;   % 1000 cells
map_height = map_height_m / cell_size; 

% On Startup, initalize values during first plot
if (~app.mapInit)    
    app.currentTheta = 0;    
    app.currentVelocity = 0;
    app.currentAngVelocity = 0;
    app.dt = 0.2;
    app.mapInit = true;
    app.step = 0;
    app.distance_to_bot = 0; %cartesian distance to youBot 
    app.LogOddsMap = zeros(map_height, map_width);
    
end

%break apart scn into relative cartesian coordinates
[x_global, y_global] = scan_to_globalCarte(app, scn, angles);
y_global = y_global + 250;
% Log-odds parameters
log_odds_occupied = 0.85;
log_odds_free = -0.4;
X_grid = zeros(512,1);
Y_grid = zeros(512,1);

for i=1:512
    X_grid(i) = round(x_global(i)) + 500; %xcenter
    Y_grid(i) = round(y_global(i)) - 250; %ycenter
end

for i=1:512
    if X_grid(i) > 0 && X_grid(i) <= map_width && Y_grid(i) > 0 && Y_grid(i) <= map_height        
        if scn(i) >= 255 
            break;
        end
        app.LogOddsMap(Y_grid(i), X_grid(i)) = app.LogOddsMap(Y_grid(i), X_grid(i)) + log_odds_occupied;        

    end
end


imshow(app.LogOddsMap, 'Parent', app.UIAxes2);  
colormap(app.UIAxes2, 'gray');
%title(app.UIAxes2, 'Global Occupancy Grid');
end