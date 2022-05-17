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
cup{1} = self.cups{1}; %pick up cup
cupMoving{1} = false;
person{1} = self.person{1};
personMoving{1} = false;
cupTR{1} = transl(cup{1}.position)*transl(0,0,0.12);

%% move2 robot1&cup1->person 
cup{2} = self.cups{1}; %drop off cup
cupMoving{2} = true;
person{2} = self.person{1};
personMoving{2} = false;
cupTR{2} = self.cupEndLocations{1};

%% move3 Person-> Robot
cup{3} = self.cups{1}; %drop off cup
cupMoving{3} = false;
person{3} = self.person{1};
personMoving{3} = true;
cupTR{3} = self.cupEndLocations{1};

%% move4 robot1->Zero Position 
cup{4} = self.cups{1}; %drop off cup
cupMoving{4} = false;
person{4} = self.person{1};
personMoving{4} = false;
cupTR{4} = ZeroPosition;

%% -------------------------------------------------------------------------
%% move1 robot1->cup1 
cup{5} = self.cups{2}; %drop to cup
cupMoving{5} = false;
person{5} = self.person{2};
personMoving{5} = false;
cupTR{5} = transl(cup{5}.position)*transl(0,0,0.12);

%% move2 robot1&cup1->person 
cup{6} = self.cups{2}; %drop off cup
cupMoving{6} = true;
person{6} = self.person{2};
personMoving{6} = false;
cupTR{6} = self.cupEndLocations{2};

%% move3 Person-> Robot
cup{7} = self.cups{2}; %drop off cup
cupMoving{7} = false;
person{7} = self.person{2};
personMoving{7} = true;
cupTR{7} = ZeroPosition;

%% move4 robot1->Zero Position 
cup{8} = self.cups{2}; %drop off cup
cupMoving{8} = false;
person{8} = self.person{2};
personMoving{8} = false;
cupTR{8} = ZeroPosition;

%% -------------------------------------------------------------------------
%% move1 robot1->cup1 
cup{9} = self.cups{3}; %drop to cup
cupMoving{9} = false;
person{9} = self.person{3};
personMoving{9} = false;
cupTR{9} = transl(cup{9}.position)*transl(0,0,0.12);


%% move2 robot1&cup1->person 
cup{10} = self.cups{3}; %drop off cup
cupMoving{10} = true;
person{10} = self.person{3};
personMoving{10} = false;
cupTR{10} = self.cupEndLocations{3};

%% move3 Person-> Robot
cup{11} = self.cups{3}; %drop off cup
cupMoving{11} = false;
person{11} = self.person{3};
personMoving{11} = true;
cupTR{11} = ZeroPosition;

%% move4 robot1->Zero Position 
cup{12} = self.cups{3}; %drop off cup
cupMoving{12} = false;
person{12} = self.person{3};
personMoving{12} = false;
cupTR{12} = ZeroPosition;

end

