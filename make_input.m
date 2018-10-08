function [input1] = make_input(xy,bound_data)
%MAKE_INPUT Takes coordinates and edge connectivity (bound_data) and
%produces input file for mesh generator


%First two columns of input are simply coordinates 

input1(:,1:2) = xy;

input1(:,3) = 0; %Set up for averaging

%Now loop around edges to find spacing

for i=1:length(bound_data)
    
    s = norm(xy(bound_data(i,1),:) - xy(bound_data(i,2),:));
    
    input1(bound_data(i,1),3) = input1(bound_data(i,1),3) + s;
    input1(bound_data(i,2),3) = input1(bound_data(i,2),3) + s;
end

input1(:,3) = input1(:,3)./2;
    

end

