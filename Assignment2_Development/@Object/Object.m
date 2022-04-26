
classdef Brick < handle
	properties
		faces;
		points;
		numPoints;
		brick_h;
        position;
	end

	methods
        function self = Brick(inputLocation)
            if nargin > 0
                startLocation = transl(inputLocation);
                self.position = startLocation;
                [faces, points, data] = plyread("brick.ply", "tri");
                self.faces = faces;
                self.points = points;
                self.numPoints = height(points);
                self.brick_h = self.makeBrick(faces, points);
                self.updatePosition(inputLocation);                
                drawnow();
            end
        end
		
		function brick_h = makeBrick(~, faces, points)
			hold on
			brick_h = trisurf(faces, points(:, 1), points(:, 2), points(:, 3), "LineStyle", "none",'Facecolor', [0.55 0.27 0.07]);
			hold off
		end
		
        function updatePosition(self, targetLocation)
			for i = 1:self.numPoints
				self.brick_h.Vertices(i, :) = transl(targetLocation * transl(self.points(i, :)))';
			end
		end
		
	end
end