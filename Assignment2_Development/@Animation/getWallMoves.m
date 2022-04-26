function [brickR1, brickR2, brickMovingR1, brickMovingR2, brickTR1, brickTR2] = getWallMoves(self)
%GETWALLMOVES This function iterates through each move and creates the
%requried transform for the robot and brick to move from it's initial to
%final position
    % Move to closest brick
    % Pick up brick
    % Drop brick off
%%move1 robot1->brick , robot2 do nothing
%%move2 robot1&brick->wall , robot2->brick 
%%move3 robot1->brick , robot2&brick->wall 
%%move4 robot1&brick->wall , robot2->brick 
%%move5 robot1->brick , robot2&brick->wall 
%%move6 robot1&brick->wall , robot2->brick 
%%move7 robot1->brick , robot2&brick->wall 
%%move8 robot1&brick->wall , robot2->brick 
%%move9 robot1->brick , robot2&brick->wall 
%%move10 robot1&brick->wall , robot2 return to normal pose
%%move11 robot2 return to normal pose, robot2 do nothing

brickH = transl(0,0,-0.06);

%% move1 robot1->brick1 , robot2 do nothing
brickR1{1} = self.bricks{1}; %go to brick
brickMovingR1{1} = false;
brickTR1{1} = transl(brickR1{1}.position)*transl(0,0,0.4);
%R2 do nothing
brickR2{1} =self.bricks{2};
brickMovingR2{1}=false;
brickTR2{1} =self.brickWallLocations{1}*transl(0,0,0.6);

%% move2 robot1&brick1->wall , robot2->brick2
brickR1{2} = self.bricks{1}; %pick up brick
brickMovingR1{2} = false;
brickTR1{2} = transl(brickR1{1}.position)*transl(0,0,0.06);
%R2 robot2->brick2
brickR2{2} = self.bricks{2}; %go to brick
brickMovingR2{2} = false;
brickTR2{2} = transl(brickR2{2}.position)*transl(0,0,0.07);

%% move3 robot1&brick1->wall , robot2&brick2->wall
brickR1{3} = self.bricks{1}; %drop off brick
brickMovingR1{3} = true;
brickTR1{3} = self.brickWallLocations{1}*transl(0,0,0);
%R2 robot2&brick2->wall
brickR2{3} = self.bricks{2}; %pick up brick
brickMovingR2{3} = true;
brickTR2{3} = self.brickWallLocations{2}*transl(0,0,0.3);
%% move4 robot1->brick3 , robot2&brick2->wall
brickR1{4} = self.bricks{3}; %go to brick
brickMovingR1{4} = false;
brickTR1{4} = transl(brickR1{3}.position)*transl(0,0,0.06);

%R2 robot2&brick2->wall
brickR2{4} = self.bricks{2}; %drop off brick
brickMovingR2{4} = true;
brickTR2{4} = self.brickWallLocations{2}*transl(0,0,0);
%% move5 robot1&brick3->wall, robot2->brick4
brickR1{5} = self.bricks{3}; %pick up brick
brickMovingR1{5} = true;
brickTR1{5} = self.brickWallLocations{3}*transl(0,0,0.03);

%R2 robot2->brick4
brickR2{5} = self.bricks{4}; %go to brick
brickMovingR2{5} = false;
brickTR2{5} = transl(brickR2{4}.position)*transl(0,0,0.07);
%% move6 robot1&brick3->wall, robot2&brick4->wall
brickR1{6} = self.bricks{3}; %drop off brick
brickMovingR1{6} = true;
brickTR1{6} = self.brickWallLocations{3}*transl(0,0,0);

%R2 robot2&brick4->wall
brickR2{6} = self.bricks{4}; %pick up brick
brickMovingR2{6} = true;
brickTR2{6} = self.brickWallLocations{4}*transl(0,0,0.3);
%% move7 robot1->brick6, robot2&brick4->wall
brickR1{7} = self.bricks{6}; %go to brick
brickMovingR1{7} = false;
brickTR1{7} = transl(brickR1{6}.position)*transl(0,0,0.06);

