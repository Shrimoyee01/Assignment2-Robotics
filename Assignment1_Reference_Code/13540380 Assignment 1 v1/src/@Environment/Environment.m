classdef Environment < handle
    %This class will build all of the necessary objects for the robotic
    %environment
    properties
        
    end

    methods
        function self = Environment (UR3Pos,UR5Pos)
            hold on

            %Load Floor & Wall Images
            surf([-4,-4;4,4],[-4,4;-4,4],[10e-3,10e-3;10e-3,10e-3],'CData',imread('concrete.jpg'),'FaceColor','texturemap'); %Loads a concreate floor
            surf([-4,-4;-4,-4],[-4,4;-4,4],[0,0;2.5,2.5],'CData',imread('brickWalls.jpg'),'FaceColor','texturemap'); %Loads a brick wall
            surf([-4,4;-4,4],[-4,-4;-4,-4],[0,0;2.5,2.5],'CData',imread('brickWalls.jpg'),'FaceColor','texturemap'); %Loads a brick wall

            %Get the locations of the bricks
            ReturnUR3BrickList(CreateBricks(UR3Pos,UR5Pos));
            ReturnUR5BrickList(CreateBricks(UR3Pos,UR5Pos));

            %Place safety equipement in the environment
            PlaceObject('fireExtinguisher2.ply',[-1,2.8,0]);%Load in two fire extinguishers, located near the entrance to the enclosure
            PlaceObject('fireExtinguisher2.ply',[1,2.8,0]);

            PlaceObject('estop8.ply',[-3.08,3.1,1]); %Load in two e-stops, located near the entrance to the enclosure
            PlaceObject('estop8.ply',[3.08,3.1,1]);

            PlaceObject('robotEnclosurev7.ply',[0,0,0]); %Load the robot enclosure at (0,0,0)

        end

        
    end
end