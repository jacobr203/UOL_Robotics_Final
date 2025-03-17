function PlotState(app)
    %get the local state image from left to right
    [img1,img2] = getVisionScanner(app); 
    scn = [fliplr(img2),img1]; 
[r, velocity, angVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.youBotHandle, app.sim.simx_opmode_blocking);



end

