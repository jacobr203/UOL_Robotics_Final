function UpdateState(app)
    %using velocity, angular velocity, and position update best guess for next state

    %ODE model
    %bla = [app.currentVelocity*app.dt; app.currentAngVelocity*app.dt].';
    %bla2 = [cos(app.currentTheta), sin(app.currentTheta),0;0,0,1];

    %ODE = bla*bla2;
    %dx = ODE(1);
    %dy = ODE(2);
    %dTheta = ODE(3);
    velocity_vector = [app.currentAngVelocity*app.dt, app.currentVelocity*app.dt].';
    M = [cos(app.currentTheta),0;sin(app.currentTheta),0;0,1]
    delta = M*velocity_vector; %[dx,dy,dtheta]

    app.currentTheta = app.currentTheta + delta(3);
    app.Robot_x = app.Robot_x + delta(1);
    app.Robot_y = app.Robot_y + delta(2);
    app.distance_to_bot = sqrt(app.Robot_x^2 + app.Robot_y^2);

    %handle new input values
    if app.inputVelocity ~= 0
        app.currentVelocity = app.inputVelocity;
        app.inputVelocity = 0;
        app.currentAngVelocity = 0;
        app.inputAngularVelocity = 0;

    elseif app.inputAngularVelocity ~= 0
        app.currentAngVelocity = app.inputAngularVelocity;
        app.inputAngularVelocity = 0;
        app.inputVelocity = 0;
    end

    if app.inputStop
        app.currentAngVelocity = 0;
        app.currentVelocity = 0;
        app.inputStop = false;
        app.inputVelocity = 0;
        app.inputAngularVelocity = 0;
    end
end

