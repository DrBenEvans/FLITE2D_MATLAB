function [] = plot_mesh( mesh1 )
%PLOT_MESH Summary of this function goes here
%   Detailed explanation goes here

figure
triplot(mesh1.connec, mesh1.xy(:,1), mesh1.xy(:,2))
set(gca,'DataAspectRatio',[1 1 1])

end

