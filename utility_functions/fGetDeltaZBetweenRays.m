function [ deltaZ ] = fGetDeltaZBetweenRays( point1, point2, theta1, theta2, geo, plotboolean )
%%% ------------------------------------------------------------------- %%%
% This function takes two points in two images, and calculates the
% following:
% 1) Their respective points (point3D_#) in 3D on their detector plane (m)
% 2) Their respective x-ray vector (vector3D_#) (m)
% 3) Where the vectors intersect in the xy plane 
% 4) The distance between vectors in the z-direction at the xy intersect
% 
% INPUTS
% point1 and 2 are pixel locations in [j,i] notation [row,column]
% theta1 and 2 are doubles in degrees
% geo is a struct data type 
% plotboolean is 0 or 1, 1 activates the diagnostic plot functionality
%
% OUTPUT
% deltaZ is the positive distance between the vectors at their xy intersect
% in meters
%
% Written by Grant Buster, summer 2015
% 
%%% ------------------------------------------------------------------- %%%

ppm=6993;

%% Get 3D point and vector for point1
theta1=-(theta1)*(pi/180);

% distance from axis of rotation (origin) to detector in x and y directions
Origin_to_Detector(1) = -geo.O_y * sin(theta1) ; % x axis
Origin_to_Detector(2) = geo.O_y * cos(theta1) ; % y axis

% location of point on detector plane
i= ( (point1(2)/ppm) - geo.O_x );
k= point1(1)/ppm;

% vector from center of detector to point on detector 
Detector_to_Point(1) = i*sin((pi/2)-theta1) ; % +x axis
Detector_to_Point(2) = i*cos((pi/2)-theta1) ; % +y axis

% location of the point source in x and y axis (sourceZ=0)
sourceX= geo.Y_of * sin(theta1) ;
sourceY= -geo.Y_of * cos(theta1) ;

% output the location of point1 on the detector plane in 3D in meters
point3D_1=[(Origin_to_Detector(1) + Detector_to_Point(1))
    (Origin_to_Detector(2) + Detector_to_Point(2))
    (geo.O_z - k)];

% output the vector from point1 to source1 in meters
vector3D_1=[-point3D_1(1)+sourceX;-point3D_1(2)+sourceY;-point3D_1(3)];

%% Get 3D point and vector for point2
theta2=-(theta2)*(pi/180);

% distance from axis of rotation (origin) to detector in x and y directions
Origin_to_Detector(1) = -geo.O_y * sin(theta2) ; % x axis
Origin_to_Detector(2) = geo.O_y * cos(theta2) ; % y axis

% location of point on detector plane
i= ( (point2(2)/ppm) - geo.O_x );
k= point2(1)/ppm;

% vector from center of detector to point on detector 
Detector_to_Point(1) = i*sin((pi/2)-theta2) ; % +x axis
Detector_to_Point(2) = i*cos((pi/2)-theta2) ; % +y axis

% location of the point source in x and y axis (sourceZ=0)
sourceX= geo.Y_of * sin(theta2) ;
sourceY= -geo.Y_of * cos(theta2) ;

% output the location of point1 on the detector plane in 3D in meters
point3D_2=[(Origin_to_Detector(1) + Detector_to_Point(1))
    (Origin_to_Detector(2) + Detector_to_Point(2))
    (geo.O_z - k)];

% output the vector from point1 to source1 in meters
vector3D_2=[-point3D_2(1)+sourceX;-point3D_2(2)+sourceY;-point3D_2(3)];

%% find intersection of the vectors 1 and 2 in the x-y plane
% solve for parametric variables
t2 = ( (vector3D_1(1)*point3D_2(2)) - (vector3D_1(1)*point3D_1(2)) - (vector3D_1(2)*point3D_2(1)) + (vector3D_1(2)*point3D_1(1)) ) / ( (vector3D_2(1)*vector3D_1(2)) - (vector3D_1(1)*vector3D_2(2)) );
t1 = ( (vector3D_2(1)*t2) + point3D_2(1) - point3D_1(1) ) / vector3D_1(1);
% use parametric variables to solve for xy intersection
intersection1=[(t1*vector3D_1(1))+point3D_1(1) , (t1*vector3D_1(2))+point3D_1(2) , (t1*vector3D_1(3)+point3D_1(3)) ];
intersection2=[(t2*vector3D_2(1))+point3D_2(1) , (t2*vector3D_2(2))+point3D_2(2) , (t2*vector3D_2(3)+point3D_2(3)) ];

%% Difference in vertical (z) location between vectors at the x-y intersection 

deltaZ=abs(intersection1(3)-intersection2(3));

%% diagnostics plot
if plotboolean==1
    figure('Color','w','WindowStyle','docked')
    hold on
    
    a=plot3(point3D_1(1),point3D_1(2),point3D_1(3),'bx');
    b=plot3(point3D_2(1),point3D_2(2),point3D_2(3),'rx');
    
    c=plot3([point3D_1(1)+vector3D_1(1),point3D_1(1)],...
        [point3D_1(2)+vector3D_1(2),point3D_1(2)],...
        [point3D_1(3)+vector3D_1(3),point3D_1(3)],'b-');
    
    d=plot3([point3D_2(1)+vector3D_2(1),point3D_2(1)],...
        [point3D_2(2)+vector3D_2(2),point3D_2(2)],...
        [point3D_2(3)+vector3D_2(3),point3D_2(3)],'r-');
    
    e=plot3([intersection1(1),intersection2(1)],...
        [intersection1(2),intersection2(2)],...
        [intersection1(3),intersection2(3)],'g-');
    
    string=['\Deltaz=',num2str(deltaZ),'m'];
    
    legend([a c b d e],'point1','vector1','point2','vector2',string)
    
    xlabel('x (m)')
    ylabel('y (m)')
    zlabel('z (m)')
    axis equal
    view([-45 20])
    
end

end

