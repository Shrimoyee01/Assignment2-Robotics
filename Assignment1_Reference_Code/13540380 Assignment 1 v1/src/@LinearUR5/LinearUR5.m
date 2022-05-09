classdef LinearUR5 < handle
    properties
        %> Robot model
        model;

        %>
        workspace = [-3 3 -3 3 0 3];


        %> Flag to indicate if gripper is used
        useGripper = false;
        xPos;
        yPos;
        zPos;
        zYaw;

    end

    methods%% Class for UR5 robot simulation
        function self = LinearUR5(useGripper, xPosition, yPosition, zPosition, zYawAmount)
            self.useGripper = useGripper;


            %Get location inputs
            self.xPos = xPosition;
            self.yPos = yPosition;
            self.zPos = zPosition;
            self.zYaw = (zYawAmount/360*pi*2);

            % robot =
            self.UR5RobotLocation();
            % robot =
            self.PlotAndColourRobot();%robot,workspace);
        end

        %% GetUR5Robot
        % Given a name (optional), create and return a UR5 robot model
        function [ReturnPosition] = UR5RobotLocation(self)
            %     if nargin < 1
            % Create a unique name (ms timestamp after 1ms pause)
            pause(0.001);
            name = ['LinearUR_5_',datestr(now,'yyyymmddTHHMMSSFFF')];
            %     end

            % Create the UR5 model mounted on a linear rail
            L(1) = Link([pi     0       0       pi/2    1]); % PRISMATIC Link
            L(2) = Link([0      0.1599  0       -pi/2   0]);
            L(3) = Link([0      0.1357  0.425   -pi     0]);
            L(4) = Link([0      0.1197  0.39243 pi      0]);
            L(5) = Link([0      0.093   0       -pi/2   0]);
            L(6) = Link([0      0.093   0       -pi/2	0]);
            L(7) = Link([0      0       0       0       0]);

            % Incorporate joint limits
            L(1).qlim = [-0.8 0];
            L(2).qlim = [-360 360]*pi/180;
            L(3).qlim = [-90 90]*pi/180;
            L(4).qlim = [-170 170]*pi/180;
            L(5).qlim = [-360 360]*pi/180;
            L(6).qlim = [-360 360]*pi/180;
            L(7).qlim = [-360 360]*pi/180;

            L(3).offset = -pi/2;
            L(5).offset = -pi/2;

            self.model = SerialLink(L,'name','UR5');

            % Rotate robot to the correct orientation
            self.model.base = self.model.base * transl(self.xPos,self.yPos,self.zPos);
            self.model.base = self.model.base * trotx(pi/2) * troty(pi/2) * troty(self.zYaw);

            %Return the location of the roboot base
            ReturnPosition = [self.xPos,self.yPos,self.zPos,self.zYaw];

%             scale = 0.5;
%             workspace = [-4 4 -4 4 0 3];
%             q = zeros(1,7);
%             self.model.plot(q,'workspace',workspace,'scale',scale);
%             newQ = self.model.ikine(transl(0.5,0.5,0.5));
%             %self.model.animate(newQ)
%             for y = -0.5:0.05:0.5
%                 newQ = self.model.ikine(transl(0.5,y,0.5),newQ);%,'alpha',0.01);
%                 self.model.animate(newQ);
%                 drawnow();
%             end



        end
        %% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available
        function PlotAndColourRobot(self)%robot,workspace)
            for linkIndex = 0:self.model.n
                if self.useGripper && linkIndex == self.model.n
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['LinUR5Link',num2str(linkIndex),'Gripper.ply'],'tri'); %#ok<AGROW>
                else
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['LinUR5Link',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
                end
                self.model.faces{linkIndex+1} = faceData;
                self.model.points{linkIndex+1} = vertexData;
            end

            % Display robot
            self.model.plot3d(zeros(1,self.model.n),'noarrow','workspace',self.workspace);
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end
            self.model.delay = 0;

            % Try to correctly colour the arm (if colours are in ply file data)
            for linkIndex = 0:self.model.n
                handles = findobj('Tag', self.model.name);
                h = get(handles,'UserData');
                try
                    h.link(linkIndex+1).Children.FaceVertexCData = [plyData{linkIndex+1}.vertex.red ...
                        , plyData{linkIndex+1}.vertex.green ...
                        , plyData{linkIndex+1}.vertex.blue]/255;
                    h.link(linkIndex+1).Children.FaceColor = 'interp';
                catch ME_1
                    disp(ME_1);
                    continue;
                end
            end
        end
    end
end