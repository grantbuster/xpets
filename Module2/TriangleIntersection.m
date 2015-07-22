function [ output_intersection , output_diagnostics ] = TriangleIntersection( pin1 , pin2 , threshold , plotboolean)
%find the intersection of two triangles created by two pairs of endpoints
%and their respective point sources

normalized_length_threshold=threshold.normalized_length;
metric_spatial_threshold=threshold.metric_spatial;

truelength=0.0126;

output_intersection=[];
output_diagnostics=[];


%% apply triangle intersection method

%% intialize points for rays
a1=pin1(:,1);   
b1=pin1(:,2);
c1=pin1(:,3);

%% intialize points for plane
a2=pin2(:,1);       
b2=pin2(:,2);  
c2=pin2(:,3);

%% Initialize Rays
V0=c2;
ray1=c2-a2;
ray2=c2-b2;
ray3=V0-c1;
ray4=a1-c1;
ray5=b1-c1;

%% ray1 cross ray2 to get normal for plane

n(1,1)=(ray1(2)*ray2(3))-(ray2(2)*ray1(3));   
n(2,1)=-(ray1(1)*ray2(3))+(ray2(1)*ray1(3));
n(3,1)=(ray1(1)*ray2(2))-(ray2(1)*ray1(2));

%% yields parametric locationns of intersection

r1=((n(1)*ray3(1))+(n(2)*ray3(2))+(n(3)*ray3(3)))/((n(1)*ray4(1))+(n(2)*ray4(2))+(n(3)*ray4(3)));   
r2=((n(1)*ray3(1))+(n(2)*ray3(2))+(n(3)*ray3(3)))/((n(1)*ray5(1))+(n(2)*ray5(2))+(n(3)*ray5(3)));
%% convert r1, r2 into metric 3D locations

set1point1=(c1+(r1*(a1-c1)));
set1point2=(c1+(r2*(b1-c1)));

%% ----------------------------Switch Rays/Planes to get other 2 intersection points----------------------------%

%% intialize points for the two rays
a1=pin2(:,1);   
b1=pin2(:,2);
c1=pin2(:,3);

 %% intialize verticies for plane

a2=pin1(:,1);  
b2=pin1(:,2);
c2=pin1(:,3);

%% initialize rays for multi-v
V0=c2;
ray1=c2-a2;
ray2=c2-b2;
ray3=V0-c1;
ray4=a1-c1;
ray5=b1-c1;

%% ray1 cross ray2 to get normal for plane

n(1,1)=(ray1(2)*ray2(3))-(ray2(2)*ray1(3));   
n(2,1)=-(ray1(1)*ray2(3))+(ray2(1)*ray1(3));
n(3,1)=(ray1(1)*ray2(2))-(ray2(1)*ray1(2));

%% yields parametric locationns of intersection

r3=((n(1)*ray3(1))+(n(2)*ray3(2))+(n(3)*ray3(3)))/((n(1)*ray4(1))+(n(2)*ray4(2))+(n(3)*ray4(3)));   
r4=((n(1)*ray3(1))+(n(2)*ray3(2))+(n(3)*ray3(3)))/((n(1)*ray5(1))+(n(2)*ray5(2))+(n(3)*ray5(3)));


%% convert r3, r4 into metric 3D locations

set2point1=(c1+(r3*(a1-c1)));
set2point2=(c1+(r4*(b1-c1)));

