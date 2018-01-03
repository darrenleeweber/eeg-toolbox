function [S,Sn,St] = mesh_spacing(FV),

% This function implements Smith, S. (2002), Fast robust automated brain
% extraction.  Human Brain Mapping, 17: 143-155.  It corresponds to update
% component 1: within surface vertex spacing.

if isfield(FV,'edge'),
    if isempty(FV.edge),
        FV.edge = mesh_edges(FV);
    end
else
    FV.edge = mesh_edges(FV);
end

[normals,unit_normals] = mesh_vertex_normals(FV);

Nvertices = size(FV.vertices,1);

for index = 1:Nvertices,
    
    v = FV.vertices(index,:);
    x = FV.vertices(index,1);
    y = FV.vertices(index,2);
    z = FV.vertices(index,3);
    
    unit_normal = unit_normals(index,:);
    
    % Find neighbouring vertex coordinates
    vi = find(FV.edge(index,:));  % the indices
    neighbour_vertices = FV.vertices(vi,:);
    X = neighbour_vertices(:,1);
    Y = neighbour_vertices(:,2);
    Z = neighbour_vertices(:,3);
    
    % Find neighbour mean location; this is 'mean position of A and B' in
    % figure 4 of Smith (2002)
    Xmean = mean(X);
    Ymean = mean(Y);
    Zmean = mean(Z);
    
    % Find difference in distance between the vertex of interest and its
    % neighbours; this value is 's' and 'sn' in figure 4 of 
    % Smith (2002, eq. 1 to 4)
    s = [ Xmean - x, Ymean - y, Zmean - z]; % inward toward mean
    
    % Find the vector sn
    sn = dot( s, unit_normal ) * unit_normal;
    
    % Find the vector st
    st =  s - sn; % absolute value
    
    S(index,:) = s;
    Sn(index,:) = sn;
    St(index,:) = st;
    
end

return
