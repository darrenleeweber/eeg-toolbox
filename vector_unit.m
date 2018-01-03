function vUnit = vector_unit(v,origin)

% vector_unit - computes the unit vector of a 3D Cartesian vector
% 
% vUnit = vector_unit(v,[origin])
%
% v - an Mx3 vector with M rows of (x,y,z) components
% 
% origin - the coordinate system origin, a 1x3 vector.
%          This argument is optional, the default is (0,0,0)
%
% vUnit  - Mx3 matrix of unit vectors for each row in v, ie:
%
% vUnit = v ./ [ sqrt( (x-xo).^2 + (y-yo).^2 + (z-zo).^2 ) ];
% 

% $Revision: 1.1 $ $Date: 2004/02/07 01:21:04 $

% Licence:  GNU GPL, no express or implied warranties
% History:    12/2003, Darren.Weber_at_radiology.ucsf.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('origin','var'), origin = [ 0, 0, 0 ]; end
if isempty(origin),        origin = [ 0, 0, 0 ]; end
end

if ~exist('v','var'), error('no input 3D Cartesian vector'); end
if isempty(v),        error('empty input 3D Cartesian vector'); end

Vx = v(:,1) - origin(1);
Vy = v(:,2) - origin(2);
Vz = v(:,3) - origin(3);

vUnit = v / sqrt( Vx.^2 + Vy.^2 + Vz.^2 );

return
