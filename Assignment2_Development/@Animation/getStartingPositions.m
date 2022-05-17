

function [cupStartLocations, cupEndLocations, personStartLocation,...
    personEndLocation, robotBase] = getStartingPositions(~)
%GETSTARTINGPOSITIONS This function sets all the starting locations for the robot
%animation

%Robot Base Location
    robotBase = [1, 0.2, 1.03];

    %Cup start locations
    cupStartLocations{1} = transl(1.2, -1.05,  1.2);
    cupStartLocations{2} = transl(1,   -1.05,  1.2);
    cupStartLocations{3} = transl(0.8, -1.05,  1.2);
    
    %Cup end locations
    cupEndLocations{1}= transl( 0.5 ,0, 1.4);
    cupEndLocations{2}= transl( 0.5 ,0, 1.4);
    cupEndLocations{3}= transl( 0.5 ,0, 1.5);

    %person end locations
    personStartLocation{1} = transl(-1, 0.15, 0.03);
    personStartLocation{2} = transl(-1, -1, 0.03);
    personStartLocation{3} = transl(-1, -2, 0.03);

    %person end locations
    personEndLocation{1} = transl(-0.1, 0.15, 0.03);
    personEndLocation{2} = transl(-0.1, 0.15, 0.03);
    personEndLocation{3} = transl(-0.1, 0.15, 0.03);


end