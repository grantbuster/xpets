function [ PHASE_OUT , PHASE_DIAGNOSTICS_OUT , eliminate] = PHASE2_Eliminate_Outsiders( PHASE_IN, PHASE_DIAGNOSTICS_IN , theta, module1 , silo_boundary, geo, plotboolean)

%this function eliminates all pins outside of the silo given the 5 images

eliminate=zeros(length(PHASE_IN(1,1,:)),1);

O_x=geo.O_x; 
O_y=geo.O_y;
O_z=geo.O_z;
Y_of=geo.Y_of;
truelength=geo.truelength;
ppm=geo.ppm;


for i=1:7
    if i==1
        theta_i=theta.a;
        if sum(sum(module1.a(:,:,1)==0))~=4
            i_max=max(max(module1.a(2,1,:)),max(module1.a(2,2,:)))+10;
            i_min=min(min(module1.a(2,1,:)),min(module1.a(2,2,:)))-10;
        else
            i_max=3000;
            i_min=0;
        end
                        if plotboolean==1
                        %% plot mike's results
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        for j=1:length(module1.a(1,1,:))

                        hold on

                        %plot Mike's endpoints as circles
                        plot(module1.a(2,1,j),module1.a(1,1,j),'om','MarkerSize',2)
                        plot(module1.a(2,2,j),module1.a(1,2,j),'om','MarkerSize',2)

                        %plot Mike's endpoints as lines
                        %plot([module1_1(2,1,i),module1_1(2,2,i)],[module1_1(1,1,i),module1_1(1,2,i)],'k','MarkerSize',1)        
                        end
                        end
    elseif i==2
        theta_i=theta.b;
        if sum(sum(module1.b(:,:,1)==0))~=4
            i_max=max(max(module1.b(2,1,:)),max(module1.b(2,2,:)))+10;
            i_min=min(min(module1.b(2,1,:)),min(module1.b(2,2,:)))-10;
        else
            i_max=3000;
            i_min=0;
        end
                        if plotboolean==1
                        %% plot mike's results
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        for j=1:length(module1.b(1,1,:))

                        hold on

                        %plot Mike's endpoints as circles
                        plot(module1.b(2,1,j),module1.b(1,1,j),'om','MarkerSize',2)
                        plot(module1.b(2,2,j),module1.b(1,2,j),'om','MarkerSize',2)

                        %plot Mike's endpoints as lines
                        %plot([module1_2(2,1,i),module1_2(2,2,i)],[module1_2(1,1,i),module1_2(1,2,i)],'k','MarkerSize',1)        
                        end
                        end
    elseif i==3
        theta_i=theta.c;
        if sum(sum(module1.c(:,:,1)==0))~=4
            i_max=max(max(module1.c(2,1,:)),max(module1.c(2,2,:)))+10;
            i_min=min(min(module1.c(2,1,:)),min(module1.c(2,2,:)))-10;
        else
            i_max=3000;
            i_min=0;
        end
                        if plotboolean==1
                        %% plot mike's results
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        for j=1:length(module1.c(1,1,:))

                        hold on

                        %plot Mike's endpoints as circles
                        plot(module1.c(2,1,j),module1.c(1,1,j),'om','MarkerSize',2)
                        plot(module1.c(2,2,j),module1.c(1,2,j),'om','MarkerSize',2)

                        %plot Mike's endpoints as lines
                        %plot([module1_3(2,1,i),module1_3(2,2,i)],[module1_3(1,1,i),module1_3(1,2,i)],'k','MarkerSize',1)        
                        end
                        end
    elseif i==4
        theta_i=theta.d;
        if sum(sum(module1.d(:,:,1)==0))~=4
            i_max=max(max(module1.d(2,1,:)),max(module1.d(2,2,:)))+10;
            i_min=min(min(module1.d(2,1,:)),min(module1.d(2,2,:)))-10;
        else
            i_max=3000;
            i_min=0;
        end
                        if plotboolean==1
                        %% plot mike's results
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        for j=1:length(module1.d(1,1,:))

                        hold on

                        %plot Mike's endpoints as circles
                        plot(module1.d(2,1,j),module1.d(1,1,j),'om','MarkerSize',2)
                        plot(module1.d(2,2,j),module1.d(1,2,j),'om','MarkerSize',2)

                        %plot Mike's endpoints as lines
                        %plot([module1_4(2,1,i),module1_4(2,2,i)],[module1_4(1,1,i),module1_4(1,2,i)],'k','MarkerSize',1)        
                        end
                        end
    elseif i==5
        theta_i=theta.e;
        if sum(sum(module1.e(:,:,1)==0))~=4
            i_max=max(max(module1.e(2,1,:)),max(module1.e(2,2,:)))+10;
            i_min=min(min(module1.e(2,1,:)),min(module1.e(2,2,:)))-10;
        else
            i_max=3000;
            i_min=0;
        end
                        if plotboolean==1
                        %% plot mike's results
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        for j=1:length(module1.e(1,1,:))

                        hold on

                        %plot Mike's endpoints as circles
                        plot(module1.e(2,1,j),module1.e(1,1,j),'om','MarkerSize',2)
                        plot(module1.e(2,2,j),module1.e(1,2,j),'om','MarkerSize',2)

                        %plot Mike's endpoints as lines
                        %plot([module1_5(2,1,i),module1_5(2,2,i)],[module1_5(1,1,i),module1_5(1,2,i)],'k','MarkerSize',1)        
                        end
                        end
    elseif i==6
        
        % SET THESE THRESHOLDS YOURSELF
        theta_i=silo_boundary.theta1; %135 IS USUALLY LOOKING AT THE SKINNY SIDE
        i_max=silo_boundary.max1;
        i_min=silo_boundary.min1;
                        if plotboolean==1
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        hold on
                        end
    elseif i==7
        
        % SET THESE THRESHOLDS YOURSELF
        theta_i=silo_boundary.theta2; %135 IS USUALLY LOOKING AT THE SKINNY SIDE
        i_max=silo_boundary.max2;
        i_min=silo_boundary.min2;
                        if plotboolean==1
                        figure('Color','w','WindowStyle','docked')
                        axis equal
                        hold on
                        end
    end
    
            %% Start Projection
                % define plane
                % point on plane in x;y;z notation 
                plane_point=[O_y*sin(theta_i*(pi/180)) ; O_y*cos(theta_i*(pi/180)) ; 0]; 

                % plane normal vector is x;y;z
                plane_norm=[plane_point(1) ; plane_point(2) ; plane_point(3)];

                %define source location in [x;y;z]
                source_point=[ -Y_of * sin(theta_i*(pi/180)) ; -Y_of * cos(theta_i*(pi/180)) ; 0 ];

                % left point of detector [x;y]
                left=plane_point - [O_x*cos(theta_i*(pi/180)) ; -O_x*sin(theta_i*(pi/180)) ; 0];

            %% Project 3D results
                for j=1:length(PHASE_IN(1,1,:))

                    % define two lines
                    vector1=source_point-PHASE_IN(:,1,j);
                    vector2=source_point-PHASE_IN(:,2,j);

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


                    if intersection1(1)>i_max || intersection2(1)>i_max || intersection1(1)<i_min || intersection2(1)<i_min
                        eliminate(j)=1;
                        if plotboolean==1
                            plot([intersection1(1),intersection2(1)] , [intersection1(3),intersection2(3)],'r','LineWidth',1)
                        end
                    else
                        if plotboolean==1
                            plot([intersection1(1),intersection2(1)] , [intersection1(3),intersection2(3)],'b','LineWidth',1)
                        end
                    end
                end
end

PHASE_OUT=nan(3,2,2);
PHASE_DIAGNOSTICS_OUT=nan(3,9,2);

for i=1:length(PHASE_IN(1,1,:))
        
   if eliminate(i)==0
       %% the i pin has not been eliminated by overlap threshold
       
       
           PHASE_OUT=cat(3,PHASE_OUT,PHASE_IN(:,:,i));
           PHASE_DIAGNOSTICS_OUT=cat(3,PHASE_DIAGNOSTICS_OUT,PHASE_DIAGNOSTICS_IN(:,:,i));
    
   end
end

PHASE_OUT(:,:,1:2)=[];
PHASE_DIAGNOSTICS_OUT(:,:,1:2)=[];


end

