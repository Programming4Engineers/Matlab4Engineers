function drawProjectile(time, px, py, extents)
% drawWheelchair(time,pos,phi, extents)
%
% INPUTS:
%   time = [scalar] = current time in the simulation
%   pos = [scalar] = position of the rear axle
%   extents = [xLow, xUpp, yLow, yUpp] = boundary of the draw window
%
% OUTPUTS:
%   --> Draw of the wheelchair, "at least, part of the wheel" 

% Make plot objects global
global projectileHandle;

projectileColor = [0, 0, 1];   % [R, G, B]

% Title and simulation time:
title(sprintf('Trajectory simulation ... t = %2.2f%',time));

% Draw the projectile:
if isempty(projectileHandle)
    projectileHandle = rectangle(...
        'Position',[px py 0.25 0.25],...
        'Curvature',[1,1],...   % <-- Draws a circle...
        'LineWidth',1,...
        'FaceColor',projectileColor,...
        'EdgeColor',projectileColor);
else
    set(projectileHandle,...
        'Position', [px py 0.25 0.25]);
end

% Format the axis so things look right:
axis equal; axis(extents); axis off; 

% Push the draw commands through the plot buffer
drawnow;

end