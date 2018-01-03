function [FV,C] = eeg_interp_sph_spline(Zi,Ei)

% eeg_interp_sph_spline - Spherical Spline Interpolation of Potential
%
% Useage: [FV,C] = eeg_interp_sph_spline(Zi,Ei)
%
% where:    Zi is an EEG/ERP measurement at time t from
%           electrode positions Ei = [X Y Z] on a scalp surface.  All
%           input arrays are the same size, assumed (Nelec x 1).
%           The origin of Ei = [X Y Z] is assumed (0,0,0).
%
% FV => interpolated spherical surface (see sphere_tri)
%
% FV.faces    => triangulation of FV.vertices 
% FV.vertices => cartesian coordinates (Nx3)
% FV.Cdata    => spherical spline potential at FV.vertices
% 
% C => interpolation coefficients of Ei (includes co = C(1))
% 
% Notes:    This function calculates the spherical spline of 
%           Perrin et al (1989).  Electroenceph. & Clin. 
%             Neurophysiology, 72: 184-187. Corrigenda (1990),
%             Electroenceph. & Clin. Neurophysiology, 76: 565.
%             (see comments in the .m file for details).

% $Revision: 1.9 $ $Date: 2004/04/16 18:49:10 $

% Licence:  GNU GPL, no implied or express warranties
% History:  08/2001 Darren.Weber_at_radiology.ucsf.edu, with
%                   mathematical advice from
%                   Dr. Murk Bottema (Flinders University of SA)
%           10/2003 Darren.Weber_at_radiology.ucsf.edu, with
%                   mathematical advice and LegendreP function from 
%                   Dr. Tom.Ferree_at_radiology.ucsf.edu
%                   revised, tested & initial verification complete
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[C,r] = eeg_interp_sph_spline_c(Zi,Ei);

Co = C(1);
Ci = C(2:end);

eegversion = '$Revision: 1.9 $';
fprintf('EEG_INTERP_SPH_SPLINE [v %s]\n',eegversion(11:15)); tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now that Ci is solved, we can obtain interpolated potentials at Ej (Eq. 1)
% U(Ej) = c(0) + ( for i=1:n, sum = (sum + (c(i) * g(cos(Ei,Ej)))) )
% U(Ej) = c(0) + sum( Ci * g(x) )

% create spherical interpolation positions
fprintf('...generating spherical interpolation points\n');
FV = sphere_tri('ico',4,r);

% cosines between measurement electrodes and interpolation points
Cos = elec_cosines(Ei,FV.vertices);

% Calculate g(x)
Gx = eeg_interp_sph_spline_g(Cos);  % nElectrodes x NinterpolationPoints

% Solve Eq 1. (where FV.Cdata = U)
FV.Cdata = Co + ( Ci' * Gx );

t=toc; fprintf('...done (%6.2f sec)\n',t);

return
