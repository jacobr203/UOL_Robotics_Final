%Idea is to do:

%Update (from current values)
%Sense -> Plot
%Next Action (handle input)
function [scan] = Sense(app)

	%call streaming objects
	if app.sicko_handle < 0
        [r,app.sicko_handle] = app.sim.simxGetObjectHandle(app.clientID, 'SICK_S300_fast', app.sim.simx_opmode_blocking);
		[r,app.Velocity, app.angularVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.sicko_handle, app.sim.simx_opmode_streaming);
		[r,stringSignal] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0', app.sim.simx_opmode_streaming);
        pause(0.1);
		scan = app.sim.simxUnpackFloats(stringSignal);       
    end
	[r,app.Velocity, app.angularVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.sicko_handle, app.sim.simx_opmode_buffer);
	[r,stringSignal] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0', app.sim.simx_opmode_buffer);
	scan = app.sim.simxUnpackFloats(stringSignal);
    
end
 