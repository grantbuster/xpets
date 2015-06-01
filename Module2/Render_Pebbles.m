function out=Render_Pebbles(coordinates,setaxis,printboolean,filename)

midpoints=nan(length(coordinates),3);
directionvector=nan(length(coordinates),3);

for i=1:length(coordinates)
    if isnan(coordinates(1,1,i))==0
        
    midpoints(i,1)=(coordinates(1,1,i)+coordinates(1,2,i))/2;
    midpoints(i,2)=(coordinates(2,1,i)+coordinates(2,2,i))/2;
    midpoints(i,3)=(coordinates(3,1,i)+coordinates(3,2,i))/2;
    
    directionvector(i,1)=coordinates(1,1,i)-coordinates(1,2,i);
    directionvector(i,2)=coordinates(2,1,i)-coordinates(2,2,i);
    directionvector(i,3)=coordinates(3,1,i)-coordinates(3,2,i);
    
    end
end

figure('Color','w','WindowStyle','docked')
hold on

for i=1:length(midpoints)
    xx=i/length(midpoints);
   c(i,:)=[.99,.99,.99]; 
   r(i,:)=0.0126/2;
end

    bubbleplot3(midpoints(:,1),midpoints(:,2),midpoints(:,3),r,c,1);

    
    
    
for i=1:length(midpoints)
    
    center=midpoints(i,:);
    radius=(.0126/2)+.0001;
    
    normal=directionvector(i,:);
    
theta=0:0.01:2*pi;
v=null(normal);

points1=repmat(center',1,size(theta,2))+radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
% plot3([coordinates(1,1,i),coordinates(1,2,i)],[coordinates(2,1,i),coordinates(2,2,i)],[coordinates(3,1,i),coordinates(3,2,i)],'b-','LineWidth',1);
plot3(points1(1,:),points1(2,:),points1(3,:),'b-','LineWidth',1);

end
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
axis equal
out=[];
view([0,1,0]);
camlight
axis(setaxis)
title(['Pebble Bed Render. ',num2str(length(coordinates(1,1,:))),' Pebbles Found.'])

if printboolean==1
    saveas(gcf,[filename,'.jpg'])
end

end