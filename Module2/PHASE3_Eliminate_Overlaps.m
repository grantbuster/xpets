function [ PHASE_OUT , PHASE_DIAGNOSTICS_OUT ,  eliminate] = PHASE3_Eliminate_Overlaps(PHASE_IN , PHASE_DIAGNOSTICS_IN , threshold  )

truelength=0.0126;

eliminate=zeros(length(PHASE_IN(1,1,:)),1); %boolean array to delete possible solutions if they overlap

PHASE_DIAGNOSTICS_OUT=nan(3,9,2);

normalized_overlap_threshold=threshold.normalized_overlap;

%% start loop comparing all possible solutions against each other
for i=1:length(PHASE_IN(1,1,:)) 
    
    midpoint1=(PHASE_IN(:,1,i)+PHASE_IN(:,2,i))./2;
    
    for j=1:length(PHASE_IN(1,1,:))
        
        if i~=j % dont compare a pin to itself 
            
            if (eliminate(i)+eliminate(j))==0 % neither has been eliminated yet
            
                midpoint2=(PHASE_IN(:,1,j)+PHASE_IN(:,2,j))./2;

                % distance between centroids
                delta=sqrt( ((midpoint1(1)-midpoint2(1))^2)+((midpoint1(2)-midpoint2(2))^2)+((midpoint1(3)-midpoint2(3))^2) );

                if delta < (truelength*normalized_overlap_threshold)
                    % Pins i and j overlap more than they should
                    
                        [ Pin_i_Contrast ] = PHASE_DIAGNOSTICS_IN(:,8:9,i) ; 
                        [ Pin_j_Contrast ] = PHASE_DIAGNOSTICS_IN(:,8:9,j) ; 

                        %% whichever pin has the better contrast in all 5 images is likely to be correct
                        if Pin_i_Contrast(6)<Pin_j_Contrast(6) 
                            eliminate(j)=1;
                        else
                            eliminate(i)=1;
                        end
                    
                    
                    
                end 
                
                
            end
        end
    end
end

OUTPUT=PHASE_IN;
PHASE_OUT=nan(3,2,2);

temp_diag=PHASE_DIAGNOSTICS_IN;

for i=1:length(PHASE_IN(1,1,:))
   if eliminate(i)==0
       %% the i pin has not been eliminated by overlap threshold, add to output
       
           PHASE_OUT=cat(3,PHASE_OUT,OUTPUT(:,:,i));
           PHASE_DIAGNOSTICS_OUT=cat(3,PHASE_DIAGNOSTICS_OUT,temp_diag(:,:,i));
    
   end
end

PHASE_OUT(:,:,1:2)=[];
PHASE_DIAGNOSTICS_OUT(:,:,1:2)=[];

end