function [scan] = getVisionScanner(app)
    if app.sicko == 0
        [~, data] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0', app.sim.simx_opmode_streaming);
        app.sicko = -1;
        pause(0.1);
    end

    [r, data] = app.sim.simxGetStringSignal(app.clientID, 'measuredDataAtThisTime0',app.sim.simx_opmode_buffer);
    scan = app.sim.simxUnpackFloats(data);
end