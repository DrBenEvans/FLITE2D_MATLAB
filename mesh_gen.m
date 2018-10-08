function [mesh] = mesh_gen( xy , bound_data, alpha, psource)
%MESH_GEN Generates a mesh based on spacing only
%   input(:,1) = x ordinates
%   input(:,2) = y ordinates
%   input(:,3) = spacing
%   bound_data = connectivity of boundary data
%   no_bound = number of boundary points, other points in input are
%   background spacing


input = make_input(xy,bound_data);

no_bound = length(bound_data);

bound_data = bound_data(:,1:2);

mesh.xy = input(1:no_bound,1:2);
dt = DelaunayTri(mesh.xy(:,1),mesh.xy(:,2),bound_data);
IO = inOutStatus(dt);
mesh.connec = dt(IO,:);

S = TriScatteredInterp(input(:,1),input(:,2),input(:,3));  %Spacing

flag = 1;

%Place points according to spacing

while eq(flag,1)
    
    
    %Plot mesh
    clf
    triplot(mesh.connec,mesh.xy(:,1),mesh.xy(:,2))
    daspect([1 1 1])
    drawnow
    
    ip = length(mesh.xy); %Counter to help insert points
    oldnp = ip;
    
    flag1 = 0;
    
    
    
    for ie = 1:length(mesh.connec)
        
        
        %Calculate centroid   
        x1 = mesh.xy(mesh.connec(ie,1),1);
        y1 = mesh.xy(mesh.connec(ie,1),2);
        x2 = mesh.xy(mesh.connec(ie,2),1);
        y2 = mesh.xy(mesh.connec(ie,2),2);
        x3 = mesh.xy(mesh.connec(ie,3),1);
        y3 = mesh.xy(mesh.connec(ie,3),2);
   
        xx(1,1) = (x1+x2+x3)/(3);
        xx(1,2) = (y1+y2+y3)/(3);
    
        %Calculate actual spacing if point was to be inserted
        si = min([norm(xx-mesh.xy(mesh.connec(ie,1),:)) ; norm(xx-mesh.xy(mesh.connec(ie,2),:)) ; norm(xx-mesh.xy(mesh.connec(ie,3),:))]);
        
        %Check spacing to other added points
        if gt(ip-oldnp,0)
            
            for ii=1:(ip-oldnp)
               
                si = min([si ; norm(xx-mesh.xy(oldnp+ii,:))]);
                
            end
            
        end
        
        %Calculate ideal spacing
        if isempty(psource)
            is = S(xx(1,1),xx(1,2));
        else
            is = min([S(xx(1,1),xx(1,2));getspace(psource,xx)]);
        end
        ds = (si-is);
        
        
        if ge(ds,0-(alpha*si))
            %Add point 
            ip = ip+1;     
            mesh.xy(ip,:) = xx;
            flag1 = 1;

        end
        
        
    end    
    dt = DelaunayTri(mesh.xy(:,1),mesh.xy(:,2),bound_data);
    IO = inOutStatus(dt);
    mesh.connec = dt(IO,:);
    mesh = conelem(mesh);
    [mesh] = laplacian_smooth(mesh,bound_data,1,1.0);
    dt = DelaunayTri(mesh.xy(:,1),mesh.xy(:,2),bound_data);
    IO = inOutStatus(dt);
    mesh.connec = dt(IO,:);
    mesh = conelem(mesh);
    flag = flag1;  
end

dt = DelaunayTri(mesh.xy(:,1),mesh.xy(:,2),bound_data);
IO = inOutStatus(dt);
mesh.connec = dt(IO,:);
mesh = conelem(mesh);

[mesh] = laplacian_smooth(mesh,bound_data,5,0.75);




end

