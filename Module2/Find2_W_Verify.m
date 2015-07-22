function [ output_intersections , output_diagnostics , found3, found4] = Find2_W_Verify(pin1 , pin2 , found1, found2, contrast, theta , threshold,geo,plotboolean)
% This function compares module1 endpoints in 3D and determines whether
% they result in a pebble in the actual silo 

%% set ouput and boolean found matrices 
output_intersections=nan(3,2,2);
output_diagnostics=nan(3,9,2);

found3=zeros(length(pin1(1,1,:)),1)+found1;
found4=zeros(length(pin2(1,1,:)),1)+found2;

%% diagnostics tools
true=0;
iteration=1;

%% Enter main loop    
for i=1:length(pin1(1,1,:))
    
midpoint1=((pin1(:,1)+pin1(:,2))./2);

if found1(i)==0 % optional: the found boolean array can eliminate during the function run or as an input
    
    for j=1:length(pin2(1,1,:))
        
    if found2(j)==0
        
        midpoint2=((pin2(:,1)+pin2(:,2))./2);
        
        delta_z=abs(midpoint1(3)-midpoint2(3)); % quick check to see if the midpoints are in the same range
        
        if delta_z<0.05 
            %% pins are close vertically, do centroid intersection
            p1v1=pin1(:,3)-midpoint1; % vector from point source to midpoint
            p2v1=pin2(:,3)-midpoint2; % vector from point source to midpoint
            %% find intersection of p1v1 and p2v1
            t2 = ( (p1v1(1)*midpoint2(2,1)) - (p1v1(1)*midpoint1(2,1)) - (p1v1(2)*midpoint2(1,1)) + (p1v1(2)*midpoint1(1,1)) ) / ( (p2v1(1)*p1v1(2)) - (p1v1(1)*p2v1(2)) );
            t1 = ( (p2v1(1)*t2) + midpoint2(1,1) - midpoint1(1,1) ) / p1v1(1);
            intersection1=[(t1*p1v1(1))+midpoint1(1,1) , (t1*p1v1(2))+midpoint1(2,1) , (t1*p1v1(3)+midpoint1(3,1)) ];
            intersection2=[(t2*p2v1(1))+midpoint2(1,1) , (t2*p2v1(2))+midpoint2(2,1) , (t2*p2v1(3)+midpoint2(3,1)) ];
            %% difference in height between two intersections
            delta_vertical=abs(intersection1(3)-intersection2(3));
        else % midpoints are very far apart
            delta_vertical=100;
        end

        if delta_vertical < .005 % pins are close, continue with algorithm 
            
            %% start intersection methods for images 1/2
            
            % Triangle intersection algorithm
            [ output1 , diagnostics1 ] = TriangleIntersection( pin1(:,:,i) , pin2(:,:,j) , threshold , plotboolean);
                
            % Top down projection intersection algorithm 
            [ output2 , diagnostics2 ] = TopDownIntersection( pin1(:,:,i) , pin2(:,:,j) , threshold , plotboolean);


            if isempty(output1)==0 % Triangle intersection found something
                
                % check the contrast of resulting pin in 5 image/contrast data sets
                [ output1_Contrast ] = Find_Contrast_1pin( output1 , contrast, theta, geo, plotboolean);
                
                % compare contrast for 5 images against threshold 
                out1_contrast1=(output1_Contrast(1,:)>threshold.contrast_a);
                out1_contrast2=(output1_Contrast(2,:)>threshold.contrast_b);
                out1_contrast3=(output1_Contrast(3,:)>threshold.contrast_c);
                out1_contrast4=(output1_Contrast(4,:)>threshold.contrast_d);
                out1_contrast5=(output1_Contrast(5,:)>threshold.contrast_e);
              
                output1_contrast_verified=out1_contrast1+out1_contrast2+out1_contrast3+out1_contrast4+out1_contrast5;               
                
                if  output1_contrast_verified >= threshold.number_valid_images % contrast is verified in number of valid images
                    
                    % set outputs
                    output_intersections=cat(3,output_intersections,output1);
                    output_diagnostics=cat(3,output_diagnostics,[diagnostics1,output1_Contrast(1:3),output1_Contrast(4:6)]);
                    iteration=iteration+1;
                    
                    found3(i)=1;
                    found4(j)=1;

                end
            end   
            
            
            %%
            
            if isempty(output2)==0 % top down algorithm found something
                
                
                [ output2_Contrast ] = Find_Contrast_1pin( output2 , contrast, theta, geo, plotboolean);


                out2_contrast1=(output2_Contrast(1,:)>threshold.contrast_a);
                out2_contrast2=(output2_Contrast(2,:)>threshold.contrast_b);
                out2_contrast3=(output2_Contrast(3,:)>threshold.contrast_c);
                out2_contrast4=(output2_Contrast(4,:)>threshold.contrast_d);
                out2_contrast5=(output2_Contrast(5,:)>threshold.contrast_e);
     
                output2_contrast_verified=out2_contrast1+out2_contrast2+out2_contrast3+out2_contrast4+out2_contrast5;
                
                
                if output2_contrast_verified >= threshold.number_valid_images 

                    output_intersections=cat(3,output_intersections,output2);
                    output_diagnostics=cat(3,output_diagnostics,[diagnostics2,output2_Contrast(1:3),output2_Contrast(4:6)]);
                    iteration=iteration+1;
                    

                    found3(i)=1;
                    found4(j)=1;

                        
                end
            end

            
        end
    end
    end
end
end

%% k=[1 2] are always nan due to initiation  
output_intersections(:,:,[1,2])=[];
output_diagnostics(:,:,[1,2])=[];

end