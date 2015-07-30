%%%% FULL XPREX GEOMETRY SOLVER USING MACHINED CALIBRATION PIECE AND N
%%%% CALIBRATION IMAGES. 

clear

%% Constant Values
global O_y
global Y_of

O_y=0.2283;
Y_of=1.8453;

%% input calibration image data. 
% cal_data(:,:,1)=[ [angle;nan] , [k1;i1]  ];
% where 1 and 2 are the point locations

% single point (screw tip) locations
alignment_diverging_20140903(:,:,1)=[ [0;nan] , [484;656] ];
alignment_diverging_20140903(:,:,2)=[ [22.5;nan] , [460;791] ];
alignment_diverging_20140903(:,:,3)=[ [45;nan] , [442;1048] ];
alignment_diverging_20140903(:,:,4)=[ [67.5;nan] , [433;1387] ];
alignment_diverging_20140903(:,:,5)=[ [90;nan] , [434;1751] ];
alignment_diverging_20140903(:,:,6)=[ [180;nan] , [516;2346] ];
alignment_diverging_20140903(:,:,7)=[ [270;nan] , [558;1303] ];
alignment_diverging_20140903(:,:,8)=[ [292.5;nan] , [547;1010] ];
alignment_diverging_20140903(:,:,9)=[ [315;nan] , [531;782] ];
alignment_diverging_20140903(:,:,10)=[ [337.5;nan] , [509;655] ];

%Calibration plate locations
calibration_plate_alignment(:,:,1)=[ [0;nan] , [nan;2483] ];
calibration_plate_alignment(:,:,2)=[ [5;nan] , [nan;2473] ];
calibration_plate_alignment(:,:,3)=[ [10;nan] , [nan;2457] ];
calibration_plate_alignment(:,:,4)=[ [40;nan] , [nan;2221] ];
calibration_plate_alignment(:,:,5)=[ [45;nan] , [nan;2163] ];
calibration_plate_alignment(:,:,6)=[ [50;nan] , [nan;2101] ];
calibration_plate_alignment(:,:,7)=[ [85;nan] , [nan;1587] ];
calibration_plate_alignment(:,:,8)=[ [90;nan] , [nan;1508] ];
calibration_plate_alignment(:,:,9)=[ [95;nan] , [nan;1429] ];
calibration_plate_alignment(:,:,10)=[ [130;nan] , [nan;917] ];
calibration_plate_alignment(:,:,11)=[ [135;nan] , [nan;855] ];
calibration_plate_alignment(:,:,12)=[ [140;nan] , [nan;798] ];
calibration_plate_alignment(:,:,13)=[ [175;nan] , [nan;553] ];
calibration_plate_alignment(:,:,14)=[ [180;nan] , [nan;544] ];
calibration_plate_alignment(:,:,15)=[ [185;nan] , [nan;543] ];

alignment_converging_20140626(:,:,1)=[ [0;nan] , [2482;679] ];
alignment_converging_20140626(:,:,2)=[ [30;nan] , [2515;647] ];
alignment_converging_20140626(:,:,3)=[ [60;nan] , [2544;851] ];
alignment_converging_20140626(:,:,4)=[ [90;nan] , [2561;1249] ];
alignment_converging_20140626(:,:,5)=[ [120;nan] , [2559;1727] ];
alignment_converging_20140626(:,:,6)=[ [150;nan] , [2540;2135] ];
alignment_converging_20140626(:,:,7)=[ [180;nan] , [2510;2351] ];

paintballhopper_20141229(:,:,1)=[ [0;nan] , [2412;1437] ];
paintballhopper_20141229(:,:,2)=[ [22.5;nan] , [2406;2044] ];
paintballhopper_20141229(:,:,3)=[ [45;nan] , [2385;2544] ];
paintballhopper_20141229(:,:,4)=[ [67.5;nan] , [2355;2854] ];
paintballhopper_20141229(:,:,5)=[ [90;nan] , [2320;2932] ];
paintballhopper_20141229(:,:,6)=[ [112.5;nan] , [2291;2803] ];
paintballhopper_20141229(:,:,7)=[ [135;nan] , [2268;2498] ];
paintballhopper_20141229(:,:,8)=[ [157.5;nan] , [2253;2076] ];
paintballhopper_20141229(:,:,9)=[ [180;nan] , [2248;1583] ];
paintballhopper_20141229(:,:,10)=[ [202.5;nan] , [2251;1091] ];
paintballhopper_20141229(:,:,11)=[ [225;nan] , [2261;645] ];
paintballhopper_20141229(:,:,12)=[ [247.5;nan] , [2283;309] ];
paintballhopper_20141229(:,:,13)=[ [270;nan] , [2311;131] ];
paintballhopper_20141229(:,:,14)=[ [292.5;nan] , [2343;154] ];
paintballhopper_20141229(:,:,15)=[ [315;nan] , [2376;398] ];
paintballhopper_20141229(:,:,16)=[ [337.5;nan] , [2399;850] ];

