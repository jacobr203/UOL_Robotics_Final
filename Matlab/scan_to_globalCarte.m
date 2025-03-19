function[x_global, y_global] = scan_to_globalCarte(app, scn, rayAngles)
%local coordinates are just cos, sin of the (depth/256)*100cm for ray i, use ith value of angles
x_global = zeros(512,1);
y_global = zeros(512,1);
%calculate rotation and translation matrices from global -> local FoR
theta_to_Robot = atan(app.distance_to_bot);
app.Robot_x = cos(theta_to_Robot) *app.distance_to_bot ;
app.Robot_y = sin(theta_to_Robot) * app.distance_to_bot;

T_Rotation = [cos(app.currentTheta),sin(app.currentTheta),0; -sin(app.currentTheta), cos(app.currentTheta),0;0,0,1];
T_Translation = [app.Robot_x,app.Robot_y,0];
%calculate local distance
for i=1:512
    x_local = scn(i)*(3.90625)*100*cos(rayAngles(i));
    y_local = scn(i)*(3.90625)*100*sin(rayAngles(i));
    p_local = [x_local,y_local,0]';
    pos = T_Rotation * p_local + T_Translation;
    x_global(i) = pos(1);
    y_global(i) = pos(2);
%calculate transformation inverse https://kineticstoolkit.uqam.ca/doc/geometry_transform_local_to_global_coordinates.html  
end 

end