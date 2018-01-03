function [X,Y,Z] = elec_cm2m(X,Y,Z)

% elec_cm2m - Convert electrode coordinates from centimeters to meters
%
%   [X,Y,Z] = elec_cm2m(X,Y,Z)
%
%   Simply:  X = X / 100;  Y = Y / 100;  Z = Z / 100;
%

% $Revision: 1.9 $ $Date: 2004/03/29 21:15:20 $

% Licence:  GNU GPL, no implied or express warranties
% History:  07/2001, Darren.Weber_at_radiology.ucsf.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    X = X / 100;  Y = Y / 100;  Z = Z / 100;
