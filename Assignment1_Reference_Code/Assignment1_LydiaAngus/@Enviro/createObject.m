

function createObject(~, fileName , loadLocation)
%LOADOBJECT This function creates a mesh object within the model at a given location 
%   xx

% [f,v,data] = plyread(fileName,'tri');
% vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255; %% Scale the colours to be 0-to-1 (they are originally 0 to 255)
% for xOffset = [0,0]
%     for yOffset = [0,0]
%         trisurf(f,v(:,1),v(:,2), v(:,3) ... % Then plot the trisurf with offset verticies
%             ,'FaceVertexCData',vertexColours,'EdgeColor','interp','EdgeLighting','flat');
%     end
% end

%         [f,v,data] = plyread(fileName,'tri');
%         % Scale the colours to be 0-to-1 (they are originally 0-to-255)
%         vertexColours = [data.vertex.red, data.vertex.green, data.vertex.blue] / 255;
%         % Then plot the trisurf
%         trisurf(f,v(:,1),v(:,2), v(:,3), 'FaceVertexCData',vertexColours, ...
%             'EdgeColor','interp','EdgeLighting','flat');

    objC = PlaceObject(fileName);
    vertices = get(objC,'Vertices');
    transformedVertices = [vertices,ones(size(vertices,1),1)]*loadLocation';
    set(objC,'Vertices',transformedVertices(:,1:3));

end