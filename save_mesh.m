function [] = save_mesh(mesh,filename,bound_data)
%SAVE_MESH 
%   Formatted for flite preprocessor

if exist(filename, 'file')==2
  delete(filename);
end







%Header

H = 1;

dlmwrite(filename,H,'delimiter','\t','-append');

hdr = {'title'};
txt = sprintf('%s',hdr{:});
dlmwrite(filename,txt,'-append','delimiter','');


ne = length(mesh.connec);
np = length(mesh.xy);
nb = length(bound_data);

hdr = {'ne','np','nb'};
txt = sprintf('%s\t',hdr{:});
dlmwrite(filename,txt,'-append','delimiter','', 'newline', 'unix');

H = [ne np nb];
dlmwrite(filename,H,'delimiter','\t','-append', 'newline', 'unix', 'precision', '%11d');

hdr = {'connectivities'};
txt = sprintf('%s',hdr{:});
dlmwrite(filename,txt,'-append','delimiter','', 'newline', 'unix');

H(1:ne,1) = 1:ne;
H(:,2:4) = mesh.connec(:,1:3);
H(:,5) = 1;
dlmwrite(filename,H,'delimiter','\t','-append', 'newline', 'unix','precision', '%11d');

hdr = {'coordinates'};
txt = sprintf('%s',hdr{:});
dlmwrite(filename,txt,'-append','delimiter','', 'newline', 'unix');

I(1:np,1) = 1:np;
I(:,2:3) = mesh.xy(:,1:2);
dlmwrite(filename,I,'delimiter','\t','-append', 'newline', 'unix');



hdr = {'boundaries'};
txt = sprintf('%s',hdr{:});
dlmwrite(filename,txt,'-append','delimiter','', 'newline', 'unix');
dlmwrite(filename,bound_data,'delimiter','\t','-append', 'newline', 'unix','precision', '%11d');





end

