function Layer = DrawWall(laserScan, x, y, theta, mapZoom, mapSize)
  load('img1_test.mat');
  load('img2_test.mat');
  laserScan = [img2,img1];
  x = 0;
  y= 0;
  theta = 0;
  mapZoom = 50;
  Layer = zeros(1000, 500);
  laserScan = [cos(theta),-sin(theta),0;sin(theta),cos(theta),0;0,0,1] * laserScan; % rotate laser scanner data (orientation)
   for i = 1:size(laserScan, 2)
    xW = x + int64(mapZoom*laserScan(1, i));
    yW = y + int64(mapZoom*laserScan(2, i));   
    if (xW < mapSize && yW < mapSize && xW > 0 && yW > 0) % if they fit into the map
      Layer(xW, yW) = 40;
    end
    %laserScan(1,i)
   end
end

