clc


if 1
    clear
        filename='20150128_03_';
        % filename='20150128_04_';
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
        load('geo.mat');
end


%%

on_pin_fwd=1;
on_pin_bwd=1;
iter=1;

full_pin_found=0;
output_pins=[];

out=[];
threshold.contrast=0;
threshold.luminosity=0.1;
threshold.length=0.7;

threshold.found_lum=3;
threshold.found_con=3;

%enter point in imageangle on a single pin [pixels][row,column]
pnt=[2056 1373]; 
imageangle=theta.c;

[point3D , vector3D]=Get_1pnt_Vector(pnt, imageangle, geo ,1);

mesh=1e-4;
endmesh=0.25;
metric_step_sizeXYZ=mesh*vector3D;

point_assessments=zeros(4,length(0:mesh:endmesh));
iter=1;
%%

tic
for t=0:mesh:endmesh
    
    point_assessments(1,iter)=t;
    
        full_pin_found=0;
            
            x = point3D(1)+t*vector3D(1);
            y = point3D(2)+t*vector3D(2);
            z = point3D(3)+t*vector3D(3);
                                    
            found_variable_lum=0;
            found_variable_con=0;
            
            output_luminosity.a=0;
            output_luminosity.b=0;
            output_luminosity.c=0;
            output_luminosity.d=0;
            output_luminosity.e=0;
            
            output_contrast.a=0;
            output_contrast.b=0;
            output_contrast.c=0;
            output_contrast.d=0;
            output_contrast.e=0;

                %%
                    [ output_luminosity.a , output_contrast.a ] = Look_at_Image2( x,y,z,geo,theta.a,contrast.a,luminosity.a );
                    [ output_luminosity.b , output_contrast.b ] = Look_at_Image2( x,y,z,geo,theta.b,contrast.b,luminosity.b );
                    [ output_luminosity.c , output_contrast.c ] = Look_at_Image2( x,y,z,geo,theta.c,contrast.c,luminosity.c );
                    [ output_luminosity.d , output_contrast.d ] = Look_at_Image2( x,y,z,geo,theta.d,contrast.d,luminosity.d );
                    [ output_luminosity.e , output_contrast.e ] = Look_at_Image2( x,y,z,geo,theta.e,contrast.e,luminosity.e );
                    
            %%
            point_assessments(2,iter)=output_luminosity.a+output_luminosity.b+output_luminosity.c+output_luminosity.d+output_luminosity.e;
            point_assessments(3,iter)=output_contrast.a+output_contrast.b+output_contrast.c+output_contrast.d+output_contrast.e;
            point_assessments(4,iter)=5*point_assessments(2,iter)+point_assessments(3,iter);
            iter=iter+1;
end
toc
    %%
    if 1

       figure
        hold on
%         plot(point_assessments(1,:),5*point_assessments(2,:),'b-')
        plot(point_assessments(1,:),point_assessments(2,:),'r-')
        plot(point_assessments(1,:),point_assessments(3,:)./5,'b-')
        legend('Luminosity','Contrast','combined');
%         axis([0 endmesh 0 25])
        xlabel('Distance along Vector3D')
        ylabel('Luminosity or Contrast')

    end
%%

            possible_points=point_assessments(1,find(point_assessments(4,:)>32));
            
            for t=possible_points

                start=[point3D(1)+t*vector3D(1);
                   point3D(2)+t*vector3D(2);
                   point3D(3)+t*vector3D(3)];
               on_pin_fwd=1;
               on_pin_bwd=1;
               pin_points=nan(3,1);

                [ Direction1 ] = Find_Pin_Orientation( start(1),start(2),start(3) , geo, theta, contrast, luminosity , threshold ,0);

                if isnan(Direction1)==0 
                    
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
                        else
                            on_pin_fwd=0;
                        end
                        
                        
                        
                        [ bwd_point3 ] = Walk_Along_Pin_2( bwd_point1, bwd_point2, geo, theta, contrast, luminosity , threshold ,0);
                        
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
            
            
            
            
            
            if on_pin_fwd==0 && on_pin_bwd==0
                pin_points(:,isnan(pin_points(1,:))==1)=[];
                pin_length=sqrt(sum((pin_points(:,1)-pin_points(:,end)).^2));
                
                if (pin_length/0.0127) > threshold.length
                    full_pin_found=1;
                end
            end
            
            if full_pin_found==1
                Diagnostic='full_pin_found'
                pin_length=pin_length;
                output_pins=cat(3,output_pins,[pin_points(:,1),pin_points(:,end)]);
            end
            
        

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
            
            xlabel('x')
            ylabel('y')
            zlabel('z')
end
%%
if 1
    validate=pin_points(:,:);
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
    validate=output_pins(:,:,:);
    labels=0;
    setaxis=[1383 1662 1979 2236];
    setaxis=[0 3000 0 3000];

    [ ~ ] = Validator( validate , zeros(2,2,2), theta.a , imagestring.a , geo, setaxis, 0, 0, 0, nan);
    [ ~ ] = Validator( validate , zeros(2,2,2), theta.b , imagestring.b , geo, setaxis, 0, 0, 0, nan);
    [ ~ ] = Validator( validate , zeros(2,2,2), theta.c , imagestring.c , geo, setaxis, 0, 0, 0, nan);
    [ ~ ] = Validator( validate , zeros(2,2,2), theta.d , imagestring.d , geo, setaxis, 0, 0, 0, nan);
    [ ~ ] = Validator( validate , zeros(2,2,2), theta.e , imagestring.e , geo, setaxis, 0, 0, 0, nan);
end