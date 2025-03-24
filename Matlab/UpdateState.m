function UpdateState(app)
	%velocity and angular velocity are global	
	dx = app.Velocity(1) * app.dt;
	dy = app.Velocity(2) * app.dt; 
	dTheta = -(app.angularVelocity(3) * app.dt); %call this relative to the sensor
	app.Robot_x = app.Robot_x + dx;
	app.Robot_y = app.Robot_y + dy;
	app.currentTheta = app.currentTheta + dTheta;
	if app.currentTheta > 2*pi || app.currentTheta < -(2*pi)
		app.currentTheta = app.currentTheta/(2*pi);
	end
	app.currentDistance = sqrt(app.Robot_x^2  + app.Robot_y^2);
end