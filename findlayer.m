function [ ilayer ] = findlayer( mesh,ilayer1 )
%FINDLAYER Uses edge based structure to generate a layer of elements
%connected to the nodes in ilayer1
%   ilayer1 are the indices from the last layer

%Find number of elements in layer 
ilayer1howm = zeros(length(ilayer1),1);

for i=1:length(ilayer1)
    %Number of elements around point i
    ilayer1howm(i) = mesh.lhowm(ilayer1(i));
end

%Calculate total number of nodes in the next layer (counting nodes from previous
%layer which will be removed) then allocate vector

ilayerall = zeros(sum(ilayer1howm)*3,1);

%Fill vector with node indices
k = 0; %Counter to aid indexing

for i=1:length(ilayer1)   
    
    for ii=1:ilayer1howm(i)
        
        Where = mesh.lwhere(ilayer1(i))+ii;
        Elem = mesh.conelem(Where);
        
        for j=1:3
            
            k=k+1;
            ilayerall(k) = mesh.connec(Elem,j);
            
        end
    end
end

%Eliminate multiple entries for same node and nodes from ilayer1

ilayer = unique(setdiff(ilayerall,ilayer1));


end

