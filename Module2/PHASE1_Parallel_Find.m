function [ PHASE1_OUT , PHASE1_DIAGNOSTICS ] = PHASE1_Parallel_Find(endpoints, contrast, theta, threshold, geo, plotboolean)
%% Find possible pin intersections in 3D and return matrix of possible 3D endpoints

PHASE1_OUT=[];
PHASE1_DIAGNOSTICS=[];

%% Set found boolean arrays (elimination booleans) 

found1=zeros(length(endpoints.a(1,1,:)),1);
found2=zeros(length(endpoints.b(1,1,:)),1);
found3=zeros(length(endpoints.a(1,1,:)),1);
found4=zeros(length(endpoints.c(1,1,:)),1);
found5=zeros(length(endpoints.a(1,1,:)),1);
found6=zeros(length(endpoints.d(1,1,:)),1);
found7=zeros(length(endpoints.b(1,1,:)),1);
found8=zeros(length(endpoints.c(1,1,:)),1);
found9=zeros(length(endpoints.b(1,1,:)),1);
found10=zeros(length(endpoints.d(1,1,:)),1);
found11=zeros(length(endpoints.c(1,1,:)),1);
found12=zeros(length(endpoints.d(1,1,:)),1);
found13=zeros(length(endpoints.a(1,1,:)),1);
found14=zeros(length(endpoints.e(1,1,:)),1);
found15=zeros(length(endpoints.b(1,1,:)),1);
found16=zeros(length(endpoints.e(1,1,:)),1);
        
        
        warning('off','all')
        
        %% parallel loops. 1:8 for an octo-core computer
        % comment out parfor line and replace with "for parallel=1:8" if no
        % parallel processing is to be used
        
        parfor parallel=1:8
%         for parallel=1:8
            
            % parallel computing requires uniform inputs to each loop
            if parallel==1
                endpoints_par1=endpoints.a;
                endpoints_par2=endpoints.b;
                found_par1=found1;
                found_par2=found2;
            elseif parallel==2
                endpoints_par1=endpoints.a;
                endpoints_par2=endpoints.c;
                found_par1=found3;
                found_par2=found4;
            elseif parallel==3
                endpoints_par1=endpoints.a;
                endpoints_par2=endpoints.d;
                found_par1=found5;
                found_par2=found6;
            elseif parallel==4
                endpoints_par1=endpoints.b;
                endpoints_par2=endpoints.c;
                found_par1=found7;
                found_par2=found8;
            elseif parallel==5
                endpoints_par1=endpoints.b;
                endpoints_par2=endpoints.d;
                found_par1=found9;
                found_par2=found10;
            elseif parallel==6
                endpoints_par1=endpoints.c;
                endpoints_par2=endpoints.d;
                found_par1=found11;
                found_par2=found12;
            elseif parallel==7
                endpoints_par1=endpoints.a;
                endpoints_par2=endpoints.e;
                found_par1=found13;
                found_par2=found14;
            elseif parallel==8
                endpoints_par1=endpoints.b;
                endpoints_par2=endpoints.e;
                found_par1=found15;
                found_par2=found16;
            end
                   
            %% execute find algorithm 
            [phase1out1 , phase1diagnostics1, found_par1, found_par2]=Find2_W_Verify(endpoints_par1,endpoints_par2,found_par1,found_par2,contrast, theta, threshold, geo,plotboolean);
        
        
            %% Handle outputs
            parout{parallel}=phase1out1;
            parout_diag{parallel}=phase1diagnostics1;
            
            found_out1{parallel}=found_par1;
            found_out2{parallel}=found_par2;

        
        end
        
        %% boolean found/assigned arrays
        found1=found_out1{1};
        found2=found_out2{1};
        found3=found_out1{2};
        found4=found_out2{2};
        found5=found_out1{3};
        found6=found_out2{3};
        found7=found_out1{4};
        found8=found_out2{4};
        found9=found_out1{5};
        found10=found_out2{5};
        found11=found_out1{6};
        found12=found_out2{6};
        found13=found_out1{7};
        found14=found_out2{7};
        found15=found_out1{8};
        found16=found_out2{8};
        
        %% create ouput matrix
        PHASE1_OUT=cat(3,PHASE1_OUT,parout{1},parout{2},parout{3},parout{4},parout{5},parout{6},parout{7},parout{8});

        %% create output diagnostics matrix 
        PHASE1_DIAGNOSTICS=cat(3,PHASE1_DIAGNOSTICS,parout_diag{1},...
        parout_diag{2},parout_diag{3},parout_diag{4},...
        parout_diag{5},parout_diag{6},...
        parout_diag{7},parout_diag{8});
                       
        %% return simple diagnostics to the command window 
        [num2str(length(find((found1+found3+found5)~=0))),' assigned out of ',num2str(length(endpoints.a(1,1,:)))]
        

end

