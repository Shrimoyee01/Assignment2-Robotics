%% findClosestPointBetweenEffAndBrick
%this function finds the distance between each point on the brick and the
%end effector and returns the closest point on the brick by finding the

function pointCoordinates = findClosestPointBetweenEffAndBrick(~, robot, brick)
    brickXYZ = zeros(1, 3);
    EffXYZ = transl(robot.model.fkine(robot.model.getpos))';
    distanceList = zeros(964, 1);
    for i = 1:964
        brickXYZ(1, 1) = brick.points(i, 1) + brick.pos(1, 1);
        brickXYZ(1, 2) = brick.points(i, 2) + brick.pos(2, 1);
        brickXYZ(1, 3) = brick.points(i, 3) + brick.pos(3, 1);
        distance = sqrt((EffXYZ(1, 1) - brickXYZ(1, 1)).^2 + (EffXYZ(1, 2) - brickXYZ(1, 2)).^2 + (EffXYZ(1, 3) - brickXYZ(1, 3)).^2);
        distanceList(i, 1) = distance;
    end
    smallestDistance = min(distanceList);
    idx = distanceList == smallestDistance;
    pointCoordinates = brick.points(idx, :);
    pointCoordinates = pointCoordinates(1, :);
    pointCoordinates(1, 1) = pointCoordinates(1, 1) + brick.pos(1, 1);
    pointCoordinates(1, 2) = pointCoordinates(1, 2) + brick.pos(2, 1);
    pointCoordinates(1, 3) = pointCoordinates(1, 3) + brick.pos(3, 1);
end