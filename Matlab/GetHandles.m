function [app] = GetHandles(app)
[r,app.h(1)] = app.sim.simxGetObjectHandle(app.clientID, 'rollingJoint_fl', app.sim.simx_opmode_blocking); % r is like a return code I think
[r,app.h(2)] = app.sim.simxGetObjectHandle(app.clientID, 'rollingJoint_rl', app.sim.simx_opmode_blocking);
[r,app.h(3)] = app.sim.simxGetObjectHandle(app.clientID, 'rollingJoint_rr', app.sim.simx_opmode_blocking); 
[r,app.h(4)] = app.sim.simxGetObjectHandle(app.clientID, 'rollingJoint_fr', app.sim.simx_opmode_blocking);
end

