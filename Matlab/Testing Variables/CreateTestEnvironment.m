
%ideal environment is the map with its walls completely filled
%scoring for detection is as follows

gridData(326:464,264) = 0.999000012874603;
gridData(294:465,256:263) = 0.500026345252991;
gridData(175:230,347) = 0.999000012874603;
gridData(175:230,348:349) = 0.00100000004749745;

imagesc(gridData);  



%save('drawn');


%perimeter walls
%walls are 5cm thickS
% ideal_environment(1:500,1:5) = 10;
% ideal_environment(1:500,995:1000) = 10;
% ideal_environment(1:5,1:1000) = 10;
% ideal_environment(495:500,1:1000) = 10;
% 
% ideal_environment(328:331,229:649) = 10; %-----
% ideal_environment(144:330,229:231) = 10; %|
% ideal_environment(144:147,128:229) = 10;%---

%large boox

%objects in environment
% use point sampler (modules) to get the x, y coordinates. Add offset = the
% position
%ideal_environment(round(-80 +250): round(-75 +250) ,round(280) :round(649)) = 10;

