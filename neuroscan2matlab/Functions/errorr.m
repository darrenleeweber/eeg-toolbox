function errorr(typ,cal);
%ERRORR Error response.
%	ERRORR(TYP,CAL) Displays figure for error message. Typ is 
%	extension for errorr ascii file. Last characters of typ and
%	cal is shown in figure's name. Used extensions are: hff) File not 
%	found or couldn't be created, hpw) Parameter wrong given or
%	wrong type. hfe) Fatal error or rare error.
%
%	If without parameters global variables existance is tested and
%	note given if they are missing.
%
%SEE ALSO
%	Uses uihelp.
%
%EXAMPLES
%	errorr('hff setup.txt not found','loadstr.m');  % hff file not found
%	errorr('hpw n was too large','cal.m');    % hpw parameter wrong 

%Mention source when using or modifying these freeware tools
%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  7-Feb-1999 Corrected for new uihelp, removed uppercase.
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 18-May-95 Add error handling for utilities.

global BRK UIHELP_FIG

if nargin==0,
  if ~exist('BRK');
    home
    disp('  ERRORR  : Global variables lost. Use startup to restore.');
    pause
    break
  end
else
  if nargin<2,
    cal='ERRORR';
 end
%JVIR, Added display 
  disp(['error    : ' cal ', type: ' typ]);
  uihelp(['errorr.' typ(1:3)]);
  set(UIHELP_FIG,'name',([cal ' - ' typ(4:length(typ))]));
end

%END OF ERRORR