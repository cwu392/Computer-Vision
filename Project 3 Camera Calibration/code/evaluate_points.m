% Plot Points Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Visualize the actual 2D points and the projected 2D points calculated
% from the projection matrix

% You do not need to modify anything in this function, although you can if
% you want to.

function [Projected_2D_Pts, Residual] = evaluate_points( M, Points_2D, Points_3D)

Projection = M*[Points_3D ones(size(Points_3D,1),1)]';
Projection = Projection';
u = Projection(:,1)./Projection(:,3);
v = Projection(:,2)./Projection(:,3);
Residual = sum(((u-Points_2D(:,1)).^2+(v-Points_2D(:,2)).^2).^0.5);
Projected_2D_Pts = [u v];

end

