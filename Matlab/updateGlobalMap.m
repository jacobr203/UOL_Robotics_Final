function updateGlobalMap(app, r, theta, v, omega, dt)
    % Update estimated position using dead reckoning
    if isempty(v)
        X_robot = X_robot ;
        Y_robot = Y_robot ;
    else
        X_robot =( X_robot + v * X_robot * dt);
        Y_robot = (Y_robot + v * Y_robot * dt);
    end
    
    Theta_robot = theta + omega * dt;

    % Convert real-world position to grid map coordinates
    X_grid = round((X_robot) / cell_size);
    Y_grid = round((Y_robot) / cell_size);

    % Sensor angles (LIDAR FOV: 200° with 512 rays)
    allAngles = linspace(-1.745, 1.745, 512);
    
    % Log-odds parameters
    log_odds_occupied = 0.85;
    log_odds_free = -0.4;

    % Convert LIDAR readings to global coordinates for each ray
    xW = zeros(1, 512);
    yW = zeros(1, 512);
    for i = 1:512
        x_local = r(i) * sin(allAngles(i));  % Use i to index into r
        y_local = r(i) * cos(allAngles(i));  % Use i to index into r

        % Transform to global grid coordinates
        xW(i) = round(((X_robot) + x_local) / cell_size); %looks like: 
        yW(i) = round(((Y_robot) + y_local) / cell_size);
    end

    % Update log-odds map with sensor data
    for i = 1:512
        if xW(i) > 0 && xW(i) <= map_width && yW(i) > 0 && yW(i) <= map_height
            LogOddsMap(xW(i), yW(i)) = LogOddsMap(xW(i), yW(i)) + log_odds_occupied;
        end
    end

    % Mark free space between robot and obstacles
    for i = 1:(512-1)
        c = CalcLine(X_grid, Y_grid, xW(i), yW(i));
        for j = 1:size(c, 1)
            if c(j,1) > 0 && c(j,1) <= map_width && c(j,2) > 0 && c(j,2) <= map_height
                LogOddsMap(c(j,1), c(j,2)) = LogOddsMap(c(j,1), c(j,2));                
            end
        end
    end

    % Convert log-odds to probabilities
    ProbMap = 1 ./ (1 + exp(-LogOddsMap));

    % Display the map on the provided UIAxes
    imshow(flipud(ProbMap'), 'Parent', app.UIAxes2);  % Display on the UIAxes specified
    colormap(app.UIAxes2, 'gray');
    title(app.UIAxes2, 'Global Occupancy Grid');
end
