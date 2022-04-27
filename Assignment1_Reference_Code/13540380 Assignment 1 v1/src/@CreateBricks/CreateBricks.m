classdef CreateBricks < handle
    %Create brick models from a ply file.

    properties

        %Global Class Variables
        Ur3BrickList_;
        Ur5BrickList_;



    end

    methods
        function self = CreateBricks(UR3Pos,UR5Pos)
            %Build the bricks using 'PlaceObject' & save the location

            %Next Functions in the class
            self.ReturnUR3BrickList;
            self.ReturnUR5BrickList;

            %Save user input of robot bas locations
            UR3Position = UR3Pos;
            UR5Position = UR5Pos;            

            %These variables save the x & y locations of the robot base centre
            D3X = UR3Position(1,1);
            D3Y = UR3Position(1,2);
            D5X = UR5Position(1,1);
            D5Y = UR5Position(1,2);

            %This block of code builds 4 bricks for the UR3 and 5 for the
            %UR5. The above variables are used so that the bricks will
            %always be created based on the location of the robot.
            Ur3BrickList{1,1} = [D3X+0.2,D3Y-0.3,0];
            Ur3BrickList{1,2} = [D3X+0.2,D3Y-0.5,0];
            Ur3BrickList{1,3} = [D3X-0.2,D3Y-0.3,0];
            Ur3BrickList{1,4} = [D3X-0.2,D3Y-0.5,0];

            Ur5BrickList{1,1} = [D5X-0.2,D5Y-0.5,0];
            Ur5BrickList{1,2} = [D5X+0.1,D5Y-0.5,0];
            Ur5BrickList{1,3} = [D5X+0.4,D5Y-0.5,0];
            Ur5BrickList{1,4} = [D5X+0.7,D5Y-0.5,0];
            Ur5BrickList{1,5} = [D5X+1.0,D5Y-0.5,0];

            %Place 5 bricks near the UR5
            for i = 1:5
                PlaceObject('Brick.ply',[Ur5BrickList{1,i}]);
            end
            %Place 4 bricks near the UR3
            for i = 1:4
                PlaceObject('Brick.ply',[Ur3BrickList{1,i}]);
            end

            %Passing local variables into global
            self.Ur3BrickList_ = Ur3BrickList;
            self.Ur5BrickList_ = Ur5BrickList;
        end

        function [ReturnUR3Bricks]= ReturnUR3BrickList(self)
            %Return the positions of all the bricks made for the UR3 robot

            ReturnUR3Bricks = self.Ur3BrickList_;

        end

        function [ReturnUR5Bricks] = ReturnUR5BrickList(self)
            %Return the positions of all the bricks made for the UR5 robot


            ReturnUR5Bricks = self.Ur5BrickList_;
        end
    end
end