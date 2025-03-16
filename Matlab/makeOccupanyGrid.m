% Step 1: Extract data from CoppeliaSim (pseudo-code)
obstaclePositions = [2, 3; 5, 7]; % Example data
obstacleSizes = [1, 1; 0.5, 0.5]; % Example data

% Step 2: Create MATLAB map
map = occupancyMap(10, 10, 100); % 10m x 10m map with 100 cells per meter

% Step 3: Populate map
for i = 1:size(obstaclePositions, 1)
    pos = obstaclePositions(i, :);
    sz = obstacleSizes(i, :);
    setOccupancy(map, [pos(1)-sz(1)/2, pos(2)-sz(2)/2, sz(1), sz(2)], 1);
end

% Step 4: Visualize map
show(map);