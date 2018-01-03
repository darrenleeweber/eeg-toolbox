function [sumD] = mesh_fit_elec_optim(SUMD,scalp,elec)

% mesh_fit_elec_optim - optimise the fitting of electrodes to scalp vertices
%
% This function is in development.  It needs rotations and 
% translations of elec vertices to fit those of the scalp 
% vertices and a minimisation function for the difference 
% between the vertex locations of the nearest scalp vertices 
% and those of the electrodes.

% $Revision: 1.8 $ $Date: 2004/03/29 21:15:36 $

% Licence:  GNU GPL, no implied or express warranties
% History:  09/2002, Darren.Weber_at_radiology.ucsf.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Still in development\n'); return


% Rotations/translations/scaling here???

[k,d] = dsearchn(scalp,elec);

sumD = sum(d) - SUMD;

return
