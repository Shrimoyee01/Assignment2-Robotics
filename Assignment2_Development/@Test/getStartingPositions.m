

function [cupStartLocations, cupEndLocations, robotBase ...
    ] = getStartingPositions(~)
%GETSTARTINGPOSITIONS This function sets all the starting locations for the robot
%animation
%   cupStartLocations set's the locations for each of the bricks

    %tableHeight is used for the robot base, cup start and end locations 

%     tableH = 0.4;
%     cupW = 0.2669;
%     cupH = 0.0667;

    %Cup start locations
    cupStartLocations{1} = transl(1.2, -1.05,  1.2);
    cupStartLocations{2} = transl(1,   -1.05,  1.2);
    cupStartLocations{3} = transl(0.8, -1.05,  1.2);

    %Robot Base Location
    robotBase = [1, 0.2, 1.0];

%     cupEndLocations{1}= transl( robotBase(1,1) ,0.5, 0.5  );
%     cupEndLocations{2}= transl( robotBase(1,1) ,0.5, 0  );
%     cupEndLocations{3}= transl( robotBase(1,1) ,0.5, 0  );
    cupEndLocations{1}= transl( 0.5 ,0, 1.5  );
    cupEndLocations{2}= transl( 0.5 ,0, 1.5  );
    cupEndLocations{3}= transl( 0.5 ,0, 1.5  );


end