clc; clear; close all;

% Connect to CoppeliaSim
sim = remApi('remoteApi'); 
sim.simxFinish(-1);
clientID = sim.simxStart('127.0.0.1', 19999, true, true, 5000, 5);

if clientID > -1
            fprintf('Connected to CoppeliaSim!\n');

    % Set Z-coordinate for cross-section
    zSlice = 0.12;  % Adjust this based on your scene
    tolerance = 0.01; % Allow small numerical errors

    % Set up occupancy map parameters
    mapResolution = 100; % Number of cells per meter
    mapSize = [10, 10]; % Define map size in meters [Width, Height]
    occMap = occupancyMap(mapSize(1) * mapResolution, mapSize(2) * mapResolution, mapResolution);

    % Get all objects
    [res, objectHandles] = sim.simxGetObjects(clientID, sim.sim_object_shape_type, sim.simx_opmode_blocking);

    if res == sim.simx_return_ok
        fprintf('Total objects detected: %d\n', length(objectHandles));
        
        for i = 1:length(objectHandles)
            % Get object position
            [res1, pos] = sim.simxGetObjectPosition(clientID, objectHandles(i), -1, sim.simx_opmode_blocking);
            
            % Get bounding box size
            [res2, xSize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 15, sim.simx_opmode_blocking);
            [res3, ySize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 16, sim.simx_opmode_blocking);
            [res4, zSize] = sim.simxGetObjectFloatParameter(clientID, objectHandles(i), 17, sim.simx_opmode_blocking);

            % Skip objects if any size is missing
            if any([res1, res2, res3, res4] ~= sim.simx_return_ok) || any(isnan([xSize, ySize, zSize]))
                fprintf('Skipping object %d (Failed to get size or position)\n', objectHandles(i));
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

                % Convert world coordinates to occupancy grid indices
                xRange = linspace(xMin, xMax, round(xSize * mapResolution));
                yRange = linspace(yMin, yMax, round(ySize * mapResolution));

                % Mark grid cells as occupied
                for xi = xRange
                    for yi = yRange
                        setOccupancy(occMap, [xi, yi], 1); % 1 means occupied
                    end
                end
            end
        end
    end

    % Close connection
    sim.simxFinish(clientID);
    sim.delete();

    % Plot the occupancy map
    figure;
    show(occMap);
    title(['Occupancy Map at Z = ', num2str(zSlice)]);
else
    error('Failed to connect to CoppeliaSim.');
end
