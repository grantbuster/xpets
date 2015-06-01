function [ Contrast_output ] = Find_Contrast_1pin( intersect , contrast, theta, geo, plotboolean)

%% Input one possible solution and return the average contrast of that pin in each angle with uncertainty

O_x=geo.O_x; 
O_y=geo.O_y;
O_z=geo.O_z;
Y_of=geo.Y_of;
ppm=geo.ppm;

point_x=nan(11,1);
point_y=nan(11,1);
meshsum=nan(11,1);

n=6; % set number of points to check contrast along solution line. DIRECTLY PROPORTIONAL TO COMPUTATIONT TIME, BUT ALSO ACCURACY 

Contrast_output=zeros(6,1);%(11*(1+n)));

for i=1:5 %iterate through 5 images

    %% set angle and contrast data
    if i==1 
        theta_i=theta.a;
        contrast_i=contrast.a;
    elseif i==2
        theta_i=theta.b;
        contrast_i=contrast.b;
    elseif i==3
        theta_i=theta.c;
        contrast_i=contrast.c;
    elseif i==4
        theta_i=theta.d;
        contrast_i=contrast.d;
    else
        theta_i=theta.e;
        contrast_i=contrast.e;
    end
    
    % for plotting onto contrast image
    if plotboolean==1
           figure('Color','w','WindowStyle','docked')
           hold on
           imshow(contrast_i) 
    end
        
    
    
        % define detector plane
        % point on plane in x;y;z notation 
        plane_point=[O_y*sin(theta_i*(pi/180)) ; O_y*cos(theta_i*(pi/180)) ; 0]; 

        % plane normal vector is x;y;z
        plane_norm=[plane_point(1) ; plane_point(2) ; plane_point(3)];

        %define source location in [x;y;z]
        source_point=[ -Y_of * sin(theta_i*(pi/180)) ; -Y_of * cos(theta_i*(pi/180)) ; 0 ];

        % left point of detector [x;y]
        left=plane_point - [O_x*cos(theta_i*(pi/180)) ; -O_x*sin(theta_i*(pi/180)) ; 0];
        
        % define two lines
        vector1=source_point-intersect(:,1);
        vector2=source_point-intersect(:,2);
        
        vector3=plane_point-source_point;
        
        % find intersections       
        dot1=sum(plane_norm.*vector3);
        dot2=sum(plane_norm.*vector1);
        dot3=sum(plane_norm.*vector2);
        
        parametric_param1=-dot1/dot2;
        intersection1=(source_point-(parametric_param1*vector1));
        
        parametric_param2=-dot1/dot3;
        intersection2=(source_point-(parametric_param2*vector2));
        
        %distance from left of detector to the point
        intersection1(1)=sqrt(((intersection1(1)-left(1))^2)+((intersection1(2)-left(2))^2))*ppm;
        intersection2(1)=sqrt(((intersection2(1)-left(1))^2)+((intersection2(2)-left(2))^2))*ppm;
        
        intersection1(3)=ppm*(-intersection1(3)+O_z);
        intersection2(3)=ppm*(-intersection2(3)+O_z);
        
        
        if (intersection1(1)<2990) && (intersection2(1)<2990) && (intersection1(3)<2990) && (intersection2(3)<2990) && (intersection1(1)>10) && (intersection2(1)>10) && (intersection1(3)>10) && (intersection2(3)>10)
            % projection is within image boundaries
        
            meshsum=zeros(11,1);

            %% setup vectors to find contrast along solution and also offset 
            vector=[(intersection1(1)-intersection2(1));(intersection1(3)-intersection2(3))];
            norm_vector=vector./(sqrt((vector(1)^2)+(vector(2)^2)));
            norm_perp=[-norm_vector(2);norm_vector(1)];
        
                    
            %% this part meshes through n points along the pin line and points offset from solution
            for mesh=(-n/2):(n/2)
                for offset=-5:5
                    
                    index=offset+6;
                                        
                    point_x(index)=(intersection1(1)-intersection2(1))*(1/n)*(mesh)+(((intersection1(1)+intersection2(1))/2)+offset*norm_perp(1));
                    point_y(index)=(intersection1(3)-intersection2(3))*(1/n)*(mesh)+(((intersection1(3)+intersection2(3))/2)+offset*norm_perp(2));                    

                        meshsum(index)=meshsum(index)+contrast_i(round(point_y(index)),round(point_x(index)),1);
                        
                                            
                        if plotboolean==1
                            plot([intersection1(1),intersection2(1)],[intersection1(3),intersection2(3)],'b')
                            plot(intersection2(1),intersection2(3),'go')
                            plot(intersection1(1),intersection1(3),'go')
                            plot(round(point_x(index)),round(point_y(index)),'r+')
                        end
                        
                end
            end
            meshsum=meshsum./(n+1); % average the contrasts 
            
            Contrast_output(i)=max(meshsum); % take the maximum contrast between offsets
            
            %% assign an uncertainty if the maximum contrast is offset from solution
            
            if Contrast_output(i)==meshsum(6)
                Contrast_output(6)=Contrast_output(6)+0;
            elseif Contrast_output(i)==meshsum(7) || Contrast_output(i)==meshsum(5)
                Contrast_output(6)=Contrast_output(6)+1;
            elseif Contrast_output(i)==meshsum(8) || Contrast_output(i)==meshsum(4)
                Contrast_output(6)=Contrast_output(6)+2;
            elseif Contrast_output(i)==meshsum(9) || Contrast_output(i)==meshsum(3)
                Contrast_output(6)=Contrast_output(6)+3;
            elseif Contrast_output(i)==meshsum(10) || Contrast_output(i)==meshsum(2)
                Contrast_output(6)=Contrast_output(6)+4;
            elseif Contrast_output(i)==meshsum(11) || Contrast_output(i)==meshsum(1)
                Contrast_output(6)=Contrast_output(6)+5;
            end
            
                        
            
            
        end
end
end

