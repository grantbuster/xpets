function [point3D , vector3D]=Get_1pnt_Vector(pnt, theta, geo, plotboolean)

%this function will take a list of paired endpoints on the 2D image and 
%place these endpoints in a 3D space as dictated by geometrical
%measurements calculated using the geo solver code

O_x=geo.O_x; 
O_y=geo.O_y;
O_z=geo.O_z;
Y_of=geo.Y_of;
ppm=geo.ppm;

theta=-(theta)*(pi/180);

Origin_to_Detector(1) = -O_y * sin(theta) ; %x axis, to the right when looking at detector
Origin_to_Detector(2) = O_y * cos(theta) ; %y axis, looking at the detector from the source

    
    i1= ( (pnt(2)/ppm) - O_x );
    k1= pnt(1)/ppm;

    
    Detector_to_Point1(1) = i1*sin((pi/2)-theta) ; %+x axis
    Detector_to_Point1(2) = i1*cos((pi/2)-theta) ; %+y axis


    
    x1= Origin_to_Detector(1) + Detector_to_Point1(1) ;
    y1= Origin_to_Detector(2) + Detector_to_Point1(2) ;
    z1= O_z - k1 ;
    
    
    sourceX= Y_of * sin(theta) ;
    sourceY= -Y_of * cos(theta) ;
    sourceZ= 0 ;
    
    

point3D=[x1;y1;z1];
vector3D=[-x1+sourceX;-y1+sourceY;-z1];

if plotboolean==1
   figure 
   hold on
   plot3([point3D(1),point3D(1)+vector3D(1)],[point3D(2),point3D(2)+vector3D(2)],[point3D(3),point3D(3)+vector3D(3)])
   plot3(point3D(1),point3D(2),point3D(3),'g>')
   plot3(point3D(1)+vector3D(1),point3D(2)+vector3D(2),point3D(3)+vector3D(3),'r<');
   axis equal
   xlabel('x')
   ylabel('y')
   zlabel('z')
end

end