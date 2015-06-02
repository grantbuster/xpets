function [ NextPoint ] = Walk_Along_Pin_2( Start,Direction, geo, imageangle, contrast, luminosity , threshold , plotboolean)
% Given a starting point [x;y;z] and a direction [xend;yend;zend]
% walk along the pin finding valid points on the way, return the endpoint

possible_directions=nan(3,100); 
direction_data=nan(1,100);
iter=1;

% How far do you want to walk is delta 
delta=0.0015;

% define relevant vectors
vector=Direction-Start;
normvector=vector./sqrt(sum(vector.^2));

perpV1=[-normvector(2);normvector(1);0]./sqrt(sum([-normvector(2);normvector(1);0].^2));
perpV2=cross(normvector, perpV1);

% if isnan(perpV1(1))==1
%     perpV1=[-normvector(3);0;normvector(1)]./sqrt(sum([-normvector(3);0;normvector(1)].^2));
% end
% if isnan(perpV2(1))==1
%     perpV2=[-normvector(3);0;normvector(1)]./sqrt(sum([-normvector(3);0;normvector(1)].^2));
% end


%% Plot commands 
if plotboolean==1
    figure 
    hold on
    plot3(Start(1) , Start(2) , Start(3) , 'k^')
    plot3(Direction(1) , Direction(2) , Direction(3) , 'g^')
    plot3([Start(1) Direction(1)] , [Start(2) Direction(2)] , [Start(3) Direction(3)] , 'r-')
    axis equal
    legend('Start','Direction','Vector')
end


%% Mesh around a cone in the intended direction
for j=[0,1];
for r=0.000025:0.000025:0.0001 % set scan cone radius 
for i = 0:pi/(50000*r):2*pi

        point=(Start+delta.*normvector) + j.*( r*cos(i)*perpV1 + r*sin(i)*perpV2);
        
        if plotboolean==1
            plot3(point(1),point(2),point(3),'c^')
        end

        [ output_luminosity.a , output_contrast.a ] = Look_at_Image2( point(1),point(2),point(3),...
            geo, imageangle.a, contrast.a,luminosity.a );
        
        [ output_luminosity.b , output_contrast.b ] = Look_at_Image2( point(1),point(2),point(3),...
            geo, imageangle.b, contrast.b,luminosity.b );
        
        [ output_luminosity.c , output_contrast.c ] = Look_at_Image2( point(1),point(2),point(3),...
            geo, imageangle.c, contrast.c,luminosity.c );
        
        [ output_luminosity.d , output_contrast.d ] = Look_at_Image2(  point(1),point(2),point(3),...
            geo, imageangle.d, contrast.d,luminosity.d );
        
        [ output_luminosity.e , output_contrast.e ] = Look_at_Image2(  point(1),point(2),point(3),...
            geo, imageangle.e, contrast.e,luminosity.e );
        
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
            
            possible_directions(:,iter)=[point];
            direction_data(:,iter)=(output_luminosity.a+output_luminosity.b+output_luminosity.c+output_luminosity.d+output_luminosity.e)/5;
%             direction_data(:,iter)=(output_contrast.a+output_contrast.b+output_contrast.c+output_contrast.d+output_contrast.e)/5;
            iter=iter+1;
            
        end
end
end
end

if isnan(direction_data(1))==0
    %% only output best direction 
    loc=find(direction_data==max(direction_data));
    NextPoint=possible_directions(:,loc(1));
else
    %%didn't find anything, output nan
    NextPoint=possible_directions(:,1);
end

end

