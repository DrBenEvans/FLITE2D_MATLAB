function [dp] = getspace(psource,xy)
%GETSPACE calculates spacing based on point sources

%psource(:,1:2) = coordinates, psource(:,3) = d1 - spacing within radius xc, 
%psource(:,4) = D drop off of source outside of xc
%psource(:,5) = xc

[Ns,i] = size(psource);
i = [];
dpi = zeros(Ns,1);

for is = 1:Ns
    
    
    xys = psource(is,1:2);
    d1 = psource(is,3);
    D = psource(is,4);
    xc = psource(is,5);
    
    %Calculate distance from source
    x = norm(xy-xys);
    
    if le(x,xc)
        dpi(is,1) = d1;
    else
        dpi(is,1) = d1*exp(abs((x-xc)/(D-xc))*log(2));
    end
    
    
end

dp = min(dpi);


end

