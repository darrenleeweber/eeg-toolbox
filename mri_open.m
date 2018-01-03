function [p] = mri_open(p)

% mri_open - function to call various mri data tools
%
% Usage: [p] = mri_open(p)
%
% p is a parameter structure (see eeg_toolbox_defaults for
% more details). In this function, it should contain at least
% the following string fields:
%       
%       p.mri.path - the directory location of the file to load
%       p.mri.file - the name of the file to load
%       p.mri.type - the file format (Analyze, FreeSurfer)
%       
%       Analyze is documented in AVW_*_READ
%       FreeSurfer: http://surfer.nmr.mgh.harvard.edu/
%       
% The return structure creates or updates p.mri.data, which contains:
%       
%       p.mri.data.hdr     struct, eg see avw_hdr_read
%       p.mri.data.img     3D matrix of image values
%       
% To plot the data returned, set p.mri.plot = 1 before loading, or use:
%       
%       avw_view(p.mri.data)
%       
% See also, avw_img_read, cor_img_read, avw_view
% 

% $Revision: 1.9 $ $Date: 2004/04/16 18:49:11 $

% Licence:  GNU GPL, no express or implied warranties
% History:  08/2002, Darren.Weber_at_radiology.ucsf.edu
%           11/2002, Darren.Weber_at_radiology.ucsf.edu
%                    corrected some bugs and mistakes on p.mri.type
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

version = '$Revision: 1.9 $';
fprintf('MRI_OPEN [v %s]\n',version(11:15));

if ~exist('p','var'),
   [p] = eeg_toolbox_defaults;
    fprintf('...creating default p structure.\n');
elseif isempty(p),
   [p] = eeg_toolbox_defaults;
    fprintf('...creating default p structure.\n');
end

type = lower(p.mri.type);

switch type,

case 'analyze',
	
    [path,name,ext] = fileparts(strcat(p.mri.path,filesep,p.mri.file));
    file = fullfile(path,[name ext]);
    
    fprintf('...loading Analyze MRI from:\n... %s\n\n',file);
    
    % see avw_img_read for details about orientation
    switch p.mri.orient
    case 'auto',                mriOrient = '';
    case 'axial unflipped',     mriOrient = 0;
    case 'coronal unflipped',   mriOrient = 1;
    case 'sagittal unflipped',  mriOrient = 2;
    case 'axial flipped',       mriOrient = 3;
    case 'coronal flipped',     mriOrient = 4;
    case 'sagittal flipped',    mriOrient = 5;
    otherwise,                  mriOrient = '';
    end
    
    [ p.mri.data, p.mri.IEEEMachine ] = avw_img_read(file, mriOrient, p.mri.IEEEMachine);
	
case 'brainstorm',
    
    fprintf('...BrainStorm not supported yet\n\n');
    return
    %fprintf('...loading BrainStorm data from:\n... %s\n',file);
    
case {'cor','freesurfer'},
	
    % Get Freesurfer data
    [path,name,ext] = fileparts(strcat(p.mri.path,filesep,p.mri.file));
    file = fullfile(path,[name ext]);
    
    [ p.mri.data, p.mri.IEEEMachine ] = cor_img_read(path, p.mri.IEEEMachine);
    
otherwise,
    fprintf('...MRI format: %s\n', p.mri.type);
    fprintf('...Sorry, cannot load this data format at present.\n\n');
    return;
end

if p.mri.plot, avw_view(p.mri.data); end

return
