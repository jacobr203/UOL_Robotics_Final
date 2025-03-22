function  NextAction(app)

%perform an action based on current configuration
switch app.LastCommand
		case 'Rotate'
			%StopMovement(app);
        	forwBackVel = 0; %-1, +1
            leftRightVel = 0; 
            rotVel = app.inputRotationDirection;
		case 'Translate'
			%StopMovement(app);
            forwBackVel = 2*app.inputTranslationDirection;
            leftRightVel = 0;
            rotVel = 0;
		case 'Stop'
			forwBackVel = 0;
            leftRightVel = 0;
            rotVel = 0;
    otherwise
        ClearInput(app);
        return;
end	

app.sim.simxSetJointTargetVelocity(app.clientID, app.h(1),-forwBackVel-leftRightVel-rotVel, app.sim.simx_opmode_streaming);
app.sim.simxSetJointTargetVelocity(app.clientID, app.h(2),-forwBackVel+leftRightVel-rotVel, app.sim.simx_opmode_streaming);
app.sim.simxSetJointTargetVelocity(app.clientID, app.h(3),-forwBackVel-leftRightVel+rotVel, app.sim.simx_opmode_streaming);
app.sim.simxSetJointTargetVelocity(app.clientID, app.h(4),-forwBackVel+leftRightVel+rotVel, app.sim.simx_opmode_streaming);
ClearInput(app);

end