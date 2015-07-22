%% Select pins from module1 only in a certain range

if 0
    
lowrange=2000;
highrange=2500;

mod_module1.a=[];
for i=1:length(module1.a(1,1,:))
    if ((module1.a(1,1,i)+module1.a(1,2,i))/2)<highrange && ((module1.a(1,1,i)+module1.a(1,2,i))/2)>lowrange
        mod_module1.a=cat(3,mod_module1.a,module1.a(:,:,i));
    end
end

mod_module1.b=[];
for i=1:length(module1.b(1,1,:))
    if ((module1.b(1,1,i)+module1.b(1,2,i))/2)<highrange && ((module1.b(1,1,i)+module1.b(1,2,i))/2)>lowrange
        mod_module1.b=cat(3,mod_module1.b,module1.b(:,:,i));
    end
end

mod_module1.c=[];
for i=1:length(module1.c(1,1,:))
    if ((module1.c(1,1,i)+module1.c(1,2,i))/2)<highrange && ((module1.c(1,1,i)+module1.c(1,2,i))/2)>lowrange
        mod_module1.c=cat(3,mod_module1.c,module1.c(:,:,i));
    end
end

mod_module1.d=[];
for i=1:length(module1.d(1,1,:))
    if ((module1.d(1,1,i)+module1.d(1,2,i))/2)<highrange && ((module1.d(1,1,i)+module1.d(1,2,i))/2)>lowrange
        mod_module1.d=cat(3,mod_module1.d,module1.d(:,:,i));
    end
end

mod_module1.e=[];
for i=1:length(module1.e(1,1,:))
    if ((module1.e(1,1,i)+module1.e(1,2,i))/2)<highrange && ((module1.e(1,1,i)+module1.e(1,2,i))/2)>lowrange
        mod_module1.e=cat(3,mod_module1.e,module1.e(:,:,i));
    end
end

module1.a=mod_module1.a;
module1.b=mod_module1.b;
module1.c=mod_module1.c;
module1.d=mod_module1.d;
module1.e=mod_module1.e;

% module1.a=module1.a(:,:,[10]);
% module1.b=module1.b(:,:,[8]);
% module1.c=module1.c(:,:,[]);
% module1.d=module1.d(:,:,[]);
% module1.e=module1.e(:,:,[]);
% 
% module1.c=zeros(3,2);
% module1.d=zeros(3,2);
% module1.e=zeros(3,2);

end


%%  Place endpoints in 3D space

tic

endpoints.a=Place3D(module1.a, theta.a, geo);
endpoints.b=Place3D(module1.b, theta.b, geo);
endpoints.c=Place3D(module1.c, theta.c, geo);
endpoints.d=Place3D(module1.d, theta.d, geo);
endpoints.e=Place3D(module1.e, theta.e, geo);

time.Place3D=toc

% endpoints(:,:,i)=[ [x1;y1;z1] , [x2;y2;z2] , [sourceX;sourceY;sourceZ] ];
% where z1>z2. [meters]

%% Initiate PHASE1 Parallel search and find algorithm
tic

[ PHASE1_OUT , PHASE1_DIAGNOSTICS ] = PHASE1_Parallel_Find( endpoints, contrast, theta, threshold, geo, 0);

time.find=toc

%% Eliminate pins that are outside of the silo using max and min i data points from module 1
tic

[ PHASE2_OUT , PHASE2_DIAGNOSTICS , eliminate] = PHASE2_Eliminate_Outsiders( PHASE1_OUT , PHASE1_DIAGNOSTICS ,theta, module1, silo_boundary, geo, 0);

time.eliminate_outsiders=toc


%% Eliminate false positives and extra pins by overlap logic
tic

[ PHASE3_OUT , PHASE3_DIAGNOSTICS ,  eliminate_data] = PHASE3_Eliminate_Overlaps( ...
    PHASE2_OUT , PHASE2_DIAGNOSTICS , threshold  );

time.eliminate_overlaps=toc

