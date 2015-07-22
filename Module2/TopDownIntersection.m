function [ output_intersection , output_diagnostics ] = TopDownIntersection( pin1 , pin2 , threshold , plotboolean )

normalized_length_threshold=threshold.normalized_length;
similar_z_threshold=threshold.similar_z;

truelength=0.0126;

output_intersection=[];
output_diagnostics=[];

finalpoint1=[];


%% find intersections by projecting intersections onto XY plane

%pin 1 vector 1 is a vector going through one of pin 1's endpoints
p1v1=pin1(:,3)-pin1(:,1);
p1v2=pin1(:,3)-pin1(:,2);

p2v1=pin2(:,3)-pin2(:,1);
p2v2=pin2(:,3)-pin2(:,2);

%% find intersection of p1v1 and p2v1

t2 = ( (p1v1(1)*pin2(2,1)) - (p1v1(1)*pin1(2,1)) - (p1v1(2)*pin2(1,1)) + (p1v1(2)*pin1(1,1)) ) / ( (p2v1(1)*p1v1(2)) - (p1v1(1)*p2v1(2)) );
t1 = ( (p2v1(1)*t2) + pin2(1,1) - pin1(1,1) ) / p1v1(1);

intersection1=[(t1*p1v1(1))+pin1(1,1) , (t1*p1v1(2))+pin1(2,1) , (t1*p1v1(3)+pin1(3,1)) ];
intersection2=[(t2*p2v1(1))+pin2(1,1) , (t2*p2v1(2))+pin2(2,1) , (t2*p2v1(3)+pin2(3,1)) ];

%% find intersection of p1v1 and p2v2

t2 = ( (p1v1(1)*pin2(2,2)) - (p1v1(1)*pin1(2,1)) - (p1v1(2)*pin2(1,2)) + (p1v1(2)*pin1(1,1)) ) / ( (p2v2(1)*p1v1(2)) - (p1v1(1)*p2v2(2)) );
t1 = ( (p2v2(1)*t2) + pin2(1,2) - pin1(1,1) ) / p1v1(1);

intersection3=[(t1*p1v1(1))+pin1(1,1) , (t1*p1v1(2))+pin1(2,1) , (t1*p1v1(3)+pin1(3,1)) ];
intersection4=[(t2*p2v2(1))+pin2(1,2) , (t2*p2v2(2))+pin2(2,2) , (t2*p2v2(3)+pin2(3,2)) ];

%% find intersection of p1v2 and p2v1
t2 = ( (p1v2(1)*pin2(2,1)) - (p1v2(1)*pin1(2,2)) - (p1v2(2)*pin2(1,1)) + (p1v2(2)*pin1(1,2)) ) / ( (p2v1(1)*p1v2(2)) - (p1v2(1)*p2v1(2)) );
t1 = ( (p2v1(1)*t2) + pin2(1,1) - pin1(1,2) ) / p1v2(1);

intersection5=[(t1*p1v2(1))+pin1(1,2) , (t1*p1v2(2))+pin1(2,2) , (t1*p1v2(3)+pin1(3,2)) ];
intersection6=[(t2*p2v1(1))+pin2(1,1) , (t2*p2v1(2))+pin2(2,1) , (t2*p2v1(3)+pin2(3,1)) ];


%% find intersection of p1v2 and p2v2          

t2 = ( (p1v2(1)*pin2(2,2)) - (p1v2(1)*pin1(2,2)) - (p1v2(2)*pin2(1,2)) + (p1v2(2)*pin1(1,2)) ) / ( (p2v2(1)*p1v2(2)) - (p1v2(1)*p2v2(2)) );
t1 = ( (p2v2(1)*t2) + pin2(1,2) - pin1(1,2) ) / p1v2(1);

intersection7=[(t1*p1v2(1))+pin1(1,2) , (t1*p1v2(2))+pin1(2,2) , (t1*p1v2(3)+pin1(3,2)) ];
intersection8=[(t2*p2v2(1))+pin2(1,2) , (t2*p2v2(2))+pin2(2,2) , (t2*p2v2(3)+pin2(3,2)) ];





%% Now we take pairs of intersections and find the pin

