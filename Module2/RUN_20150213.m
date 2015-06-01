%%
clc
clear

%% Sets up parallel toolbox. Comment out next three lines if not using multi-core
if isempty(gcp)==1 
    POOL=parpool('local',8)
end

%% Start module2 loop for all timesteps in study
for timestep=2
    %% setup input files and file name (from module1)
    filename='20150213_02_';
    timestep_string=['000',num2str(timestep)];
    digits_in_timestep=3;
    timestep_string=timestep_string(length(timestep_string)-digits_in_timestep+1:length(timestep_string));
    imagestring=[filename,'X_',timestep_string,'0000.jpg'];

    str1=[filename,timestep_string,'_0000.mat'];
    str2=[filename,timestep_string,'_0225.mat'];
    str3=[filename,timestep_string,'_0450.mat'];
    str4=[filename,timestep_string,'_0675.mat'];
    str5=[filename,timestep_string,'_0900.mat'];
    theta.a=0;
    theta.b=22.5;
    theta.c=45;
    theta.d=67.5;
    theta.e=90;
    load(str1)
    module1.a=X;
    contrast.a=LocalContrast;
    load(str2)
    module1.b=X;
    contrast.b=LocalContrast;
    load(str3)
    module1.c=X;
    contrast.c=LocalContrast;
    load(str4)
    module1.d=X;
    contrast.d=LocalContrast;
    load(str5)
    module1.e=X;
    contrast.e=LocalContrast;

    %% ESTABLISH THRESHOLDS (user input)
    %--------------------------- Triangle thresholds --------------------------
    threshold.normalized_length=.8;
    threshold.metric_spatial=0.005;
    %--------------------------- TopDown thresholds ---------------------------
    threshold.similar_z=0.005;
    %------------------------- Elimination thresholds -------------------------
    silo_boundary.theta1=135; %135 IS USUALLY LOOKING AT THE SKINNY SIDE
    silo_boundary.max1=3000;
    silo_boundary.min1=0;
    silo_boundary.theta2=250;
    silo_boundary.max2=3000;
    silo_boundary.min2=0;

    threshold.contrast_a=1;
    threshold.contrast_b=1;
    threshold.contrast_c=1;
    threshold.contrast_d=1;
    threshold.contrast_e=1;
    
    threshold.number_valid_images=5;

    threshold.normalized_overlap=0.75;

    %% Geometry Inputs
    load([filename,'geo.mat'])
    %% --------------------------------------- EXECUTE MODULE 2 -----------------------------------------
    onetwo3D_script
    pause(30); %pause to give cpu a rest
    %  --------------------------------------------------------------------------------------------------
    %% save output file
    filesavename=[filename,timestep_string,'_Module2_RESULTS.mat'];
    save(filesavename,'PHASE*','theta','threshold','geo','imagestring','timestep')
    clear

end

%% Post Process Loop
for timestep=2
    filename='20150213_02_';
    timestep_string=['000',num2str(timestep)];
    digits_in_timestep=3;
    timestep_string=timestep_string(length(timestep_string)-digits_in_timestep+1:length(timestep_string));
    imagestring=[filename,'X_',timestep_string,'0000.jpg'];
    

    str1=[filename,timestep_string,'_0000.mat'];
    load(str1)

    filesavename=[filename,timestep_string,'_Module2_RESULTS.mat'];
    
    load(filesavename)
    
    load([filename,'geo.mat'])
    
    str1=[filename,timestep_string,'_0000.mat'];
    str2=[filename,timestep_string,'_0225.mat'];
    str3=[filename,timestep_string,'_0450.mat'];
    str4=[filename,timestep_string,'_0675.mat'];
    str5=[filename,timestep_string,'_0900.mat'];
    theta.a=0;
    theta.b=22.5;
    theta.c=45;
    theta.d=67.5;
    theta.e=90;
    load(str1)
    module1.a=X;
    contrast.a=LocalContrast;
    load(str2)
    module1.b=X;
    contrast.b=LocalContrast;
    load(str3)
    module1.c=X;
    contrast.c=LocalContrast;
    load(str4)
    module1.d=X;
    contrast.d=LocalContrast;
    load(str5)
    module1.e=X;
    contrast.e=LocalContrast;

    
    
    %%
    plotlabels=0;
    setaxis=[1000,1950,1400,2900];
    saveimage=0;
    
%     [ ~ ] = Validator( PHASE1_OUT , module1.a, theta.a ,[filename,'X_',timestep_string,'_0000.jpg'], geo, setaxis, 0, plotlabels, saveimage,filename);
%     [ ~ ] = Validator( PHASE2_OUT , module1.a, theta.a ,[filename,'X_',timestep_string,'_0000.jpg'], geo, setaxis, 0, plotlabels, saveimage,filename);
    [ ~ ] = Validator( PHASE3_OUT , module1.a, theta.a ,[filename,'X_',timestep_string,'_0000.jpg'], geo, setaxis, 1, plotlabels, saveimage,filename);

    %%
    saveimage=0;
    setaxis=[-0.07,0.08,-0.1,.1,-0.20,.05];
    [~]=Render_Pebbles(PHASE3_OUT,setaxis,saveimage,[filename,timestep_string]);
    
    %%
end