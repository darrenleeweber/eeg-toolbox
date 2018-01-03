function savestr(text,file,opt);
%SAVESTR Save string as ascii into file. 
%	SAVESTR(TEXT,FILE,OPT) If opt not given 'w' is assumed. Works 
%	atleast with SUN4, SGI and PCWIN.
%
%SEE ALSO 
%	Loadstr.
%
%EXAMPLES
%	savestr(str2mat('Choose:','1) save','2) load','...'),...
%	'temp.hlp');
%	type temp.hlp

%	J.Virkkala  3-Aug-94
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

errorr
if nargin<3;opt='w';end;
	% character sets different in computer
if strcmp(computer,'PCWIN');cr=[13 10];else;cr=10;end
fid=fopen(file,opt);
if fid<=0,
  errorr('hff Cann''t save','savestr');
  return
end

	% going through rows
for i=1:size(text,1);
  fprintf(fid,'%s',[deblank(text(i,:)) ...
  setstr(cr)]);
end;
fclose(fid);

% END OF SAVESTR