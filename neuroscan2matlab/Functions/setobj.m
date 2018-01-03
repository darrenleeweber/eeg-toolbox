function setobj(what,ext);
%SETOBJ Set object properties.
%	SETOBJ(WHAT,EXT) Set object properties based on given parameter
%	what: keep) Keep the relative dimensions as same as in scren
%	for printing.
%
%DIAGNOSTICS
%	Used object properties PaperOrientation and PaperSize.
%
%EXAMPLES
%	setobj('keep');     % keep same scale as in screen
%	print datah\test -deps

%	J.Virkkala 22-May-95 For Reference documents.

if nargin<2,ext=[];else;ext=upper(ext);end
what=upper(what);
if strfind(what,'KEEP'),
  ss=get(0,'screensize');
  set(gcf,'paperorie','portrait');
  ps=get(gcf,'papersize');
  pr=ps(2)/ps(1);
  fs=get(gcf,'position');
  fr=fs(4)/fs(3);
  if fr>pr,
    r=0.95*1/ss(4)*ps(2);
  else
    r=0.95*1/ss(3)*ps(1);
  end;
  s=[fs(3)*r fs(4)*r];
  s=[(ps(1)-s(1))/2 (ps(2)-s(2))/2 s];
		% determine size, leave some margins
  set(gcf,'paperposition',s);		    
else
  disp('setobj  : Parameters not known');
end;       

% END OF SETOBJ