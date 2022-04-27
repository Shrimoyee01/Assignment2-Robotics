classdef GetRobotReachAndVolume < handle
    %This class will accept a robot, and return its maximum reach and work volume

    properties
        robot_;
        plane_;
        pointCloud_;
        planeRadius_;
    end

    methods
        function self = GetRobotReachAndVolume(robot, plane, pointCloud)
            self.robot_ = robot;
            self.plane_ = plane;
            self.pointCloud_ = pointCloud;
            switch(plane)
                case 'XY'
                    centre = transl(robot.model.base);
                    xValues = pointCloud(:, 1);
                    yValues = pointCloud(:, 2);
                    radiiList = zeros(360, 1);
                    for i = 1:360
                        radiiList(i, 1) = sqrt((centre(1, 1)- xValues(i, 1)).^2 + (centre(2, 1) - yValues(i, 1)).^2);
                    end
                    planeRadius = mean(radiiList);
                    self.planeRadius_ = planeRadius;

                case 'XZ'
                    centre = transl(robot.model.base);
                    xValues = pointCloud(:, 1);
                    zValues = pointCloud(:, 3);
                    radiiList = zeros(360, 1);
                    for i = 1:360
                        radiiList(i, 1) = sqrt((centre(1, 1)- xValues(i, 1)).^2 + (centre(2, 1) - zValues(i, 1)).^2);
                    end
                    planeRadius = mean(radiiList);
                    self.planeRadius_ = planeRadius;
            end
        end


        function planePointCloud = getPlanePointCloud(robot, plane)
        robot = self.robot_;
        plane = self.plane_;

            switch(plane)
                case 'XY'
                    q = zeros(6, 1);
                    q(2, 1) = pi/2;
                    counter = 1;
                    planePointCloud = zeros(360, 3);
                    for q1 = 0:pi/180:2*pi
                        q(1, 1) = q1;
                        tr = robot.model.fkine(q);
                        planePointCloud(counter, :) = tr(1:3, 4)';
                        counter = counter + 1;
                    end

                case 'XZ'
                    q = zeros(6, 1);
                    counter = 1;
                    planePointCloud = zeros(360, 3);
                    for q2 = 0:pi/180:2*pi
                        q(2, 1) = q2;
                        tr = robot.model.fkine(q);
                        planePointCloud(counter, :) = tr(1:3, 4)';
                        planePointCloud(counter, 3) = planePointCloud(counter, 3) - 0.1519;
                        counter = counter + 1;
                    end
            end
        end

        function [maximumReachAndVolume] = GetMaximumReachAndVolume(robot)
            robot = self.robot_;
            

            maximumReachAndVolume = zeros(3, 1); %3 rows in order: XYRadius, XZRadius, Volume
            XYPointCloud = robot.getPlanePointCloud('XY');
            XZPointCloud = robot.getPlanePointCloud('XZ');
            %XY graph
            %figure('Name', 'XYCircle');
            XYRadius = robot.GetRobotReachAndVolume('XY', XYPointCloud);
            plot(XYPointCloud(:, 1), XYPointCloud(:, 2), 'r.');
            maximumReachAndVolume(1, 1) = XYRadius;
            XYRadiusDisp = ['XYRadius = ', num2str(XYRadius), 'm'];
            disp(XYRadiusDisp);

            %XZ graph
            %figure('Name', 'XZCircle');
            XZRadius = robot.GetRobotReachAndVolume('XZ', XZPointCloud);
            %plot(XZPointCloud(:, 1), XZPointCloud(:, 3), 'r.');
            maximumReachAndVolume(2, 1) = XZRadius;
            XZRadiusDisp = ['XZRadius = ', num2str(XZRadius), 'm'];
            disp(XZRadiusDisp);

            %Volume
            volume = 4/3*pi*XYRadius*XZRadius.^2; %formula for ellipse volume
            maximumReachAndVolume(3, 1) = volume;
            volumeDisp = ['volume = ', num2str(volume), 'm^3'];
            disp(volumeDisp);
        end
    end
end