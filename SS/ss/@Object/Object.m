
classdef Object < handle
	properties
		faces;
		points;
		numPoints;
		object_h;
        position;
        name;
	end

	methods
        function self = Object(inputLocation)
            if nargin > 0
%                 self.name = name;
                startLocation = transl(inputLocation);
                self.position = startLocation;
%                 [faces, points, data] = plyread(name + ".ply", "tri");
                [faces, points, data] = plyread("brick.ply", "tri");
                self.faces = faces;
                self.points = points;
                self.numPoints = height(points);
                self.object_h = self.makeObject(faces, points);
                self.updatePosition(inputLocation);                
                drawnow();
            end
        end
		
		function object_h = makeObject(~, faces, points)
			hold on
			object_h = trisurf(faces, points(:, 1), points(:, 2), points(:, 3), "LineStyle", "none",'Facecolor', [0.55 0.27 0.07]);
			hold off
		end
		
        function updatePosition(self, targetLocation)
			for i = 1:self.numPoints
				self.object_h.Vertices(i, :) = transl(targetLocation * transl(self.points(i, :)))';
			end
		end
		
	end
end