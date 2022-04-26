function isIntersectingTriangle = lineTriangleIntersection(linePoint1, linePoint2, hitboxFaceNormal, triangleVert1, triangleVert2, triangleVert3)
    intersectionPoint = [0, 0, 0];
    pointOnPlane = triangleVert1;
    u = linePoint2 - linePoint1;
    w = linePoint1 - pointOnPlane;
    D = dot(hitboxFaceNormal, u);
    N = -dot(hitboxFaceNormal, w);
    isIntersecting = 0;
    isIntersectingTriangle = 0;
    if abs(D) < 10^-7
        if N == 0
            isIntersecting = 1;
        else
            isIntersecting = 0;
        end
    end
    
    sI = N / D;
    intersectionPoint = linePoint1 + sI.*u;

    if (sI < 0 || sI > 1)
        isIntersecting = 0;
    else
        isIntersecting = 1;
    end

    if isIntersecting == 1;
        inTriangle = isPointInTriangle(intersectionPoint, triangleVert1, triangleVert2, triangleVert3);
        if inTriangle == 1
            isIntersectingTriangle = 1;
        end
    end

end
    

%barycentric
function inTriangle = isPointInTriangle(intersectionPoint, triangleVert1, triangleVert2, triangleVert3)
    v0 = triangleVert2 - triangleVert1;
    v1 = triangleVert3 - triangleVert1;
    v2 = intersectionPoint - triangleVert1;

    dot00 = dot(v0, v0);
    dot01 = dot(v0, v1);
    dot02 = dot(v0, v2);
    dot11 = dot(v1, v1);
    dot12 = dot(v1, v2);

    inverseDenominator = (dot01 * dot01 - dot00 * dot11);
    u = (dot00 * dot12 - dot01 * dot12) / inverseDenominator;
    v = (dot11 * dot02 - dot01 * dot02) / inverseDenominator;
    if (u < 0.0 || u > 1.0)
        inTriangle = 0;
        return;
    end

    if(v < 0.0 || (v + u) > 1)
        inTriangle = 0;
        return;
    end

    inTriangle = 1;
end

% function inTriangle = isPointInTriangle(interSectionPoint, triangleVert1, triangleVert2, triangleVert3)
%     if isPointSameSide(intersectionPoint, triangleVert1, triangleVert2, triangleVert3) && isPointSameSide(intersectionPoint, triangleVert2, triangleVert1, triangleVert3) && isPointSameSide(intersectionPoint, triangleVert3, triangleVert1, triangleVert2)
%         inTriangle = 1;
%     else
%         inTriangle = 0;
%     end
% end

% function sameSide = isPointSameSide(interSectionPoint, triangleVert1, triangleVert2, triangleVert3)
%     crossProduct1 = cross(triangleVert3 - triangleVert2, intersectionPoint -  triangleVert2);
%     crossProduct2= cross(triangleVert3 - triangleVert2, triangleVert1 -  triangleVert2);
%     if dot(crossProduct1, crossProduct2) >= 0
%         sameSide = 1;
%     else
%         sameSide = 0;
% end 