%R2 robot2&brick4->wall
brickR2{7} = self.bricks{4}; %drop off brick
brickMovingR2{7} = true;
brickTR2{7} = self.brickWallLocations{4}*transl(0,0,0);
%% move8 robot1&brick6->wall, robot2->brick5
brickR1{8} = self.bricks{6}; %pick up brick
brickMovingR1{8} = true;
brickTR1{8} = self.brickWallLocations{6}*transl(0,0,0.03);

%R2 robot2->brick5
brickR2{8} = self.bricks{5}; %go to brick
brickMovingR2{8} = false;
brickTR2{8} = transl(brickR2{5}.position)*transl(0,0,0);
%% move9 robot1&brick6->wall, robot2&brick5->wall
brickR1{9} = self.bricks{6}; %drop off brick
brickMovingR1{9} = true;
brickTR1{9} = self.brickWallLocations{6}*transl(0,0,0);

%R2 robot2&brick5->wall
brickR2{9} = brickR2{8}; %pick up brick
brickMovingR2{9} = true;
brickTR2{9} = self.brickWallLocations{5}*transl(0,0,0.3);
%% move10 robot1->brick7 , robot2&brick5->wall
brickR1{10} = self.bricks{7}; %go to brick
brickMovingR1{10} = false;
brickTR1{10} = transl(brickR1{7}.position)*transl(0,0,0.06);

%R2 robot2&brick4->wall
brickR2{10} =  self.bricks{5}; %drop off brick
brickMovingR2{10} = true;
brickTR2{10} = self.brickWallLocations{5}*transl(0,0,0);
%% move11 robot1&brick7->wall,  robot2->brick8
brickR1{11} = self.bricks{7}; %pick up brick
brickMovingR1{11} = true;
brickTR1{11} = self.brickWallLocations{7}*transl(0,0,0.03);

%R2 robot2->brick5
brickR2{11} = self.bricks{8}; %go to brick
brickMovingR2{11} = false;
brickTR2{11} = transl(brickR2{8}.position)*transl(0,0,0);

%% move12 robot1&brick7->wall, robot2&brick8->wall
brickR1{12} = self.bricks{7}; %drop off brick
brickMovingR1{12} = true;
brickTR1{12} = self.brickWallLocations{7}*transl(0,0,0);

%R2 robot2&brick5->wall
brickR2{12} =  self.bricks{8}; %pick up brick
brickMovingR2{12} = true;
brickTR2{12} = self.brickWallLocations{8}*transl(0,0,0.3);
%% move13 robot1->brick9 , robot2&brick8->wall
brickR1{13} = self.bricks{9}; %go to brick
brickMovingR1{13} = false;
brickTR1{13} = transl(brickR1{9}.position);

%R2 robot2&brick4->wall
brickR2{13} =  self.bricks{8}; %drop off brick
brickMovingR2{13} = true;
brickTR2{13} = self.brickWallLocations{8}*transl(0,0,0);
%% move14 robot1&brick9->wall, robot2 do nothing
brickR1{14} = self.bricks{9}; %pick up brick
brickMovingR1{14} = true;
brickTR1{14} = self.brickWallLocations{9}*transl(0,0,0);

%R2 robot2->brick5
brickR2{14} = self.bricks{8}; %
brickMovingR2{14} = false;
brickTR2{14} = self.robot2Base*transl(0,0,0.4);

%% move15 robot1->nuetral , robot2 -> neutral
brickR1{15} = self.bricks{6}; %
brickMovingR1{15} = false;
brickTR1{15} = self.robot1Base*transl(0,0,0.4);

%R2 robot2->brick5
brickR2{15} = self.bricks{5}; %
brickMovingR2{15} = false;
brickTR2{15} = self.robot2Base*transl(0,0,0.4);


end

