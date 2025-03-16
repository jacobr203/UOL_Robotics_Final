%% Get laser scanner data
%calculate cartesian Coordinates
function plotLaserScanner(app)

[img1,img2] = getVisionScanner(app); % 1x256 1x256 double
scn = [fliplr(img2),img1]; % This is a 512 vector of the rays left to right
%now call the lidar update function

rho = 90;
dtheta = (rho/(size(scn,2)-1))*pi/180;
theta = (-(rho/2)*pi/180):dtheta:((rho/2)*pi/180);
scn2 = lensdistort(scn,0.5);
app.vision = pol2cart(theta, scn2);
app.globalTheta = theta;

[r, velocity, angVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.youBotHandle, app.sim.simx_opmode_blocking);
v = norm(velocity(1:2));
omega = angVelocity(3);
updateGlobalMap(app, app.vision, (app.globalTheta), ...
    (v), (omega), (app.UpdateIntervalsecondsEditField.Value));

end