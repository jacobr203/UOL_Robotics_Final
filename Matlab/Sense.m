%Idea is to do:

%Update (from current values)
%Sense -> Plot
%Next Action (handle input)
function [scan] = Sense(app)

	%call streaming objects
	if app.sicko_handle < 0
        [r,app.sicko_handle] = app.sim.simxGetObjectHandle(app.clientID, 'SICK_S300_fast', app.sim.simx_opmode_blocking);
		[r,~, app.angularVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.sicko_handle, app.sim.simx_opmode_streaming);
        [r,app.Velocity, ~] = app.sim.simxGetObjectVelocity(app.clientID, app.youBotHandle, app.sim.simx_opmode_streaming);
        %we're grabbing position since mechanum wheels are difficult to
        %work with. We only use this posiiton to get the absolute distance
        %from the midpoint of youBot
        [r,app.sensorPosition] = app.sim.simxGetObjectPosition(app.clientID, app.sicko_handle,-1, app.sim.simx_opmode_streaming);
		[r,stringSignal] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0', app.sim.simx_opmode_streaming);
        pause(0.1);
		scan = app.sim.simxUnpackFloats(stringSignal);       
    end
	[r,~, app.angularVelocity] = app.sim.simxGetObjectVelocity(app.clientID, app.sicko_handle, app.sim.simx_opmode_buffer);
    for i = 1: 3
        if abs(app.angularVelocity(i)) < .001
            app.angularVelocity(i) = 0;
        end
    end
    [r,app.Velocity, ~] = app.sim.simxGetObjectVelocity(app.clientID, app.youBotHandle, app.sim.simx_opmode_buffer);
    for i = 1: 3
        if abs(app.Velocity(i)) < .001
            app.Velocity(i) = 0;
        end

    [r,app.sensorPosition] = app.sim.simxGetObjectPosition(app.clientID, app.sicko_handle,-1, app.sim.simx_opmode_buffer);
	[r,stringSignal] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0', app.sim.simx_opmode_buffer);
	scan = app.sim.simxUnpackFloats(stringSignal);
    
end
 