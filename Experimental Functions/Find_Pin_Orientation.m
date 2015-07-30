function [ Direction ] = Find_Pin_Orientation( x,y,z , geo, imageangle, contrast, luminosity , threshold , plotboolean)
% Given a 3D location (x,y,z in meters) that is likely on a pin, this
% function scans a sphere around the input point, attempting to find the
% most likely direction/orientation of the pin 

% INPUTS
% x y z are each double values in meters
% geo is a structure data type with standard geo parameters
% Image angle is a structure with .a .b .c .d .e for all 5 image angles
% contrast and luminosity are structure data types with a-e defined by
% 3000x3000 matricies 
% Threshold is a structure containing user defined thresholds
% plot boolean is 0 or 1 and activates diagnostic plots


% OUTPUTS
% Direction is a 3x1 vector that shows the orientation relative to the
% input x,y,z


% initialize arrays
possible_directions=nan(3,100); 
direction_data=nan(1,100);
iter=1;

% diagnostics plots 
if plotboolean==1
    figure 
    hold on
    plot3(x , y , z , 'g^')
    axis equal
    xlabel('x (m)')
    ylabel('y (m)')
    zlabel('z (m)')
end

% set scan radius (m) from xyz
r = 0.0015;

% sets the angular mesh, i.e. how many points are scanned in the spherical
% shell that will be checked for pin orientation 
angle_mesh=pi/40;

%% Mesh around a sphere centered at xyz looking for best direction 
for phi=0:angle_mesh:2*pi
    for theta=0:(abs(phi-pi/2)+.5)/10:2*pi
       
        %% check point in all five images
        [ output_luminosity.a , output_contrast.a ] = Look_at_Image2( ...
            x+r*cos(theta)*sin(phi) , ...
            y+r*sin(theta)*sin(phi) , ...
            z+r*cos(phi) ,   geo, imageangle.a, contrast.a,luminosity.a );
        
        [ output_luminosity.b , output_contrast.b ] = Look_at_Image2( ...
            x+r*cos(theta)*sin(phi) , ...
            y+r*sin(theta)*sin(phi) , ...
            z+r*cos(phi) ,   geo, imageangle.b, contrast.b,luminosity.b );
        
        [ output_luminosity.c , output_contrast.c ] = Look_at_Image2( ...
            x+r*cos(theta)*sin(phi) , ...
            y+r*sin(theta)*sin(phi) , ...
            z+r*cos(phi) ,   geo, imageangle.c, contrast.c,luminosity.c );
        
        [ output_luminosity.d , output_contrast.d ] = Look_at_Image2( ...
            x+r*cos(theta)*sin(phi) , ...
            y+r*sin(theta)*sin(phi) , ...
            z+r*cos(phi) ,   geo, imageangle.d, contrast.d,luminosity.d );
        
        [ output_luminosity.e , output_contrast.e ] = Look_at_Image2( ...
            x+r*cos(theta)*sin(phi) , ...
            y+r*sin(theta)*sin(phi) , ...
            z+r*cos(phi) ,   geo, imageangle.e, contrast.e,luminosity.e );
        
        %% New direction works in all 5 angles, add to possible directions
        if sum([output_luminosity.a>threshold.luminosity ...
                output_luminosity.b>threshold.luminosity ...
                output_luminosity.c>threshold.luminosity ...
                output_luminosity.d>threshold.luminosity ...
                output_luminosity.e>threshold.luminosity])...
                >threshold.found_lum && ...
                sum([output_contrast.a>threshold.contrast ...
                output_contrast.b>threshold.contrast ...
                output_contrast.c>threshold.contrast ...
                output_contrast.d>threshold.contrast ...
                output_contrast.e>threshold.contrast ])...
                >threshold.found_con
            %% output data associated with tested point. can be either luminosity or contrast
            possible_directions(:,iter)=[x+r*cos(theta)*sin(phi);y+r*sin(theta)*sin(phi);z+r*cos(phi)];
            direction_data(:,iter)=(output_luminosity.a+output_luminosity.b+output_luminosity.c+output_luminosity.d+output_luminosity.e)/5;
%             direction_data(:,iter)=(output_contrast.a+output_contrast.b+output_contrast.c+output_contrast.d+output_contrast.e)/5;
            iter=iter+1;
            
            

        
        end
        
        
            %% diagnostics plots
            if plotboolean==1
                luminosity_sum=output_luminosity.a+output_luminosity.b+output_luminosity.c+output_luminosity.d+output_luminosity.e;
                contrast_sum=output_contrast.a+output_contrast.b+output_contrast.c+output_contrast.d+output_contrast.e;
                               
                plot3(x+r*cos(theta)*sin(phi) , ...
                y+r*sin(theta)*sin(phi) , ...
                z+r*cos(phi) , '.','Color',[luminosity_sum/5 0 0])
            end
        
    end
end

if isnan(direction_data(1))==0
    %% only output best direction 
    loc=find(direction_data==max(direction_data));
    Direction=possible_directions(:,loc(1));
else
    %% didn't find anything, output nan
    Direction=possible_directions(:,1);
end

end

