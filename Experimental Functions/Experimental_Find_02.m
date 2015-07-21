clc
clear

filename='20150128_03_';
% filename='20150128_04_';


timestep=1;
timestep_string=['000',num2str(timestep)];
digits_in_timestep=2;
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

%%
theta.a=0;
theta.b=22.5;
theta.c=45;
theta.d=67.5;
theta.e=90;
load(str1)
module1.a=X;
contrast.a=LocalContrast;
imagedata=imread(imagestring.a);
imagedata=im2double(imagedata);
luminosity.a=imagedata(:,:,1);
load(str2)
module1.b=X;
contrast.b=LocalContrast;
imagedata=imread(imagestring.b);
imagedata=im2double(imagedata);
luminosity.b=imagedata(:,:,1);
load(str3)
module1.c=X;
contrast.c=LocalContrast;
imagedata=imread(imagestring.c);
imagedata=im2double(imagedata);
luminosity.c=imagedata(:,:,1);
load(str4)
module1.d=X;
contrast.d=LocalContrast;
imagedata=imread(imagestring.d);
imagedata=im2double(imagedata);
luminosity.d=imagedata(:,:,1);
load(str5)
module1.e=X;
contrast.e=LocalContrast;
imagedata=imread(imagestring.e);
imagedata=im2double(imagedata);
luminosity.e=imagedata(:,:,1);

%%
load([filename 'geo.mat']);
%%

endpoints.a=Place3D(module1.a, theta.a, geo);
endpoints.b=Place3D(module1.b, theta.b, geo);
endpoints.c=Place3D(module1.c, theta.c, geo);
endpoints.d=Place3D(module1.d, theta.d, geo);
endpoints.e=Place3D(module1.e, theta.e, geo);

%%
range.x=[-2e-2 2e-2];
range.y=[-2e-2 2e-2];
range.z=[-9e-2 -7e-2]+0.01;

% range.x=[0 0];
% range.y=[0.0155 0.0155];
% range.z=[-0.0650 -0.0650];

% range.x=[-1e-2 1e-2];
% range.y=[-13e-2 -11e-2];
% range.z=[-8.9e-2 -8.8e-2];

mesh=0.5e-3;

on_pin_fwd=1;
on_pin_bwd=1;
iter=1;

full_pin_found=0;

out=[];
threshold.contrast=-1.6;
threshold.luminosity=.55;
threshold.length=0.7;


tic

for i=range.x(1):mesh:range.x(2)
    for j=range.y(1):mesh:range.y(2)
        for k=range.z(1):mesh:range.z(2)
            
            x=i;
            y=j;
            z=k;
            
            eliminate=0;
            
                %%
                    [ output_luminosity.a , output_contrast.a ] = Look_at_Image2( x,y,z,geo,theta.a,contrast.a,luminosity.a );
                    
                    if output_luminosity.a<threshold.luminosity %|| point_contrast(1)<contrast_threshold
                        eliminate=1;
                    end
                %%
                if eliminate==0
                    [ output_luminosity.b , output_contrast.b ] = Look_at_Image2( x,y,z,geo,theta.b,contrast.b,luminosity.b );
                    
                    if output_luminosity.b<threshold.luminosity %|| point_contrast(1)<contrast_threshold
                        eliminate=1;
                    end
                end
                %%
                if eliminate==0
                    [ output_luminosity.c , output_contrast.c ] = Look_at_Image2( x,y,z,geo,theta.c,contrast.c,luminosity.c );
                    
                    if output_luminosity.c<threshold.luminosity %|| point_contrast(1)<contrast_threshold
                        eliminate=1;
                    end
                end
                %%
                if eliminate==0
                    [ output_luminosity.d , output_contrast.d ] = Look_at_Image2( x,y,z,geo,theta.d,contrast.d,luminosity.d );
                    
                    if output_luminosity.d<threshold.luminosity %|| point_contrast(1)<contrast_threshold
                        eliminate=1;
                    end
                end
                %%
                if eliminate==0
                    [ output_luminosity.e , output_contrast.e ] = Look_at_Image2( x,y,z,geo,theta.e,contrast.e,luminosity.e );
                    
                    if output_luminosity.e<threshold.luminosity %|| point_contrast(1)<contrast_threshold
                        eliminate=1;
                    end
                end
            %%
            if eliminate==0
               start=[x;y;z];
               on_pin_fwd=1;
               on_pin_bwd=1;
               pin_points=nan(3,1);

                [ Direction1 ] = Find_Pin_Orientation( start(1),start(2),start(3) , geo, theta, contrast, luminosity , threshold ,0);

                if isnan(Direction1)==0
                    Diagnostic='Orientation Found'
                    
                    fwd_point1=start;
                    fwd_point2=start-(start-Direction1);
                    
                    bwd_point1=start;
                    bwd_point2=start+(start-Direction1);

                    pin_points=[pin_points,start,Direction1];

                    while on_pin_fwd==1 || on_pin_bwd==1

                        
                        
                        [ fwd_point3 ] = Walk_Along_Pin_2( fwd_point1, fwd_point2, geo, theta, contrast, luminosity , threshold ,0);
                        
                        
                        if isnan(fwd_point3)==0
                            pin_points=[ pin_points , fwd_point3 ];
                            fwd_point1=fwd_point2;
                            fwd_point2=fwd_point3;
                            iter=iter+1;
                            Diagnostic='FWD Direction Found'
                        else
                            on_pin_fwd=0;
                            Diagnostic='FWD Direction Lost'
                        end
                        
                        
                        
                        [ bwd_point3 ] = Walk_Along_Pin_2( bwd_point1, bwd_point2, geo, theta, contrast, luminosity , threshold ,0);
                        
                        if isnan(bwd_point3)==0
                            pin_points=[ bwd_point3 , pin_points ];
                            bwd_point1=bwd_point2;
                            bwd_point2=bwd_point3;
                            iter=iter+1;
                            Diagnostic='BWD Direction Found'
                        else
                            on_pin_bwd=0;
                            Diagnostic='BWD Direction Lost'
                        end
                        
                            
                    end


                end
            end
            
            if on_pin_fwd==0 && on_pin_bwd==0
                pin_length=sqrt(sum((pin_points(:,1)-pin_points(:,end)).^2));
                
                if (pin_length/0.0127) > threshold.length
                    full_pin_found=1
                end
            end
            
            if full_pin_found==1
                break
            end
            
        end
        
            if on_pin_fwd==0 && on_pin_bwd==0                
                if (pin_length/0.0127) > threshold.length
                    full_pin_found=1
                end
            end
            
            if full_pin_found==1
                break
            end
    end
            if on_pin_fwd==0 && on_pin_bwd==0                
                if (pin_length/0.0127) > threshold.length
                    full_pin_found=1
                end
            end
            
            if full_pin_found==1
                break
                pin_length
            end
    step=i
