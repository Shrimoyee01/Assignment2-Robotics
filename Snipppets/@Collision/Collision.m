% classdef Collision < handle
%     properties
%         % move robot
%         % move person
%         % point cloud || triangular mesh
%         CheckCollision;
%         person;
%     end
%
%     methods

%%
function CheckCollision(robot, rectangleCenter, halfWidth)
clc
clear
clf
locationPerson = transl(-2,0.35,0);

person = Thing("person5", locationPerson);
% person("scale", 0.2);
hold on;
PlaceObject('barrier.ply',[-1,0.35,1]);
hold on;
robot = IRB120(0,0,0);
hold on;

% create a box

% move person
% for q = -2:2:0.5
%     
%     drawnow();
pause(0.1)

% plot point clound
tri = delaunay(X, Y, Z);
personTri_h = trimes(tri,X,Y,Z);
drawnow();
view(3)
axis equal)
% tr = IRB120.fkine(IRB120.getpos);
%     endEffectorToCenterDist =
end
%     end

%% Move Robot



%
% for
%
%     if person plane + barrier plane - robot = intersecting
%         {
%             alarms go off
%             }
%
%
%         1. make person a square
%         2. make barrier square
%