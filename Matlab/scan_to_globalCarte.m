function[x_global, y_global] = scan_to_globalCarte(app, scan)

x_global = zeros(684,1);
y_global = zeros(684,1);
%calculate rotation and translation matrices from global -> local FoR
%app.Robot_x = cos(app.currentTheta) *app.distance_to_bot;
%app.Robot_y = sin(app.currentTheta) * app.distance_to_bot;

T_Rotation = [cos(app.currentTheta),sin(app.currentTheta),0; -sin(app.currentTheta), cos(app.currentTheta),0;0,0,1];
T_Translation = [app.Robot_x,app.Robot_y,0];
%calculate local distance

if mod(length(scan), 3) == 0 
    measuredData = reshape(scan, 3, []);  % Now it's 3 x 684
end

for i=1:684
    x_local = measuredData(1,i);
    y_local = measuredData(2,i);
    p_local = [x_local,y_local,0]'; %account for sensor local displacement
    pos = T_Rotation * p_local + T_Translation;
    x_global(i) = pos(2)*100;
    y_global(i) = pos(1)*100;
    
%calculate transformation  https://kineticstoolkit.uqam.ca/doc/geometry_transform_local_to_global_coordinates.html  
end 

end