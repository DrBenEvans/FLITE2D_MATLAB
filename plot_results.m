function [] = plot_results(mesh,res,fignumber)
%PLOT_RESULTS Summary of this function goes here
%   Detailed explanation goes here



hold
figure(fignumber)
%colormap(jet)
%trisurf(mesh.connec(:,1:3),mesh.xy(:,1),mesh.xy(:,2),res(:,1),'linestyle','none')
%shading interp;
[C,H]=tricontour(mesh.xy,mesh.connec,res,20);
%clabel(C,H);

set(gca,'DataAspectRatio',[1 1 1],'Xlim',[-0.3 1.3],'Ylim',[-0.6 0.6])
daspect([1 1 1])
view(2)
hold



end

