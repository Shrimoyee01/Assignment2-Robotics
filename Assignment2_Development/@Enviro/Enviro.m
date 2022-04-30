%% Enviroment setup
% This class loads and controls the environment for the robots
% It loads the floor and wall surfaces and places any static objects such
% as the table within the lab.

classdef Enviro < handle
properties
end
methods
    function self = Enviro()
    clf;
        hold on;
        disp('setting up room...');
        %% setup walls and floor
%         self.loadSurf();

        %% setup objects
        self.createObject('cup1.ply',transl(0,0,0));
%         self.createObject('fireExtinguisher.ply',transl(-2.8,2.8,0.5));
%         self.createObject('fireExtinguisher.ply',transl(2.8,-2.8,0.5));
%         self.createObject('button1.ply',transl(2,3,1));

        %% setup view range
%         xlim([-3 3]);
%         ylim([-3 3]);
%         zlim([-0.5 1]);

        axis equal;
        camlight;
        % view(3);

        hold off;

    end

    function loadSurf(~)
        %% setup walls and floor
        xRm = 3; %room x dimension
        yRm = 3; %room y dimension
        zRm = 2.7; %room z dimension

        %floor surface
        floor = imread('floor.jpg');
        surf([-xRm,-xRm;xRm,xRm],[-yRm,yRm;-yRm,yRm],[0.01,0.01;0.01,0.01],'CData', floor,'FaceColor','texturemap', ...
            'AmbientStrength',0.5,'FaceLighting','gouraud','AmbientStrength',0.5);
        
        %wall surfaces
        wall1 = imread('door.jpg');
        wall1 = imrotate(wall1,-90,'bilinear','loose');
        surf([-xRm,-xRm;-xRm,-xRm],[yRm,yRm;-yRm,-yRm],[0,zRm;0,zRm],'CData', wall1,'FaceColor','texturemap', 'AmbientStrength',0.5);
        surf([xRm,xRm;-xRm,-xRm],[yRm,yRm;yRm,yRm],[0,zRm;0,zRm],'CData', wall1,'FaceColor','texturemap', 'AmbientStrength',0.5);

    end

end
end