%% Get laser scanner data
function plotLaserScanner(app)

[img1,img2] = getVisionScanner(app); % 1x256 1x256 double
scn = [img2,img1]; % 1x512 double

%% Plot laser scanner

x = zeros(1,512);
y = zeros(1,512);
xtmp = zeros(1,513);
ytmp = zeros(1,513);


for n = 1:512
    if ((scn(n) < 0.9) && (scn(n) > 0.04))
        x(n) = cos((n*1.42222222378*pi/512)) / (1-scn(n));
        y(n) = sin((n*1.42222222378*pi/512)) / (1-scn(n));
        %i=i+1;
    else
        x(n) = 0;
        y(n) = 0;
        xtmp(n) = cos((n*1.5*pi/512)) * 1;
        ytmp(n) = sin((n*1.5*pi/512)) * 1;
    end
end

all = [x;y];

cla(app.UIAxes);
hold(app.UIAxes, 'on') ;
fill(app.UIAxes, xtmp, ytmp, 'b') % Background
fill(app.UIAxes, x, y, 'r') % Detected objects
hold(app.UIAxes, 'off')
%clf
%hold on
%fill(xtmp, ytmp, 'b')
%ill(x, y, 'r')
end