function [ output_luminosity , output_contrast ] = Look_at_Image2( x,y,z,geo,theta,contrast,luminosity )
% This function takes a single point (x,y,z) (meters) and finds the
% contrast and luminosity for that point in the image specified by theta

% define plane
% point on plane in x;y;z notation 
plane_point=[geo.O_y*sin(theta*(pi/180)) ; geo.O_y*cos(theta*(pi/180)) ; 0]; 

%define source location in [x;y;z]
source_point=[ -geo.Y_of * sin(theta*(pi/180)) ; -geo.Y_of * cos(theta*(pi/180)) ; 0 ];

% left point of detector [x;y]
left=plane_point - [geo.O_x*cos(theta*(pi/180)) ; -geo.O_x*sin(theta*(pi/180)) ; 0];

% define two lines
vector1=source_point-[x;y;z];
vector3=plane_point-source_point;

% find intersections       
dot1=sum(plane_point.*vector3);
dot2=sum(plane_point.*vector1);
parametric_param1=-dot1/dot2;
intersection1=(source_point-(parametric_param1*vector1));

%distance from left of detector to the point
intersection1(1)=sqrt(((intersection1(1)-left(1))^2)+((intersection1(2)-left(2))^2))*6993;
intersection1(3)=6993*(-intersection1(3)+geo.O_z);

if intersection1(1)>2 && intersection1(1)<2998 && intersection1(3)>2 && intersection1(3)<2998
    output_contrast  = Interpolate2D( intersection1(1) , intersection1(3) , contrast );
    output_luminosity  = Interpolate2D( intersection1(1) , intersection1(3) , luminosity );




%     iter=1;
%     contrasts=nan(9,1);
%     luminosities=nan(9,1);
%     
%     for i=-1:1
%         for j=-1:1
%             contrasts(iter)=contrast(j+round(intersection1(3)),i+round(intersection1(1)));
%             luminosities(iter)=luminosity(j+round(intersection1(3)),i+round(intersection1(1)));
%             iter=iter+1;
%         end
%     end
%     output_luminosity=max(luminosities);
%     output_contrast=max(contrasts);
    
    
else 
    output_contrast  = -100;
    output_luminosity  = -100;
end

end