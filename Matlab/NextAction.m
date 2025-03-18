function  NextAction(app)

%perform an action based on current configuration

if app.currentAngVelocity ~=0 || app.currentVelocity ~=0 
    forwBackVel = app.currentVelocity;
    leftRightVel = 0;
    rotVel = app.currentAngVelocity;
    app.sim.simxSetJointTargetVelocity(app.clientID, app.h(1),-forwBackVel-leftRightVel-rotVel, app.sim.simx_opmode_blocking);
    app.sim.simxSetJointTargetVelocity(app.clientID, app.h(2),-forwBackVel+leftRightVel-rotVel, app.sim.simx_opmode_blocking);
    app.sim.simxSetJointTargetVelocity(app.clientID, app.h(3),-forwBackVel-leftRightVel+rotVel, app.sim.simx_opmode_blocking);
    app.sim.simxSetJointTargetVelocity(app.clientID, app.h(4),-forwBackVel+leftRightVel+rotVel, app.sim.simx_opmode_blocking);
end

