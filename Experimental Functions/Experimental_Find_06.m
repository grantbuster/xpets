%%% ------------------------------------------------------------------- %%%
% This script attempts to find a 3D pin given a 2D point that is on a pin
% in one of the x-ray images
% 
% The general principle is that the code will attempt to find the
% orientation of the pin based on scanning a sphere of points around a 3D
% location 
% 
% This code should be improved by adding Mike's module 1 in the following
% manner: Take single endpoints (hopefully with direction) and find where
% the endpoints intersect in 3D. If they intersect very closely, take that
% as the starting point. If the endpoints come with direction, you already
% know a valid orientation. Walk along pin until you see low luminosity in
% any image. Pin found!
% 
%
% EDIT: Version 6
% This variant uses single endpoints to find 3D starting points using the
% vector intersect function. This variant still needs endpoint PLUS
% orientation data from Mike's module 1. With endpoints+orientation, the
% 3D pin orientation and the startin direction can be easily discerned. 
% 
% Written by Grant Buster, summer 2015
% 
%%% ------------------------------------------------------------------- %%%

%% INPUT DATA SET
clc
if 1
    clear
        %% set names for current data set
    
        filename='20150128_03_';
%         filename='20150128_04_';
        % filename='20150213_02_';
        % filename='20150327_01_';

        timestep=1;
        digits_in_timestep=2;

        timestep_string=['000',num2str(timestep)];
        timestep_string=timestep_string(length(timestep_string)-digits_in_timestep+1:length(timestep_string));

        imagestring.a=[filename,'X_',timestep_string,'_0000.jpg'];
        imagestring.b=[filename,'X_',timestep_string,'_0225.jpg'];
        imagestring.c=[filename,'X_',timestep_string,'_0450.jpg'];
        imagestring.d=[filename,'X_',timestep_string,'_0675.jpg'];
        imagestring.e=[filename,'X_',timestep_string,'_0900.jpg'];

        str1=[filename,timestep_string,'_0000.mat'];
        str2=[filename,timestep_string,'_0225.mat'];
        str3=[filename,timestep_string,'_0450.mat'];
        str4=[filename,timestep_string,'_0675.mat'];
        str5=[filename,timestep_string,'_0900.mat'];

        %% Load relevant data
        
        theta.a=0;
        theta.b=22.5;
        theta.c=45;
        theta.d=67.5;
        theta.e=90;
        load(str1)
        module1.a=X;
        single_ends.a=cat(3,X(:,1,:),X(:,2,:)); %get single endpoints from paired data
        contrast.a=LocalContrast;
        imagedata=imread(imagestring.a);
        imagedata=im2double(imagedata);
        luminosity.a=imagedata(:,:,1);
        load(str2)
        module1.b=X;
        single_ends.b=cat(3,X(:,1,:),X(:,2,:));
        contrast.b=LocalContrast;
        imagedata=imread(imagestring.b);
        imagedata=im2double(imagedata);
        luminosity.b=imagedata(:,:,1);
        load(str3)
        module1.c=X;
        single_ends.c=cat(3,X(:,1,:),X(:,2,:));
        contrast.c=LocalContrast;
        imagedata=imread(imagestring.c);
        imagedata=im2double(imagedata);
        luminosity.c=imagedata(:,:,1);
        load(str4)
        module1.d=X;
        single_ends.d=cat(3,X(:,1,:),X(:,2,:));
        contrast.d=LocalContrast;
        imagedata=imread(imagestring.d);
        imagedata=im2double(imagedata);
        luminosity.d=imagedata(:,:,1);
        load(str5)
        module1.e=X;
        single_ends.e=cat(3,X(:,1,:),X(:,2,:));
        contrast.e=LocalContrast;
        imagedata=imread(imagestring.e);
        imagedata=im2double(imagedata);
        luminosity.e=imagedata(:,:,1);

        %% Load geometry file
        load('geo.mat');
end


%% initialize boolean values, thresholds and inputs

% thresholds 
threshold.contrast=1;
threshold.luminosity=0.55;
threshold.length=0.7;
threshold.z=0.0005;
threshold.found_lum=3;
threshold.found_con=3;


%% Take all single endpoints and find where they intersect in 3D... Check the delta-z and if its close then use the 3D point as a starting location
tic
iteration=1;
for i=1:length(single_ends.a(1,1,:))
    for j=1:length(single_ends.e(1,1,:))
   
    [ intersection, deltaZ ] = fGetVectorIntersect( single_ends.a(:,:,i), single_ends.e(:,:,j), theta.a, theta.e, geo, 0 );
    
        if deltaZ<threshold.z % endpoints may belong to the same pin, their vectors intersect closely
            [ output_luminosity.a , output_contrast.a ] = Look_at_Image2( intersection(1),intersection(2),intersection(3), geo,theta.a,contrast.a,luminosity.a );
            [ output_luminosity.b , output_contrast.b ] = Look_at_Image2( intersection(1),intersection(2),intersection(3), geo,theta.b,contrast.b,luminosity.b );
            [ output_luminosity.c , output_contrast.c ] = Look_at_Image2( intersection(1),intersection(2),intersection(3), geo,theta.c,contrast.c,luminosity.c );
            [ output_luminosity.d , output_contrast.d ] = Look_at_Image2( intersection(1),intersection(2),intersection(3), geo,theta.d,contrast.d,luminosity.d );
            [ output_luminosity.e , output_contrast.e ] = Look_at_Image2( intersection(1),intersection(2),intersection(3), geo,theta.e,contrast.e,luminosity.e ); 
            
            % check luminosity and contrast in other images to see if it is
            % indeed on a pin
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
            
            % output a matrix of starting 3D locations that are likely on a
            % pin
            start_points(:,iteration)=intersection;
            iteration=iteration+1;
                
            end
        end
    end
    