%% Plot intersection vectors and intersections 
if plotboolean==1

            figure('Color','w','WindowStyle','docked')
            hold on
            
            %plot the Module 1 endpoints on detector plane
            plot3([pin1(1,1),pin1(1,2)],[pin1(2,1),pin1(2,2)],[pin1(3,1),pin1(3,2)],'k')
            plot3([pin2(1,1),pin2(1,2)],[pin2(2,1),pin2(2,2)],[pin2(3,1),pin2(3,2)],'k')
            
            % plot two vectors from source to pin 1 endpoints
            plot3( [pin1(1,1),pin1(1,3)] , [pin1(2,1),pin1(2,3)] , [pin1(3,1),pin1(3,3)] ,'b')
            plot3( [pin1(1,2),pin1(1,3)] , [pin1(2,2),pin1(2,3)] , [pin1(3,2),pin1(3,3)] ,'b')
            
            % plot two vectors from source to pin 2 endpoints
            plot3( [pin2(1,1),pin2(1,3)] , [pin2(2,1),pin2(2,3)] , [pin2(3,1),pin2(3,3)] ,'r')
            plot3( [pin2(1,2),pin2(1,3)] , [pin2(2,2),pin2(2,3)] , [pin2(3,2),pin2(3,3)] ,'r')
            
            % plot two vectors from source to pin 1 endpoints
            plot3(set1point1(1), set1point1(2), set1point1(3), 'go','MarkerSize',5)
            plot3(set1point2(1), set1point2(2), set1point2(3), 'go','MarkerSize',5)
            
            % plot two vectors from source to pin 1 endpoints
            plot3(set2point1(1), set2point1(2), set2point1(3), 'mo','MarkerSize',10)
            plot3(set2point2(1), set2point2(2), set2point2(3), 'mo','MarkerSize',10)
                        
            axis equal
end

%% Find vector lengths

dx1=set1point1(1)-set1point2(1);
dy1=set1point1(2)-set1point2(2);
dz1=set1point1(3)-set1point2(3);

dx2=set2point1(1)-set2point2(1);
dy2=set2point1(2)-set2point2(2);
dz2=set2point1(3)-set2point2(3);

L_vector1 = 1- abs(1-(sqrt( (dx1^2) + (dy1^2) + (dz1^2))/truelength));
L_vector2 = 1- abs(1-(sqrt( (dx2^2) + (dy2^2) + (dz2^2))/truelength));


if L_vector1>normalized_length_threshold || L_vector2>normalized_length_threshold

    %% Now we have point-vectors for both sets of intersections. need to compare and see if they are a pin

        %% endpoints are colinear, compare spatial location

        mx1=(set1point1(1)+set1point2(1))/2;
        my1=(set1point1(2)+set1point2(2))/2;
        mz1=(set1point1(3)+set1point2(3))/2;

        mx2=(set2point1(1)+set2point2(1))/2;
        my2=(set2point1(2)+set2point2(2))/2;
        mz2=(set2point1(3)+set2point2(3))/2;

        %find mindpoints of pins:

        dx=mx1-mx2;
        dy=my1-my2;
        dz=mz1-mz2;

        spatial_similarity = sqrt( (dx^2) + (dy^2) + (dz^2) );

        if spatial_similarity < metric_spatial_threshold
            
            %PIN FOUND
            
            if L_vector1>L_vector2 % choose which solution to output 

                output_intersection=[ set1point1,set1point2 ];


                output_diagnostics(:,1)=[L_vector1 ; 1 ; spatial_similarity];

                output_diagnostics(:,2)=pin1(:,1);
                output_diagnostics(:,3)=pin1(:,2);
                output_diagnostics(:,4)=pin1(:,3);

                output_diagnostics(:,5)=pin2(:,1);
                output_diagnostics(:,6)=pin2(:,2);
                output_diagnostics(:,7)=pin2(:,3);
            
            else
                
                output_intersection=[ set2point1,set2point2 ];


                output_diagnostics(:,1)=[L_vector2 ; 1 ; spatial_similarity];

                output_diagnostics(:,2)=pin1(:,1);
                output_diagnostics(:,3)=pin1(:,2);
                output_diagnostics(:,4)=pin1(:,3);

                output_diagnostics(:,5)=pin2(:,1);
                output_diagnostics(:,6)=pin2(:,2);
                output_diagnostics(:,7)=pin2(:,3);
            end

        else
            output_intersection=[];
            output_diagnostics=[];
            
        end
    
end


end