end
toc
%%
if 1
            %%
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
            
            for i=1
            plot3([range.x(1),range.x(2)],[range.y(1),range.y(1)],[range.z(1),range.z(1)],'r-')
            plot3([range.x(1),range.x(2)],[range.y(2),range.y(2)],[range.z(1),range.z(1)],'r-')
            plot3([range.x(1),range.x(2)],[range.y(1),range.y(1)],[range.z(2),range.z(2)],'r-')
            plot3([range.x(1),range.x(2)],[range.y(2),range.y(2)],[range.z(2),range.z(2)],'r-')
            
            plot3([range.x(1),range.x(1)],[range.y(1),range.y(2)],[range.z(1),range.z(1)],'r-')
            plot3([range.x(2),range.x(2)],[range.y(1),range.y(2)],[range.z(1),range.z(1)],'r-')
            plot3([range.x(1),range.x(1)],[range.y(1),range.y(2)],[range.z(2),range.z(2)],'r-')
            plot3([range.x(2),range.x(2)],[range.y(1),range.y(2)],[range.z(2),range.z(2)],'r-')
            
            plot3([range.x(1),range.x(1)],[range.y(1),range.y(1)],[range.z(1),range.z(2)],'r-')
            plot3([range.x(1),range.x(1)],[range.y(2),range.y(2)],[range.z(1),range.z(2)],'r-')
            plot3([range.x(2),range.x(2)],[range.y(1),range.y(1)],[range.z(1),range.z(2)],'r-')
            plot3([range.x(2),range.x(2)],[range.y(2),range.y(2)],[range.z(1),range.z(2)],'r-')
            end
            
            xlabel('x')
            ylabel('y')
            zlabel('z')
end
%%
validate=pin_points(:,:);
labels=0;
setaxis=[1383 1662 1979 2236];
setaxis=[0 3000 0 3000];

[ ~ ] = Experimental_Validator01( validate , theta.a , imagestring.a , geo, setaxis, labels);
[ ~ ] = Experimental_Validator01( validate , theta.b , imagestring.b , geo, setaxis, labels);
[ ~ ] = Experimental_Validator01( validate , theta.c , imagestring.c , geo, setaxis, labels);
[ ~ ] = Experimental_Validator01( validate , theta.d , imagestring.d , geo, setaxis, labels);
[ ~ ] = Experimental_Validator01( validate , theta.e , imagestring.e , geo, setaxis, labels);