paintballhopper_20150105(:,:,1)=[ [0;nan] , [2473;415] ];
paintballhopper_20150105(:,:,2)=[ [22.5;nan] , [2503;450] ];
paintballhopper_20150105(:,:,3)=[ [45;nan] , [2528;659] ];
paintballhopper_20150105(:,:,4)=[ [67.5;nan] , [2546;1017] ];
paintballhopper_20150105(:,:,5)=[ [90;nan] , [2553;1465] ];
paintballhopper_20150105(:,:,6)=[ [112.5;nan] , [2548;1922] ];
paintballhopper_20150105(:,:,7)=[ [135;nan] , [2529;2305] ];
paintballhopper_20150105(:,:,8)=[ [157.5;nan] , [2506;2549] ];
paintballhopper_20150105(:,:,9)=[ [180;nan] , [2477;2620] ];
paintballhopper_20150105(:,:,10)=[ [202.5;nan] , [2449;2522] ];
paintballhopper_20150105(:,:,11)=[ [225;nan] , [2426;2284] ];
paintballhopper_20150105(:,:,12)=[ [247.5;nan] , [2414;1951] ];
paintballhopper_20150105(:,:,13)=[ [270;nan] , [2407;1565] ];
paintballhopper_20150105(:,:,14)=[ [292.5;nan] , [2410;1171] ];
paintballhopper_20150105(:,:,15)=[ [315;nan] , [2425;813] ];
paintballhopper_20150105(:,:,16)=[ [337.5;nan] , [2448;546] ];

CoBIE_20150129(:,:,1)=[ [0;nan] , [2800;2673] ];
CoBIE_20150129(:,:,2)=[ [22.5;nan] , [2763;2512] ];
CoBIE_20150129(:,:,3)=[ [45;nan] , [2734;2217] ];
CoBIE_20150129(:,:,4)=[ [67.5;nan] , [2719;1833] ];
CoBIE_20150129(:,:,5)=[ [90;nan] , [2717;1409] ];
CoBIE_20150129(:,:,6)=[ [112.5;nan] , [2728;999] ];
CoBIE_20150129(:,:,7)=[ [135;nan] , [2751;652] ];
CoBIE_20150129(:,:,8)=[ [157.5;nan] , [2785;421] ];
CoBIE_20150129(:,:,9)=[ [180;nan] , [2825;344] ];
CoBIE_20150129(:,:,10)=[ [202.5;nan] , [2865;447] ];
CoBIE_20150129(:,:,11)=[ [225;nan] , [2900;731] ];
CoBIE_20150129(:,:,12)=[ [247.5;nan] , [2923;1166] ];
CoBIE_20150129(:,:,13)=[ [270;nan] , [2934;1670] ];
CoBIE_20150129(:,:,14)=[ [292.5;nan] , [2913;2139] ];
CoBIE_20150129(:,:,15)=[ [315;nan] , [2881;2487] ];
CoBIE_20150129(:,:,16)=[ [337.5;nan] , [2840;2671] ];

