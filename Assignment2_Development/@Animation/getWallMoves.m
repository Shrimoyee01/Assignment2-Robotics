function [brickR1, brickMovingR1, brickTR1] = getWallMoves(self)
%GETWALLMOVES This function iterates through each move and creates the
%requried transform for the robot and brick to move from it's initial to
%final position

brickH = transl(0,0,-0.06);

%% move1 robot1->brick1 , robot2 do nothing
brickR1{1} = self.bricks{1}; %go to brick
brickMovingR1{1} = false;
brickTR1{1} = transl(brickR1{1}.position)*transl(0,0,0.4);



end

