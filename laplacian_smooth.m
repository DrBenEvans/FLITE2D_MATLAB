function [mesh_out] = laplacian_smooth(mesh_in,bound_data,NoSweeps, alpha)
%LAPLACIAN_SMOOTH Moves every point (which isn't a boundary) towards the
%centroid of it's neighbours 



%Find indices of points to smooth
IndVec = 1:length(mesh_in.xy);
BoundIndex = intersect(IndVec,bound_data(:,1));
FreeInd = setdiff(IndVec,BoundIndex);

%Loop over points and smooth
for n = 1:NoSweeps
    
    mesh_in = conelem(mesh_in);
   
    
    
    for i=1:length(FreeInd)
        [neighbours] = findlayer( mesh_in,FreeInd(i) );
        
        centroid(:,1) = mean(mesh_in.xy(neighbours,1));
        centroid(:,2) = mean(mesh_in.xy(neighbours,2));
        
        %Vector from point to centroid
        x_c = centroid - mesh_in.xy(FreeInd(i),:);
        
        mesh_in.xy(FreeInd(i),:) = mesh_in.xy(FreeInd(i),:) + alpha*x_c;
    end
    
end

mesh_out = mesh_in;
        
        
        
        
        


end

