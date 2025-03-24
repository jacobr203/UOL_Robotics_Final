function PlotState(app)
scan = Sense(app); %
map_width_m = 10;  % 10 meters wide
map_height_m = 5;  % 5 meters tall
cell_size = 0.01;   % Each cell is 1 cm
map_width = map_width_m / cell_size ;   % 1000 cells
map_height = map_height_m / cell_size; 
% On Startup, initalize values during first plot
stopFirstScan = false;
if (~app.mapInit)    
    app.currentTheta = 0;     
    app.step = 0;
    app.LogOddsMap = zeros(map_height, map_width); 
    app.mapInit = true;
    stopFirstScan = true;
    app.slam = lidarSLAM(30, 10);
end
%break apart scn into relative cartesian coordinates
%[x_original, y_original] = scan_to_globalCarte(app, scan);

if mod(length(scan), 3) == 0 
    measuredData = reshape(scan, 3, []);  % Now it's 3 x 684
end
measuredData = measuredData(:,1:10:end);


[X, Y] = deal(measuredData(1,:), measuredData(2,:));
ranges = sqrt(X.^2 + Y.^2);
angles = atan2(Y, X); 
lidar_scan = lidarScan(ranges, angles); 

for i = 1:length(lidar_scan)
    addScan(app.slam, lidar_scan(i));  % local frame scans  % Add a small delay between scans
    app.scan_count = app.scan_count + 1;
end

[scans, optimizedPoses] = scansAndPoses(app.slam);
if  app.scan_count > 14 || stopFirstScan
    app.LogOddsMap = buildMap(scans,optimizedPoses, 30,10);
    if ~ stopFirstScan
        app.scan_count = 0;
    end
end
% anotherMap = getMap(app.slam);
% app.LogOddsMap = anotherMap;

% x_global = x_original;
% y_global = y_original;
% decay_factor = 0.99;
% % Log-odds parameters
% log_odds_occupied = .8;
% log_odds_free = -0.4;
% x_global = round(x_global);
% y_global = round(y_global);




% if ~stopFirstScan
%     fixedScan = pointCloud([app.LastXScan(:), app.LastYScan(:), zeros(size(app.LastXScan(:)))]);
%     movingScan = pointCloud([x_global(:), y_original(:), zeros(size(x_global(:)))]);
%     [ticp, movingReg, rmse] = pcregistericp(movingScan, fixedScan, 'Metric', 'pointToPlane');
% 
%     corrected_pose = transformPointsForward(ticp, [app.Robot_x*100, app.Robot_y*100,0]);
%     app.Robot_x = corrected_pose(1)/100;
%     app.Robot_y = corrected_pose(2)/100;
% 
%     app.slam = lidarSLAM(100, 10);
% 
% end
% 
% app.LastXScan = x_global;
% app.LastYScan = y_global;
% 
% x_global = x_global + 500;
% y_global = y_global + 250;
% x_global = max(x_global,1);  
% y_global = max(y_global,1);
% 
% %plot changes
% for i = 1:684
%     if x_global(i) > 0 && x_global(i) <= map_width && y_global(i) > 0 && y_global(i) <= map_height
%         app.LogOddsMap(y_global(i), x_global(i)) = app.LogOddsMap(y_global(i), x_global(i)) + log_odds_occupied;
% 
% 
%     end
% end
% 
% %decay points not at max
% app.LogOddsMap = app.LogOddsMap * decay_factor; 
% threshold = 0.5;
% 
% %app.LogOddsMap = imgaussfilt(app.LogOddsMap, sigma);
% app.LogOddsMap = max(min(app.LogOddsMap, 7), 0); % Clamp values

% Display the map
show(app.LogOddsMap);
%set(gca,'YDir','normal')
linkdata on

end