GeoCalib_20150729(:,:,1)=[ [0;nan] , [2797;847] ];
GeoCalib_20150729(:,:,2)=[ [22.5;nan] , [2808;1282] ];
GeoCalib_20150729(:,:,3)=[ [45;nan] , [2806;1761] ];
GeoCalib_20150729(:,:,4)=[ [67.5;nan] , [2791;2193] ];
GeoCalib_20150729(:,:,5)=[ [90;nan] , [2762;2498] ];
GeoCalib_20150729(:,:,6)=[ [112.5;nan] , [2734;2636] ];
GeoCalib_20150729(:,:,7)=[ [135;nan] , [2703;2598] ];
GeoCalib_20150729(:,:,8)=[ [157.5;nan] , [2677;2404] ];
GeoCalib_20150729(:,:,9)=[ [180;nan] , [2659;2091] ];
GeoCalib_20150729(:,:,10)=[ [202.5;nan] , [2650;1705] ];
GeoCalib_20150729(:,:,11)=[ [225;nan] , [2652;1296] ];
GeoCalib_20150729(:,:,12)=[ [247.5;nan] , [2663;917] ];
GeoCalib_20150729(:,:,13)=[ [270;nan] , [2684;613] ];
GeoCalib_20150729(:,:,14)=[ [292.5;nan] , [2710;425] ];
GeoCalib_20150729(:,:,15)=[ [315;nan] , [2741;390] ];
GeoCalib_20150729(:,:,16)=[ [337.5;nan] , [2772;534] ];

input_data=GeoCalib_20150729;

%% Do sin fit

% param = [offset, amplitude, phaseshift, frequency]
fixedparam=[NaN, NaN , NaN , 1/360];
fixedparam=[NaN, NaN , NaN , NaN];

for i=1:length(input_data(1,1,:))
   angles(i)=input_data(1,1,i);
   horiz_loc(i)=input_data(2,2,i);
end

param=XPREX_20141029_sine_fit(angles,horiz_loc,fixedparam ,[],0);

mesh=0:0.001:360;

X = mesh;
Y = (param(1) + param(2) * sin( param(3) + 2*pi*param(4)*mesh ));

for i=2:(length(Y)-1)
    dY(i)=(Y(i-1)-Y(i+1));
end

%% SIN FIT OUTPUTS

dy_max=find(dY==max(dY));
dy_min=find(dY==min(dY));

% Positive (additive) angle offset
Angle_offset=90-X(dy_max);

% The following are  FINAL outputs.  

% Distance from left of detector to origin plane.
global O_x

O_x=Y(dy_max)/(6993);

%% PLOT commands
if 1
    
figure('Color','w','WindowStyle','docked')
hold on
plot(angles,horiz_loc,'+');
plot(X,Y);
xlabel('angles')
ylabel('horiz locations')
plot(X(dy_max),Y(dy_max),'Marker','x','LineWidth',10,'color','g')
plot(X(dy_min),Y(dy_min),'Marker','x','LineWidth',10,'color','r')
legend('data','curve','max','min')

figure('Color','w','WindowStyle','docked')
hold on
plot(X(2:length(X)),dY)
plot(X(dy_max),Y(dy_max)/100000,'Marker','x','LineWidth',10,'color','g')
plot(X(dy_min),Y(dy_min)/100000,'Marker','x','LineWidth',10,'color','r')
legend('','max','min')

end

%% TOP VIEW GEOMETRY SOLVER

%input angles with max or min i values
top_view_angle=find(input_data(2,2,:)==max(input_data(2,2,:)));
theta=input_data(1,1,top_view_angle);
i=input_data(2,2,top_view_angle)/6993;

R_rot=( Y_of*abs(i-O_x) ) / ( ((Y_of+O_y)*cos((theta+Angle_offset)*(pi/180))) - (abs(i-O_x)*sin((theta+Angle_offset)*(pi/180))));


%% SIDE VIEW GEOMETRY SOLVER

one1=find(input_data(1,2,:)==min(input_data(1,2,:)));
two2=find(input_data(1,2,:)==max(input_data(1,2,:)));

k1=input_data(1,2,one1)/6993;
k2=input_data(1,2,two2)/6993;

R1=(abs(R_rot)*(sin((angles(one1)+Angle_offset)*(pi/180))));
R2=(abs(R_rot)*(sin((angles(two2)+Angle_offset)*(pi/180))));

O_z=abs(((k2*Y_of)+(k2*R2)-(k1*Y_of)-(k1*R1))/(R2-R1));


%% FINAL OUTPUT

geo.Y_of=Y_of;
geo.O_x=O_x;
geo.O_y=O_y;
geo.O_z=O_z;
geo.ppm=6993;
geo.truelength=0.0126;

save('geo','geo')

