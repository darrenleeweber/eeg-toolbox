function [ EEGbase ] = eeg_baseline(EEGdata,pretrigger_samples)

% eeg_baseline - remove mean of pretrigger period from all EEG
%
% [ EEGbase ] = eeg_baseline(EEGdata,pretrigger_samples)
%
% It is assumed that EEGdata is an MxNxP matrix, with M data samples (ie,
% time), N channels and P epochs (P >= 1).
%

% $Revision: 1.1 $ $Date: 2004/11/11 21:02:01 $

% Copyright (C) 2004  Darren L. Weber
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

% Created: 10/2004, copyright 2004 Darren.Weber_at_radiology.ucsf.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


number_samples = size(EEGdata,1);

for epoch = 1:size(EEGdata,3),

    pretrigger_mean = mean(EEGdata(1:pretrigger_samples,:,epoch));

    pretrigger_mean = repmat(pretrigger_mean,number_samples,1);

    EEGbase(:,:,epoch) = EEGdata(:,:,epoch) - pretrigger_mean;

end

return
