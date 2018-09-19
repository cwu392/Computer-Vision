% Plot Points Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Visualize the actual 3D points and the estimated 3D camera center.

% You do not need to modify anything in this function, although you can if
% you want to.

function  plot3dview(Points_3D, camera_center1)

figure(12)
hold on
plot3(Points_3D(:,1), Points_3D(:,2), Points_3D(:,3), 'bo', 'MarkerSize',10)
set(gca, 'CameraPosition', [-16.4669 -25.8442 13.5534])
axis equal

%draw vertical lines connecting each point to Z=0
min_z = min(Points_3D(:,3));
for i=1:size(Points_3D,1)
   plot3([Points_3D(i,1); Points_3D(i,1)], ...
         [Points_3D(i,2); Points_3D(i,2)], ...
         [Points_3D(i,3); min_z])
end

if(exist('camera_center1', 'var'))
    plot3(camera_center1(1), camera_center1(2), camera_center1(3), 'r+', 'MarkerSize',10)
    plot3([camera_center1(1); camera_center1(1)], ...
          [camera_center1(2); camera_center1(2)], ...
          [camera_center1(3); min_z],'r');
end



hold off
end