%% four possible "closeness" parameters signify a possible solution
similar_z1=abs(intersection1(3)-intersection2(3));
similar_z2=abs(intersection3(3)-intersection4(3));
similar_z3=abs(intersection5(3)-intersection6(3));
similar_z4=abs(intersection7(3)-intersection8(3));          



    if similar_z1<similar_z_threshold || similar_z2<similar_z_threshold || similar_z3<similar_z_threshold || similar_z4<similar_z_threshold 
    % intersections 1,2 + 7,8 
    % [1,2] and [7,8] will have same xy coordinates
    L1 = sqrt( ((intersection1(1)-intersection7(1))^2) + ((intersection1(2)-intersection7(2))^2) + ((intersection1(3)-intersection7(3))^2) );
    norm_length1=1- abs(1-(L1/truelength));
    
    
    % intersections 3,4 + 5,6
    % [3,4] and [5,6] will have same xy coordinates
    L2 = sqrt( ((intersection3(1)-intersection5(1))^2) + ((intersection3(2)-intersection5(2))^2) + ((intersection3(3)-intersection5(3))^2) ) ;
    norm_length2=1- abs(1-(L2/truelength));


        if norm_length1>normalized_length_threshold
            %% intersections 1, 2, 7, 8 are solutions

            d1=intersection1-intersection7;

            d2=intersection2-intersection8;

            L_vector1 = 1- abs(1-(sqrt( (d1(1)^2) + (d1(2)^2) + (d1(3)^2))/truelength));
            L_vector2 = 1- abs(1-(sqrt( (d2(1)^2) + (d2(2)^2) + (d2(3)^2))/truelength));

            L_vector=(L_vector1 + L_vector2)/2;

            dot = (d1(1)*d2(1)) + (d1(2)*d2(2)) + (d1(3)*d2(3)) ;
            normalized_colinearity = 1- abs(1 - abs(dot/(truelength^2))) ;

            m1=(intersection1+intersection7)/2;
            m2=(intersection2+intersection8)/2;
            delta=m1-m2;

            spatial_similarity=sqrt((delta(1)^2)+(delta(2)^2)+(delta(3)^2));

            finalpoint1=(intersection1+intersection2)/2;
            finalpoint2=(intersection7+intersection8)/2;

            output_intersection=cat(3,[transpose(finalpoint1),transpose(finalpoint2)]);

            output_diagnostics(:,1)=[L_vector ; normalized_colinearity ; spatial_similarity];

            output_diagnostics(:,2)=pin1(:,1);
            output_diagnostics(:,3)=pin1(:,2);
            output_diagnostics(:,4)=pin1(:,3);

            output_diagnostics(:,5)=pin2(:,1);
            output_diagnostics(:,6)=pin2(:,2);
            output_diagnostics(:,7)=pin2(:,3);
            


        elseif norm_length2>normalized_length_threshold
            %% intersections 3, 4, 5, 6 are solutions

            d1=intersection3-intersection5;

            d2=intersection4-intersection6;

            L_vector1 = 1- abs(1-(sqrt( (d1(1)^2) + (d1(2)^2) + (d1(3)^2))/truelength));
            L_vector2 = 1- abs(1-(sqrt( (d2(1)^2) + (d2(2)^2) + (d2(3)^2))/truelength));

            L_vector=(L_vector1 + L_vector2)/2;

            dot = (d1(1)*d2(1)) + (d1(2)*d2(2)) + (d1(3)*d2(3)) ;
            normalized_colinearity = 1- abs(1 - abs(dot/(truelength^2))) ;

            m1=(intersection3+intersection5)/2;
            m2=(intersection4+intersection6)/2;
            delta=m1-m2;

            spatial_similarity=sqrt((delta(1)^2)+(delta(2)^2)+(delta(3)^2));

            finalpoint1=(intersection3+intersection4)/2;
            finalpoint2=(intersection5+intersection6)/2;

            output_intersection=cat(3,[transpose(finalpoint1),transpose(finalpoint2)]);

            output_diagnostics(:,1)=[L_vector ; normalized_colinearity ; spatial_similarity];

            output_diagnostics(:,2)=pin1(:,1);
            output_diagnostics(:,3)=pin1(:,2);
            output_diagnostics(:,4)=pin1(:,3);

            output_diagnostics(:,5)=pin2(:,1);
            output_diagnostics(:,6)=pin2(:,2);
            output_diagnostics(:,7)=pin2(:,3);
            

        else
            
            output_intersection=[];
            output_diagnostics=[];

        end
    end
    
%% Plot intersection vectors and intersections 
if plotboolean==1

            figure('Color','w','WindowStyle','docked')
            hold on
            
            %plot the Module 1 endpoints on detector plane
            plot3([pin1(1,1),pin1(1,2)],[pin1(2,1),pin1(2,2)],[pin1(3,1),pin1(3,2)],'g')
            plot3([pin2(1,1),pin2(1,2)],[pin2(2,1),pin2(2,2)],[pin2(3,1),pin2(3,2)],'r')
            
            % plot two vectors from source to pin 1 endpoints
            plot3( [pin1(1,1),pin1(1,1)+p1v1(1)] , [pin1(2,1),pin1(2,1)+p1v1(2)] , [pin1(3,1),pin1(3,1)+p1v1(3)] ,'b')
            plot3( [pin1(1,2),pin1(1,2)+p1v2(1)] , [pin1(2,2),pin1(2,2)+p1v2(2)] , [pin1(3,2),pin1(3,2)+p1v2(3)] ,'b')
            
            % plot two vectors from source to pin 2 endpoints
            plot3( [pin2(1,1),pin2(1,1)+p2v1(1)] , [pin2(2,1),pin2(2,1)+p2v1(2)] , [pin2(3,1),pin2(3,1)+p2v1(3)] ,'r')
            plot3( [pin2(1,2),pin2(1,2)+p2v2(1)] , [pin2(2,2),pin2(2,2)+p2v2(2)] , [pin2(3,2),pin2(3,2)+p2v2(3)] ,'r')
            
            % plot two vectors from source to pin 1 endpoints
            plot3(intersection1(1), intersection1(2), intersection1(3), 'ro')
            plot3(intersection2(1), intersection2(2), intersection2(3), 'rx')
            
            % plot two vectors from source to pin 1 endpoints
            plot3(intersection3(1), intersection3(2), intersection3(3), 'go')
            plot3(intersection4(1), intersection4(2), intersection4(3), 'mx')
            
            % plot two vectors from source to pin 1 endpoints
            plot3(intersection5(1), intersection5(2), intersection5(3), 'g+')
            plot3(intersection6(1), intersection6(2), intersection6(3), 'k^')
            
            % plot two vectors from source to pin 1 endpoints
            plot3(intersection7(1), intersection7(2), intersection7(3), 'g+')
            plot3(intersection8(1), intersection8(2), intersection8(3), 'k^')
            
            if isempty(finalpoint1)==0
                %plot resulting pin
                plot3( [finalpoint1(1),finalpoint2(1)] , [finalpoint1(2),finalpoint2(2)] , [finalpoint1(3),finalpoint2(3)] ,'r')
            end
            axis equal
end                 

end