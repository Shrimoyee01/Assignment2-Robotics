%CAFEENVIRONMENT This class loads and controls the environment for the cafe
% It loads the floor and wall surfaces and places any static objects such
% as the counter within the cafe.

classdef CafeEnvironment < handle
    properties

    end
    methods
        function self = CafeEnvironment()
            hold on;
            disp('opening cafe...');
            
            CounterLoc = [0.5,-2.9,0.03];

            % Setup & Place Walls and Floor
            surf([-3,-3;3,3],[-3,3;-3,3],[10e-3,10e-3;10e-3,10e-3],'CData',imread('LightWoodenFloor.jpg'),'FaceColor','texturemap'); %Loads a wooden floor
            surf([-3,-3;-3,-3],[-3,3;-3,3],[0,0;2.5,2.5],'CData',imread('Enterance.png'),'FaceColor','texturemap'); %Loads a brick wall
            surf([-3,3;-3,3],[-3,-3;-3,-3],[0,0;2.5,2.5],'CData',imread('brickWalls.jpg'),'FaceColor','texturemap'); %Loads the cafe enterance

            % Setup & Place Static Objects 
            PlaceObject('counter.ply',[CounterLoc(1),CounterLoc(2),CounterLoc(3)]);
            PlaceObject('barrier.ply',[0.2,0.35,1]);
            PlaceObject('bin.ply',[-2.7,-2.7,0.1]);
            PlaceObject('camera.ply',[0.7,-2.1,1.28]);
            PlaceObject('table.ply',[-2,2.2,0]);
            PlaceObject('lights.ply',[0.6,1.5,1.03]);
            PlaceObject('lights.ply',[0.6,-1.2,1.03]);
            PlaceObject('estop8.ply',[2,-3,1]);
            PlaceObject('estop8.ply',[-0.5,-3,1]);
            PlaceObject('estop8.ply',[0.95,1.7,0.85]);
%             PlaceObject('cup5.ply',[-2.2,1.7,1.22]);
%             PlaceObject('cup5.ply',[-1.9,1.9,1.22]);
%             PlaceObject('cup5.ply',[-1.8,2.6,1.22]);
            PlaceObject('fireExtinguisher.ply',[2.6,-2.8,0.03]);

            % Setup Camera
            axis equal;
            camlight;
            view(3)

            hold off;

        end
    end
end






