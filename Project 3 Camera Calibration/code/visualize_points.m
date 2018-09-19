% Plot Points Stencil Code
% CS 4495 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu and James Hays

% Visualize the actual 2D points and the projected 2D points calculated
% from the projection matrix

% You do not need to modify anything in this function, although you can if
% you want to.

function [] = visualize_points( Actual_Pts, Project_Pts)
    figure(11)
    plot(Actual_Pts(:,1),Actual_Pts(:,2),'ro');
    hold on
    plot(Project_Pts(:,1),Project_Pts(:,2),'+');
    legend('Actual Points','Projected Points');
    hold off
end

