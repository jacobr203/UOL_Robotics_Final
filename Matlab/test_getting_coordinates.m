function test_getting_coordinates(number)

sim = remApi('remoteApi');
sim.simxFinish(-1);
clientID = sim.simxStart('127.0.0.1',19999,true,true,5000,5);   
if ~(clientID > -1)
   return;
end

r = sim.simxSynchronous(clientID, true);
r = sim.simxStartSimulation(clientID, sim.simx_opmode_oneshot);
sim.simxSynchronousTrigger(clientID);

%try getting things here
[~, data] = sim.simxGetStringSignal(clientID, 'measuredDataAtThisTime0', sim.simx_opmode_blocking);
measuredData = sim.simxUnpackFloats(data);

if mod(length(measuredData), 3) == 0
    measuredData = reshape(measuredData, 3, []);  % Now it's 3 x N
end
scatter( measuredData(2, :), measuredData(1, :), 'filled');
xlabel('X'); ylabel('Y');
grid on;
title('LIDAR Point Cloud Data');

[r,sick_handle] = sim.simxGetObjectHandle(clientID, 'SICK_S300_fast', sim.simx_opmode_blocking); 
sim.simxReadVisionSensor(clientID, sick_handle, sim.simx_opmode_blocking);
[r,signal_value] = sim.simxGetAndClearStringSignal(clientID, 'measuredDataAtThisTime0',sim.simx_opmode_streaming);
pause(0.1);



[s_r,signal_value] = sim.simxGetAndClearStringSignal(clientID, 'measuredDataAtThisTime0',sim.simx_opmode_buffer);
pause(0.1);

if s_r == sim.simx_return_ok
    [r,signal_value] =sim.simxGetAndClearStringSignal(clientID, 'measuredDataAtThisTime0',sim.simx_opmode_streaming);
end

values = sim.simxUnpackFloats(signal_value)

          
end

