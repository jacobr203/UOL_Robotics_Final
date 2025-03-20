function points = CalcLine(x1, y1, x2, y2)
    % Implements Bresenham's Line Algorithm for discrete occupancy grid updates
    x1 = round(x1); x2 = round(x2);
    y1 = round(y1); y2 = round(y2);
    
    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    steep = dy > dx; % Check if slope > 1 (steep line)
    
    if steep
        % Swap x and y to handle steep lines
        [x1, y1] = deal(y1, x1);
        [x2, y2] = deal(y2, x2);
        [dx, dy] = deal(dy, dx);
    end
    
    % Bresenham's line algorithm
    error_term = floor(dx / 2);
    y_step = 1 - 2 * (y1 > y2); % +1 if y1 < y2, -1 otherwise
    y = y1;
    
    % Compute x points and corresponding y points
    if x1 < x2
        x = (x1:x2)';
    else
        x = (x1:-1:x2)';
    end
    
    points = zeros(length(x), 2);
    
    for i = 1:length(x)
        if steep
            points(i, :) = [y, x(i)]; % Swap back for steep cases
        else
            points(i, :) = [x(i), y];
        end
        error_term = error_term - dy;
        if error_term < 0
            y = y + y_step;
            error_term = error_term + dx;
        end
    end

    % Remove the last point (since it's an obstacle)
    if size(points, 1) > 1
        points = points(1:end-1, :);
    end
end