end
toc


%%
tic

% thresholds 
threshold.contrast=.7;
threshold.luminosity=0.4;
threshold.length=0.5;
threshold.z=0.001;
threshold.found_lum=3;
threshold.found_con=3;

pin_points=[];
on_pin_fwd=1;
on_pin_bwd=1;
iter=1;
full_pin_found=0;
output_pins=[];
out=[];



% start with a random starting point 
start=start_points(:,round(rand*length(start_points(1,:))));

   % attempt to find the pin orientation for the possible point
    [ Direction1 ] = Find_Pin_Orientation( start(1),start(2),start(3) , geo, theta, contrast, luminosity , threshold ,0);



    if isnan(Direction1)==0 % possible direction has been found

        % initialize both forward and backward directions
        fwd_point1=start;
        fwd_point2=start-(start-Direction1);

        bwd_point1=start;
        bwd_point2=start+(start-Direction1);

        pin_points=[pin_points,start,Direction1];

        while on_pin_fwd==1 || on_pin_bwd==1 % once you walk off the pin in both directions, the loop should break


            % walk along the pin forward attempting to find a next point
            [ fwd_point3 ] = Walk_Along_Pin_2( fwd_point1, fwd_point2, geo, theta, contrast, luminosity , threshold ,0);

            % forward point found, set next loop parameters
            if isnan(fwd_point3)==0
                pin_points=[ pin_points , fwd_point3 ];
                fwd_point1=fwd_point2;
                fwd_point2=fwd_point3;
                iter=iter+1;
            else
                on_pin_fwd=0;
            end


            % walk along the pin backward attempting to find a next point in the opposite direction
            [ bwd_point3 ] = Walk_Along_Pin_2( bwd_point1, bwd_point2, geo, theta, contrast, luminosity , threshold ,0);

            % point found in the backward direction 
            if isnan(bwd_point3)==0
                pin_points=[ bwd_point3 , pin_points ];
                bwd_point1=bwd_point2;
                bwd_point2=bwd_point3;
                iter=iter+1;
            else
                on_pin_bwd=0;
            end


        end


    end





if on_pin_fwd==0 && on_pin_bwd==0 % off pin in both direction 
    pin_points(:,isnan(pin_points(1,:))==1)=[];
    pin_length=sqrt(sum((pin_points(:,1)-pin_points(:,end)).^2));

    % check if the pin has satisfied the length constraint 
    if (pin_length/0.0127) > threshold.length
        full_pin_found=1; % valid pin has been found
    end
end

% set endpoints of the found pins as output
if full_pin_found==1
    Diagnostic='full_pin_found'
    pin_length=pin_length;
    output_pins=cat(3,output_pins,[pin_points(:,1),pin_points(:,end)]);
end

            
toc


%%





%% PLOT SINGLE ENDPOINTS
if 0
    figure
    hold on 
    imshow(luminosity.a)
    for i=1:length(single_ends.a(1,1,:))
       plot(single_ends.a(2,1,i),single_ends.a(1,1,i),'rx')
    end
end
%% PLOT MATRIX OF POINTS
if 1
    validate=start_points(:,round(rand*length(start_points(1,:))));
    labels=0;
    setaxis=[1383 1662 1979 2236];
    setaxis=[0 3000 0 3000];

    [ ~ ] = Experimental_Validator01( validate , theta.a , imagestring.a , geo, setaxis, labels);
    [ ~ ] = Experimental_Validator01( validate , theta.b , imagestring.b , geo, setaxis, labels);
    [ ~ ] = Experimental_Validator01( validate , theta.c , imagestring.c , geo, setaxis, labels);
    [ ~ ] = Experimental_Validator01( validate , theta.d , imagestring.d , geo, setaxis, labels);
    [ ~ ] = Experimental_Validator01( validate , theta.e , imagestring.e , geo, setaxis, labels);
end


%%
if 1
            
            figure
            box off
            hold on
            axis equal
            
            plot3(start(1),start(2),start(3),'ks')
            plot3(Direction1(1),Direction1(2),Direction1(3),'g>')
            asdf=start+(start-Direction1);
            plot3(asdf(1),asdf(2),asdf(3),'r<')
            legend('Start','FWD','BWD')
            
            i=3;
            plot3(pin_points(1,i),pin_points(2,i),pin_points(3,i),'ms')
            
            for i=1:length(pin_points(1,:))
                plot3(pin_points(1,i),pin_points(2,i),pin_points(3,i),'bo')
            end
            
            xlabel('x')
            ylabel('y')
            zlabel('z')
end




