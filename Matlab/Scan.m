function Scan(app)

clc; clear; close all;

% Connect to CoppeliaSim
sim = remApi('remoteApi'); % Load remote API
sim.simxFinish(-1);
clientID = sim.simxStart('127.0.0.1',19999,true,true,5000,5);             

if clientID > -1
    % Scene Bounds & Grid Parameters
    gridSizeX = 1000; 
    gridSizeY = 500;
    cellSize = 0.01; 
    tolerance = 0.01;
    minX = -5;
    minY = -2.5;
    % Set Z-coordinate for cross-section
    zSlice = 0.02;  % Adjust based on your scene

    % Get all objects
    [res, objectHandles] = sim.simxGetObjects(clientID, sim.sim_object_shape_type, sim.simx_opmode_blocking);

    % Storage for all exterior points
     allPoints = [];

    if res == sim.simx_return_ok
        fprintf('Total objects detected: %d\n', length(objectHandles));
        
        for i = 1:length(objectHandles)
            % Get object position
            [res1, pos] = sim.simxGetObjectPosition(clientID, objectHandles(i), -1, sim.simx_opmode_blocking);
            
            % Get bounding box size (returns NaN sometimes!)
            [res2, xSize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 15, sim.simx_opmode_blocking);
            [res3, ySize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 16, sim.simx_opmode_blocking);
            [res4, zSize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 17, sim.simx_opmode_blocking);

            % Skip objects if any size is missing
            if any([res1, res2, res3, res4] ~= sim.simx_return_ok) || isnan(zSize)
                fprintf('Skipping object %d (Failed to get size)\n', objectHandles(i));
                continue;
            end

            % Compute min and max Z for this object
            minZ = pos(3) - abs(zSize) / 2;
            maxZ = pos(3) + abs(zSize) / 2;

            fprintf('Object %d: minZ=%.3f, maxZ=%.3f\n', objectHandles(i), minZ, maxZ);

            % Check if object intersects with zSlice
            if (zSlice >= minZ - tolerance) && (zSlice <= maxZ + tolerance)
                % Object's 2D footprint at zSlice
                xMin = pos(1) - abs(xSize) / 2;
                xMax = pos(1) + abs(xSize) / 2;
                yMin = pos(2) - abs(ySize) / 2;
                yMax = pos(2) + abs(ySize) / 2;

                % Add 4 corner points of object's cross-section
                objectPoints = [xMin, yMin; xMin, yMax; xMax, yMin; xMax, yMax];
                allPoints = [allPoints; objectPoints];
            end
        end
    end

    % Close connection
    sim.simxFinish(clientID);
    sim.delete();

    % Compute and plot the exterior boundary
    if ~isempty(allPoints)
        allPoints = double(allPoints);  % Ensure numeric type
        allPoints(any(isnan(allPoints) | isinf(allPoints), 2), :) = [];  % Remove NaN/Inf rows
        
        % Ensure at least 3 points are available (alphaShape needs >=3)
        if size(allPoints, 1) >= 3
            % Use Alpha Shape for a better outer boundary
            shp = alphaShape(allPoints(:,1), allPoints(:,2), 1); % Adjust alpha for best fit

            % Plot results
            figure; hold on;
            plot(allPoints(:,1), allPoints(:,2), 'ro', 'MarkerSize', 5, 'LineWidth', 1); % Show all sampled points
            plot(shp, 'FaceColor', 'cyan', 'EdgeColor', 'b'); % Plot boundary

            title(['Cross-section at Z = ', num2str(zSlice)]);
            xlabel('X'); ylabel('Y');
            axis equal;
            grid on;
            legend('Sampled Points', 'Exterior Boundary');
        else
            disp('Not enough valid points to form a boundary.');
        end
    else
        disp('No objects intersect with the specified Z level.');
    end
else
    error('Failed to connect to CoppeliaSim.');
end