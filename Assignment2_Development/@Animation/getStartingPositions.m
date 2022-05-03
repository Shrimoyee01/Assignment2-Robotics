

function [brickLocations, brickWallLocations, robot1Base ...
    ] = getStartingPositions(~)
%GETSTARTINGPOSITIONS This function sets all the starting locations for the robot
%animation
%   brickTransformList set's the locations for each of the bricks

    %tableHeight is used for the robot base, brick spawn locations and wall
    %location
    tableH = 0.4;
    brickW = 0.2669;
    brickH = 0.0667;

    %Robot 1 Bricks
    brickLocations{1} = transl(-0.3+0.02, -0.3, tableH);
    brickLocations{3} = transl(-0.25, -0.2, tableH);
    brickLocations{6} = transl(-0.4,  -0.25+0.02, tableH);
    brickLocations{7} = transl(0.4,  -0.2, tableH);
    brickLocations{9} = transl(0.4,  -0.4, tableH);
    %Robot 2 Bricks
    brickLocations{2} = transl( -0.4, 0.7, tableH);
    brickLocations{4} = transl( 0.4, 0.7, tableH);
    brickLocations{5} = transl(0.6, 0.5, tableH);
    brickLocations{8} = transl(-0.6, 0.5, tableH);
    
    %Robot 1 Base Location
    robot1Base = transl(0, -0.3, tableH)*trotz(pi/2);

    brickWallLocations{1}= transl( robot1Base(1,1)         ,0, tableH           );
    brickWallLocations{2}= transl((robot1Base(1,1)-brickW) ,0, tableH           );
    brickWallLocations{3}= transl((robot1Base(1,1)+brickW) ,0, tableH           );
    brickWallLocations{4}= transl( robot1Base(1,1)         ,0, (tableH+brickH)  );
    brickWallLocations{5}= transl((robot1Base(1,1)-brickW) ,0, (tableH+brickH)  );
    brickWallLocations{6}= transl((robot1Base(1,1)+brickW) ,0, (tableH+brickH)  );
    brickWallLocations{7}= transl( robot1Base(1,1)         ,0, (tableH+brickH*2));
    brickWallLocations{8}= transl((robot1Base(1,1)-brickW) ,0, (tableH+brickH*2));
    brickWallLocations{9}= transl((robot1Base(1,1)+brickW) ,0, (tableH+brickH*2));


end