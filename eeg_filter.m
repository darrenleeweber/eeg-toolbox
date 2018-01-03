function EEGfiltered = eeg_filter(EEGinput,sample_freq,lcf,hcf,order);

% eeg_filter - apply a butterworth polynomial filter
% 
% 	Usage	: EEGfiltered = eeg_filter(EEGinput,sample_freq,lcf,hcf,order)
%
% 	- input arguments 
%		EEGinput : eeg data - N samples x M channels
%		sfreq : sampling frequency
%		lcf   : low cutoff frequency (highpass, default 0.01)
%		hcf	  : high cutoff frequency (lowpass, default 40)
%		order : butterworth polynomial order (default 2)
%
% 	- output argument
%		EEGfiltered : filtered EEGinput;
%
%  This function calls the butter function of the matlab signal processing
%  toolbox, using the bandpass option.
%

% $Revision: 1.2 $ $Date: 2004/11/11 21:00:32 $

% Licence: GNU GPL, no express or implied warranties
% Created: 05/2004, copyright 2004 Darren.Weber_at_radiology.ucsf.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('sample_freq','var') || isempty(sample_freq),
    error('no sample_freq defined');
end

% low cutoff frequency (default 2)
if ~exist('lcf','var') || isempty(lcf),
    lcf = 0.01;
end
% high cutoff frequency (default 20)
if ~exist('hcf','var') || isempty(hcf),
    hcf = 40;
end
% butter filter order (default 2)
if ~exist('order','var') || isempty(order),
    order = 2;
end

if hcf > (sample_freq/2),
    warning('hcf > sample_freq/2, setting hcf = sample_freq/2');
    hcf = sample_freq / 2;
end
if lcf <= 0 || lcf > (sample_freq/2) || lcf >= hcf,
    warning('lcf value is <=0 or >(sample_freq/2) or >=hcf, setting lcf = 2');
    lcf = 2;
end

% call the butter function of the signal processing toolbox
cf1 = lcf/(sample_freq/2);
cf2 = hcf/(sample_freq/2);
[B,A] = butter(order,[cf1 cf2]);

EEGfiltered = filtfilt(B,A,EEGinput);

return
