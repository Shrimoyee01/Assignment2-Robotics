function stopState = lineHitboxIntersection(hitbox, robot, linePoint1, linePoint2, currentJointValues)
    stopState = 0;
    for i = 1 : 12
        faceIndexes = hitbox.faces(i, :);
        faceNormals = hitbox.getFaceNormals;
        hitboxFaceNormal = faceNormals(i, :);
        triangleVert1 = hitbox.vertices(faceIndexes(1, 1), :);
        triangleVert2 = hitbox.vertices(faceIndexes(1, 2), :);
        triangleVert3 = hitbox.vertices(faceIndexes(1, 3), :);
        isIntersectingTriangle = lineTriangleIntersection(linePoint1, linePoint2, hitboxFaceNormal, triangleVert1, triangleVert2, triangleVert3);
        if isIntersectingTriangle == 1
            stopState = 1;
            display("ouch");
        end
    end
end