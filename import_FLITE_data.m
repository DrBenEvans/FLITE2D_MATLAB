function [results, residual] = import_FLITE_data(rsdname,resname,mesh)

% This script imports all the data output by the FLITE 2D solver and
% preprocessor





results = importdata(resname);
residual = importdata(rsdname);


%Residual file works like this
%Iteration Number | Residual | Lift | Drag | Momentum | Pressure Lift |
%Pressure Drag | Friction Drag

figure
plot(residual(:,1),residual(:,2))
title('Convergence Plot');
xlabel('Iteration Number')
ylabel('log(residual)')

figure
hold
plot(residual(:,1),residual(:,3))
plot(residual(:,1),residual(:,4),'r')
legend('Lift','Drag')
xlabel('Iteration Number')
ylabel('Force coefficient (Force/q)')

figure
colormap(jet)
trisurf(mesh.connec(:,1:3),mesh.xy(:,1),mesh.xy(:,2),results(:,2),'linestyle','none')
title('Normalised Density (rho/rho_{inf})');
colorbar
shading interp;
daspect([1 1 1])
view(2)

gamma=1.4;
figure
colormap(jet)
T_star=gamma*(results(:,5)-(results(:,3).^2+results(:,4).^2));
p_star=((gamma-1)/gamma)*results(:,2).*T_star;
p_norm=2.0*p_star;
trisurf(mesh.connec(:,1:3),mesh.xy(:,1),mesh.xy(:,2),p_norm,'linestyle','none')
title('Normalised Pressure (p/q_{inf})');
colorbar
shading interp;
daspect([1 1 1])
view(2)

figure

hold
quiver(mesh.xy(:,1),mesh.xy(:,2),results(:,3),results(:,4),0.1)
title('Velocity Vectors');
daspect([1 1 1])


end