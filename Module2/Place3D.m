function out=Place3D(pnts, theta, geo)

%this function will take a list of paired endpoints on the 2D image and 
%place these endpoints in a 3D space as dictated by geometrical
%measurements calculated using the geo solver code

O_x=geo.O_x; 
O_y=geo.O_y;
O_z=geo.O_z;
Y_of=geo.Y_of;
truelength=geo.truelength;
ppm=geo.ppm;

theta=-(theta)*(pi/180);

locationlist=nan(3,3,length(pnts(1,1,:)));

%% set origin to detector vector in x and y coordinates
Origin_to_Detector(1) = -O_y * sin(theta) ; 
Origin_to_Detector(2) = O_y * cos(theta) ; 

%% loop through module 1 data
for i=1:length(pnts(1,1,:))
    
    %% subtract O_x to get location relative to center of detector
    i1= ( (pnts(2,1,i)/ppm) - O_x );
    k1= pnts(1,1,i)/ppm;

    i2= ( (pnts(2,2,i)/ppm) - O_x);
    k2= pnts(1,2,i)/ppm;
    
    %% Vectors from center of detector to endpoints
    Detector_to_Point1(1) = i1*sin((pi/2)-theta) ; %+x axis
    Detector_to_Point1(2) = i1*cos((pi/2)-theta) ; %+y axis

    Detector_to_Point2(1) = i2*sin((pi/2)-theta) ; %+x axis
    Detector_to_Point2(2) = i2*cos((pi/2)-theta) ; %+y axis
    
    %% Vector from origin to endpoints
    x1= Origin_to_Detector(1) + Detector_to_Point1(1) ;
    y1= Origin_to_Detector(2) + Detector_to_Point1(2) ;
    z1= O_z - k1 ;
    
    x2= Origin_to_Detector(1) + Detector_to_Point2(1) ;
    y2= Origin_to_Detector(2) + Detector_to_Point2(2) ;
    z2= O_z - k2 ;
    
    %% Set point source
    sourceX= Y_of * sin(theta) ;
    sourceY= -Y_of * cos(theta) ;
    sourceZ= 0 ;
    
    %% Set output
    if z1>z2 %always have endpoint in collumn #1 be higher up vertically     
    locationlist(:,:,i)=[ [x1;y1;z1] , [x2;y2;z2] , [sourceX;sourceY;sourceZ] ];
    else        
    locationlist(:,:,i)=[ [x2;y2;z2] , [x1;y1;z1] , [sourceX;sourceY;sourceZ] ];
    end
    
end

out=locationlist;

end