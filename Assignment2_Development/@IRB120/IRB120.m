%%IRB120Class
classdef IRB120 < handle
    properties
        %> Robot model
        model;

        %>
        workspace = [-3 3 -3 3 -0.01 2.5];

        %> Flag to indicate if gripper is used
        useGripper = false;

        %> robotic base location
        maxWorkspace;

        %>
        xPos;
        yPos;
        zPos;
        zYaw;

        qlim;

    end

    methods%% Class for UR5 robot simulation
        function self = IRB120(xPosition, yPosition, zPosition)

            %> Position for base of robot
            self.xPos = xPosition;
            self.yPos = yPosition;
            self.zPos = zPosition;
            

            % robot =
            self.GetIRB120Robot();

            % robot =
            self.PlotAndColourRobot();

            % Workspace
            %             self.sampleSpace();

        end

        %% GetUR3Robot
        % Given a name (optional), create and return a UR3 robot model
        function GetIRB120Robot(self)
            %     if nargin < 1
            % Create a unique name (ms timestamp after 1ms pause)
            pause(0.001);
            name = ['IRB120_',datestr(now,'yyyymmddTHHMMSSFFF')];


            % theta=q, d=0, a=0, alpha=0, joint type
            % theta: rotation about Z
            % d translation alonog the Z axis
            % a translation along the x axis
            % alpha: rotatio about the x axis
            % prismatic or rotational
            L(1) = Link([pi     0          0         pi/2   1]); % PRISMATIC Link
            L(2) = Link([0      0.29       0         -pi/2  0]);
            L(3) = Link([-pi/2  0          0.27      0      0]);
            L(4) = Link([0      0          0.07      -pi/2  0]);
            L(5) = Link([0      0.302      0         pi/2   0]);
            L(6) = Link([0      0          0         -pi/2  0]);
            L(7) = Link([0      0.072      0          0     0]);

            % Incorporate joint limits
            L(1).qlim = [-0.8 0]; % assumed from linear UR5
            L(2).qlim = [-180 180]*pi/180;
            L(3).qlim = [-110 110]*pi/180;
            L(4).qlim = [-110 70]*pi/180;
            L(5).qlim = [-160 160]*pi/180;
            L(6).qlim = [-120 120]*pi/180;
            L(7).qlim = [-400 400]*pi/180;

            % offset: kinematic joint coordinate offsets (Nx1)
            L(2).offset =  -pi;
            L(3).offset =  -pi/2;
            L(5).offset =  pi;
            L(6).offset =  pi;

            self.model = SerialLink(L,'name','IRB');

            %set up the base location and robot orientation
            self.model.base = self.model.base * transl(self.xPos,self.yPos,self.zPos);
            self.model.base = self.model.base * trotx(pi/2) * troty(pi);

        end
        %% PlotAndColourRobot
        % Given a robot index, add the glyphs (vertices and faces) and
        % colour them in if data is available
        function PlotAndColourRobot(self) %robot,workspace)
            for linkIndex = 0:self.model.n
                if self.useGripper && linkIndex == self.model.n
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['R120Link',num2str(linkIndex),'Gripper.ply'],'tri'); %#ok<AGROW>
                else
                    [ faceData, vertexData, plyData{linkIndex+1} ] = plyread(['R120Link',num2str(linkIndex),'.ply'],'tri'); %#ok<AGROW>
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