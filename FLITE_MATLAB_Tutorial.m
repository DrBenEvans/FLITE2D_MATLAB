%The folder contains a number of MATLAB functions and scripts to help use
%the 2D FLITE solver.  It is suggested you work through this simple example
%before trying your own problems.  

%The MATLAB functions provided will generate all the files needed for the
%solver.  In each example the set
%of commands you need to run can be executed by right clicking and choosing
%'Run this cell'


%In the following example all the default options will be used to generate
%a mesh around a NACA 0012 and simulate inviscid flow past it.

%STEP 1 - MESH GENERATION

%A very simple Delaunay refinement type mesh generator is included in this
%package, along with a simple cosmetics function.  First load in the
%NACA0012 geometry

%%
load('naca.mat')

%%
%There are now three variables in the workspace.  xy, psource and
%bound_data.  The variables xy and bound_data define our geometry, lets
%plot them...
figure
scatter(xy(:,1),xy(:,2))
daspect([1 1 1])

%%
%The NACA is sat in the center of a circular far field.  The solver needs
%to know which points represent the boundary and which represent the
%farfield.  bound_data supplies this information, lets have a look at it's
%format
bound_data 

%%
%Columns 1 and 2 give indexs of points in xy, and the third column is a
%boundary flag which tells the solver what the edge in that row is.
%The flags can take the following values:
% 1: inviscid wall
%  2: symmetry surface
%  3-4: far field (can have two different)
%  5: isothermal viscous wall
%  6: adiabatic viscous wall  
%  7: internal outflow 

%You can see in the bound_data array we have an inviscid wall in the first
%174 rows, lets plot that
figure
scatter(xy(1:174,1),xy(1:174,2))
daspect([1 1 1])


%%
%Now we have the geometry ready we need to generate the mesh. As well as
%the boundary coordinates and flags the mesh generator requires information
%about the spacing we want.  This information is given using the array
%psource.  When the mesh is generated each point in space has a target
%element size, this is given by a spacing function.  The spacing function
%is getspace.m, it's worth spending some time looking at how this function
%works.  The rows in psource define point sources of specified spacings 
%defined as follows...  

%psource(:,1:2) = xy-coordinates of the center of the source 
%psource(:,3) = a specified spacing (distance between points) which is constant inside a radius Xc 
%psource(:,4) = effects how quickly the effect of this source drops off
%after Xc
%psource(:,5) = Xc

%The best way to understand these sources is to have a play changing some
%of them - when you start making your own meshes you will need to do this.
%There is also the parameter alpha (which is set to 0.8 below) which
%controls how close to the target spacing we need to be to refine an
%element.  Again this is something you need to play with to get a feel.
%Lets generate the mesh with default values...

[mesh] = mesh_gen( xy , bound_data, 0.8, psource) %#ok<*NOPTS>

%%
%The variable mesh now contains our mesh.  This is a structure containing
%the coordinates, mesh.xy, and the connectivity matrix of those
%coordinates, mesh.connec.  In the future you may wish to use your own mesh
%generation methods, in which case you will need to save the mesh in this
%structure and build a bound_data matrix as described above.

%If you wish to improve the quality of the mesh the function
%laplacian_smooth.m lets you do this.  You must tell it how many sweeps you
%want and how far to move the points each iteration, here we are doing 5
%loops moving the points 75% the distance towards the centroid of their
%neighbouring points.  After the smoothing finishes the function plot_mesh
%is used to plot the mesh.

[mesh] = laplacian_smooth(mesh,bound_data,5, 0.75)
plot_mesh( mesh )


%%
%STEP 2 - PREPROCESSING
%We now need to save the mesh and run the preprocessor

%Save the mesh with the function
save_mesh(mesh,'mesh.dat',bound_data)

%Run the Preprocessor:
system('PrePro.exe < runPrePro.inp')

%%
%STEP 3 - SOLVING
%The solver requires both a mesh and an input file to control the
%simulation.  The file solver.inp is the input file which we will need to
%inspect, right click it and open as text.  Most of the variables here
%won't need to be changed, a file solverDefault.inp is included which has a
%set of values which work on most problems.  The only thing to change now
%is the numberOfGridsToUse on line 3, we generated 5 grids so lets change
%that from 1 to 5.  

%Line 2 numberOfMGIterations is an important variable.  This determines how
%long the solver will run.  If the number is positive that is how many
%iterations will be performed.  If the number is negative then the solver
%will continue to run until the system has converged to that many orders of
%magnitude.  Currently it is set to 3 orders of magnitude. Warning: not all
%systems will converge in which case the solver will run forever!

%Line 8 sets the angle of attack, currently zero, and line 9 sets the Mach
%Number which is currently 0.5.

%The Reynolds Number is set on line 11, setting it to zero tells the solver
%that we are running invisicid.

%Save the input file and lets run the solver.  Right click Solver.exe and
%Run outside MATLAB.  The control filename is solver.inp (the file we just
%edited), comoutation filename is the mesh.sol file.  Startup filename is a
%results file we have already computed, we usually don't have this so just
%push enter.  Results filename is the file to save the results in, lets
%call it solverout.res, and the residual filename contains the residual,
%solverout.rsd.  

%Once the residual reaches 3 it will stop.
system('Solver.exe < runSolver.inp')

%%
%Once the solver has finished we simply need to run the function
%import_FLITE_data to plot the results and put them into the workspace.  To
%do this we still need the mesh we made earlier in the workspace as well.
[results, residual] = import_FLITE_data('solverout.rsd','solverout.res',mesh);

%The residual and Lift Drag plots show how the values changed during the
%simulation.  You should see the values converge.  

%%
%Now try and re-run the simulation at Mach 0.75 and angle of attack 15 degrees.
%You will need to edit the solver.inp file, but you won't need to
%regenerate the mesh.  

%The solution takes quite a bit longer to converge, plot the results when
%you are finished.

%%
%Now lets make things even more interesting and turn on viscosity.  There
%are a number of things we need to do...

%1) Change the boundary flag on the NACA from 1 to 5
%bound_data(1:174,3) = 5

%2) Save the mesh with the new boundary data
%save_mesh(mesh,'mesh.dat',bound_data)

%3) Re-run the preprocessor as described above

%4) Set the Reynolds number in the solver.inp file to 400000.0 and decrease
%the angle of attack to 5 degrees.  You will need a better mesh to do
%anything higher.

%Once the solver completes have a close look at the velocity field.

%%
%Now you should have enough information to run simulations with your own
%geometries, generating your own meshes.  
















