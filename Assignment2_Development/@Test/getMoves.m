function [cup, cupMoving, cupTR] = getMoves(self)
%GETWALLMOVES This function iterates through each move and creates the
%requried transform for the robot and brick to move from it's initial to
%final position
    % Move to ccup
    % Pick up cup
    % Drop cup off


% cupH = transl(0,0,-0.06);

%% move1 robot1->cup1 
cup{1} = self.cups{1}; %go to cup
cupMoving{1} = false;
cupTR{1} = transl(cup{1}.position)*transl(0,0,0.12);

%% move2 robot1&cup1->person 
cup{2} = self.cups{1}; %pick up cup
cupMoving{2} = false;
cupTR{2} = transl(cup{1}.position)*transl(0,0,0.1);

%% move3 robot1&cup1->person 
cup{3} = self.cups{1}; %drop off cup
cupMoving{3} = true;
cupTR{3} = self.cupEndLocations{1};

end

