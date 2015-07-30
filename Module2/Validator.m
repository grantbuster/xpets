function [ out ] = Validator( threeDpins , twoDendpoints, theta , image_str , geo, setaxis, redXs, plotlabels, saveimage, filename)
%this function projects the three dimensional pins (threeDpins) from module 2 onto an
%image along with Mike's results from module 1 (twoDendpoints). Theta is
%the angle of the image (degrees) image_str is the image name w/ .jpg. plot
%labels plots the number of each plotted item (should turn off w/ 0). Rest
%is geometry. 

out=[];

O_x=geo.O_x; 
O_y=geo.O_y;
O_z=geo.O_z;
Y_of=geo.Y_of;
truelength=geo.truelength;
ppm=geo.ppm;
        
    figure('Color','w','WindowStyle','docked')
    w=warning('off','all');
    imshow(image_str)
    warning(w)
    title([num2str(theta),' Degree Image. ',num2str(length(threeDpins(1,1,:))),' Pebbles Found.'])
    
    
%% plot mike's results
for i=1:length(twoDendpoints(1,1,:))

hold on

% plot Mike's endpoints as circles
plot(twoDendpoints(2,1,i),twoDendpoints(1,1,i),'om','MarkerSize',2)
plot(twoDendpoints(2,2,i),twoDendpoints(1,2,i),'og','MarkerSize',2)
plot([twoDendpoints(2,1,i),twoDendpoints(2,2,i)],[twoDendpoints(1,1,i),twoDendpoints(1,2,i)],'r')
if plotlabels==1
                text(twoDendpoints(2,1,i),twoDendpoints(1,1,i),num2str(i))
end

% plot Mike's endpoints as lines
        plot([twoDendpoints(2,1,i),twoDendpoints(2,2,i)],[twoDendpoints(1,1,i),twoDendpoints(1,2,i)],'k','MarkerSize',2)        
end
    
    
%% Start Projection
    % define plane
    % point on plane in x;y;z notation 
    plane_point=[O_y*sin(theta*(pi/180)) ; O_y*cos(theta*(pi/180)) ; 0]; 
    
    % plane normal vector is x;y;z
    plane_norm=[plane_point(1) ; plane_point(2) ; plane_point(3)];
    
    %define source location in [x;y;z]
    source_point=[ -Y_of * sin(theta*(pi/180)) ; -Y_of * cos(theta*(pi/180)) ; 0 ];
    
    % left point of detector [x;y]
    left=plane_point - [O_x*cos(theta*(pi/180)) ; -O_x*sin(theta*(pi/180)) ; 0];
    
%% Project 3D results
    for j=1:length(threeDpins(1,1,:))
        
        % define two lines
        vector1=source_point-threeDpins(:,1,j);
        vector2=source_point-threeDpins(:,2,j);
        
        vector3=plane_point-source_point;
        
        % find intersections       
        parametric_param1=-dot(plane_norm , vector3)/dot(plane_norm , vector1);
        intersection1=(source_point-(parametric_param1*vector1));
        
        parametric_param2=-dot(plane_norm , vector3)/dot(plane_norm , vector2);
        intersection2=(source_point-(parametric_param2*vector2));
        
        %distance from left of detector to the point
        intersection1(1)=sqrt(((intersection1(1)-left(1))^2)+((intersection1(2)-left(2))^2))*ppm;
        intersection2(1)=sqrt(((intersection2(1)-left(1))^2)+((intersection2(2)-left(2))^2))*ppm;
        
        intersection1(3)=ppm*(-intersection1(3)+O_z);
        intersection2(3)=ppm*(-intersection2(3)+O_z);
        
        
        hold on
        %plot 3D pins as lines from Grant's results
        if 1
            plot([intersection1(1),intersection2(1)] , [intersection1(3),intersection2(3)],'b','LineWidth',1)
        end
        
        if redXs==1
            if 0
                plot(intersection1(1),intersection1(3),'r+')
                plot(intersection2(1),intersection2(3),'r+')
            end 
            if 1
                plot(mean([intersection1(1),intersection2(1)]),mean([intersection1(3),intersection2(3)]),'r+')
            end
        end

            if plotlabels==1
                text(intersection1(1),intersection1(3),num2str(j))
            end
    
    end
    
    
    axis equal
    axis(setaxis)
    
    if saveimage==1
        saveas(gcf,[filename,'.jpg'])
    end
    


end