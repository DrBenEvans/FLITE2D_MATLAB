function [ mesh ] = conelem( mesh )
%CONELEM This function builds data structure containing the elements
%connected to each nodal point

%Some definitions 

NoPoints = length(mesh.xy);
NoElem = length(mesh.connec);



%Check order of connec
i=1;
tri = mesh.connec;
xy = mesh.xy;

while (i <= NoElem)
  
              
        xy12 = xy(tri(i,1),:) - xy(tri(i,2),:);
        xy32 = -1*xy(tri(i,2),:) + xy(tri(i,3),:) ;
        te = xy32(1,1)*xy12(1,2) - xy32(1,2)*xy12(1,1);
               
        if lt(te,0)
            n2 = tri(i,2);
            n3 = tri(i,3);
            tri(i,2) = n3;
            tri(i,3) = n2;
            i = 1;
        else
            
            i=i+1;
            
        end       
end

mesh.connec = tri;



lhowm = zeros(NoPoints,1); %Vector to hold the number of elements of each point

%1. Fill in lhowm

for ie = 1:NoElem
    for in = 1:3,
        
       %Index of current nodal point in xy
       ip = mesh.connec(ie,in);
       
       lhowm(ip) = lhowm(ip) + 1;
    end
end

lwhere = zeros(NoPoints,1); %Tells us where in the conelem vector the elements connected to nodal point start

%2. Fill in lwhere

for ip = 2:NoPoints
    lwhere(ip) = lwhere(ip-1) + lhowm(ip-1);
end

ConElemN = sum(lhowm); %Size of vector conelem
conelem = zeros(ConElemN,1);

lhowm = zeros(NoPoints,1); %Set to zero to help in following loop

%3. Fill in conelem
for ie=1:NoElem,
    for in=1:3,
        
        
        ip = mesh.connec(ie,in);
        lhowm(ip) = lhowm(ip) + 1;
        
        %Put current element number in vector
        j = lwhere(ip)+lhowm(ip);
        conelem(j,1) = ie; 
    end
end


%4. Build side data structure

iloca = 0;

for ip=1:NoPoints
    
    iloc1 = iloca;
    iele = lhowm(ip);
    
    if gt(iele,0)
        
        %initialise
        for is = 1:iele+2
            iside(is+iloc1,3) = 0;
            iside(is+iloc1,4) = 0;
        end
        
        iwhere = lwhere(ip);
        ip1 = ip;
        
        for iel = 1:iele  %Loop through each connected elements
            
            ie = conelem(iwhere+iel);
        
            %Find position of ip (1,2,3) in connec
            flag = -1;
            in = 0;
            while flag<0
                in = in+1;
                ipt = mesh.connec(ie,in);
                
                if eq(ipt,ip)
                    in1=in; 
                    flag = 10;     
                end
                
            end
            
            for j=1:2
                in2 = in1+j;
                
                if gt(in2,3)
                    in2 = in2-3;
                end
                
                ip2 = mesh.connec(ie,in2);
                
                if not(lt(ip2,ip1))
                    
                
                
                    if not(eq(iloca,iloc1))
                        for is=(iloc1+1):iloca
                            jloca = is;
                        
                            if eq(iside(is,2),ip2)
                                %old side
                                iside(jloca,2+j)=ie;
                            end
                        
                        end
                        
                    else
                        %New side
                        iloca = iloca+1;
                        iside(iloca,1) = ip1;
                        iside(iloca,2) = ip2;
                        iside(iloca,2+j) = ie;
                    end
                end
            end
        end
        
        %Loop over elements surrounding point ip
        for is=(iloc1+1):iloca
            if eq(iside(is,3),0)
                iside(is,3) = iside(is,4);
                iside(is,4) = 0;
                iside(is,1) = iside(is,2);
                iside(is,2) = ip1;
            end
        end              
        
    end
    
end

%5. Build element connectivity matrix intmel

nside = length(iside);

for is = 1:nside
    ip1 = iside(is,1);
    ie1 = iside(is,3);
    ie2 = iside(is,4);
    
    %First ie1
    if not(eq(ie1,0))
        i1 = mesh.connec(ie1,1);
        i2 = mesh.connec(ie1,2);
        i3 = mesh.connec(ie1,3);
    
        if eq(ip1,i1)
            ipos=3;
        elseif eq(ip1,i2)
            ipos=1;
        elseif eq(ip1,i3)
            ipos=2;
        end
    
        intmel(ie1,ipos)=ie2;
    end
    
    %Now ie2 only if ie2.ne.0
    if not(eq(ie2,0))
        i1 = mesh.connec(ie2,1);
        i2 = mesh.connec(ie2,2);
        i3 = mesh.connec(ie2,3);
        
        if eq(ip1,i1)
            ipos=3;
        elseif eq(ip1,i2)
            ipos=1;
        elseif eq(ip1,i3)
            ipos=2;
        end
        
        intmel(ie2,ipos)=ie1;
    end
end
        
        



%Put vectors in structure for output
mesh.lhowm = lhowm;
mesh.lwhere = lwhere;
mesh.conelem = conelem;
mesh.iside = iside;
mesh.intmel = intmel;

end

