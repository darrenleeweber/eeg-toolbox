function claa(x0,x1,y0,y1);
%CLAA Clear figure's axes inside normalized box.
%	CLAA(X0,X1,Y0,Y1) Clear axes, unit normalized which begin 
%	inside box defined by [x0,x1,y0,y1].
%
%DIAGNOSTICS
%	With subplot some objects in corners are left. With clf also
%	uicontrols deleted.
%
%SEE ALSO
%	Cla, clf.
%
%EXAMPLES
%	claa;        % all axes, not handles
%	subplot(221);subplot(224);
%	claa(0,0.5); % left half

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala  1-Aug-94
%	J.Virkkala  6-Mar-95 Part of ScanUtil.

	% if parameters not given
if nargin<4;
  y0=0;y1=1;
  if nargin<2;
    x0=0;x1=1;
  end
end;
	% clear axes with start in area x0,x1,y1,y0
hdl=get(gcf,'children')
for i=1:size(hdl,1);
  if strcmp(get(hdl(i),'type'),'axes');
    pos=get(hdl(i),'position');
    x=pos(1);
    y=pos(2);
%JVIR, replace close with delete    
    if x>=x0&x<x1&y>=y0&y<y1;delete(hdl(i));end;
  end;
end;

%END OF CLAA