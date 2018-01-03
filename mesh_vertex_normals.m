function [vertNormals,vertNormalsUnit] = mesh_vertex_normals(FV)

% mesh_vertex_normals - Calculate vertex surface normals
% 
% [normals,unit_normals] = mesh_vertex_normals(FV)
% 
% FV.vertices   - vertices of mesh, Nx3 Cartesian XYZ
% FV.faces      - triangulation of vertices (Mx3 matrix)
% 
% normals       - vertex surface normals (Nx3 matrix)
% unit_normals  - normalized normals!
%
% This routine first calculates the surface normals of each face.  It then
% finds all the faces that contain a specific vertex and sums across
% the face normals (weighted by the face area).  
%
% If the faces are defined
% according to the right-hand rule, all their normals will be "outward"
% normals and the average should be a sensible value for the vertex normal.
%
% See also the VertexNormals property of the patch and surface commands.
%

% $Revision: 1.2 $ $Date: 2004/07/26 17:04:32 $

% 
% Licence:  GNU GPL, no implied or express warranties
% History:  04/2004, Darren.Weber_at_radiology.ucsf.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tic;
fprintf('...calculating vertex surface normals...');

nvert = size(FV.vertices,1);

vertNormals = zeros(nvert,3);
vertNormalsUnit = vertNormals;

for v = 1:nvert,
    
    % To calculate a vertex normal you need to perform an iteration
    % beginning with a triangle that holds the vertex and perform a cross
    % product on the two vectors of that triangle that extend from that
    % vertex. This will result in a normal for that triangle. Then go
    % around to each triangle containing that vertex and perform a cross
    % product for that triangle. You will end up with a set of normals for
    % all the triangles. To compute the vertex normal, sum all the face
    % normal vectors.
    
    % get all the faces that contain this vertex
    [faceIndexI,faceIndexJ] = find(FV.faces == v);
    
    nface = length(faceIndexI);
    
    faceNormals = zeros(nface,3);
    
    for face = 1:nface,
        
        f = faceIndexI(face);
        
        vertex_index1 = FV.faces(f,1);
        vertex_index2 = FV.faces(f,2);
        vertex_index3 = FV.faces(f,3);
        
        vertex1 = FV.vertices(vertex_index1,:);
        vertex2 = FV.vertices(vertex_index2,:);
        vertex3 = FV.vertices(vertex_index3,:);
        
        % If the vertices are given in clockwise order, when viewed from the
        % outside, then following calculates the "outward" surface normals.
        
        edge_vector1 = vertex2 - vertex1;
        edge_vector2 = vertex3 - vertex1;
        
        faceNormals(face,:) = cross( edge_vector2, edge_vector1 );
        
        
    end
    
    %faceNormalsMagnitude = vector_magnitude(faceNormals);
    %faceNormalsUnit = faceNormals ./ repmat(faceNormalsMagnitude,1,3);
    
    % Area of Triangle = || AB x AC|| / 2 ; ie, the absolute value of
    % the length of the cross product of AB and AC divided by 2
    %faceArea = faceNormalsMagnitude / 2;
    
    % Weight the faceNormals by the faceArea
    %vertNormals(v,:) = sum( faceNormals .* repmat(faceArea,1,3) ) / sum( faceArea );
    
    vertNormals(v,:) = sum(faceNormals) / nface;
    
    vertNormalsMagnitude = vector_magnitude(vertNormals(v,:));
    vertNormalsUnit(v,:) = vertNormals(v,:) / vertNormalsMagnitude;
    
end

t=toc;
fprintf('done (%5.2f sec).\n',t);

return
