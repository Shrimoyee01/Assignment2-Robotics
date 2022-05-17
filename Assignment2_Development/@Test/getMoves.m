function [cup, cupMoving, person, personMoving, cupTR] = getMoves(self)
%GETWALLMOVES This function iterates through each move and creates the
%requried transform for the robot and brick to move from it's initial to
%final position
    % Move to ccup
    % Pick up cup
    % Drop cup off


% cupH = transl(0,0,-0.06);
ZeroPosition = [-0 0 1 0.77; 0 -1 0 0.20; 1 0 0 1.63; 0 0 0 1];

%% move1 robot1->cup1 
cup{1} = self.cups{1}; %go to cup
cupMoving{1} = false;
person{1} = self.person{1};
personMoving{1} = false;
cupTR{1} = transl(cup{1}.position)*transl(0,0,0.12);

%% move2 robot1&cup1->person 
cup{2} = self.cups{1}; %pick up cup
cupMoving{2} = false;
person{2} = self.person{1};
personMoving{2} = false;
cupTR{2} = transl(cup{1}.position)*transl(0,0,0.1);

%% move3 robot1&cup1->person 
cup{3} = self.cups{1}; %drop off cup
cupMoving{3} = true;
person{3} = self.person{1};
personMoving{3} = false;
cupTR{3} = self.cupEndLocations{1};

%% move4 Person-> Robot
cup{4} = self.cups{1}; %drop off cup
cupMoving{4} = true;
person{4} = self.person{1};
personMoving{4} = true;
cupTR{4} = ZeroPosition;

%% move5 robot1->Zero Position 
cup{5} = self.cups{1}; %drop off cup
cupMoving{5} = false;
person{5} = self.person{1};
personMoving{5} = false;
cupTR{5} = ZeroPosition;

end

