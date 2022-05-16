
classdef Thing < handle
	properties
		faces;
		points;
		numPoints;
		object_h;
        position;
        name;
        data;
	end

	methods
        function self = Thing(name,inputLocation)
            if nargin > 0
                self.name = name;
                startLocation = transl(inputLocation);
                self.position = startLocation;
                [faces, points, data] = plyread(name + ".ply", "tri");
%                 [faces, points, data] = plyread("cup1.ply", "tri");
                self.faces = faces;
                self.points = points;
                self.data = data;
                self.numPoints = height(points);
                self.object_h = self.makeObject(faces, points, data);
                self.updatePosition(inputLocation);                
                drawnow();
            end
        end
		
		function object_h = makeObject(~, faces, points, data)
			hold on
			object_h = trisurf(faces, points(:, 1), points(:, 2), points(:, 3), "LineStyle", "none");
			try set(self.object_h, 'FaceVertexCData', [data.vertex.red, data.vertex.green, data.vertex.green]/255);
            end
            hold off
		end
		
        function updatePosition(self, targetLocation)
			for i = 1:self.numPoints
				self.object_h.Vertices(i, :) = transl(targetLocation * transl(self.points(i, :)))';
			end
		end
		
	end
end