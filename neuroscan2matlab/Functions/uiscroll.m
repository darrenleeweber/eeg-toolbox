function [h,limit,width]=uiscroll(limit,width,y,c);
%UISCROLL Add slide control to axes.
%	[H,LIMIT,WIDTH]=UISCROLL(LIMIT,WIDTH,Y,C) Add slide bar to current
%	axes at position y. Limit [low high] for xlim and width is length of
%	screen shown at one time. If not given they are derived from
%	current axes.
%
%	Parameter c is command which is executed everytime when view is
%	changed.
%
%DIAGNOSTICS
%	Uses axes xlim property.
%
%SEE ALSO
%	Scrollda, getband. Uses o2s.
%
%EXAMPLES
%	subplot(211);plot(randn(1,1024));
%	h=uiscroll([1 1024],10);        % to scroll data
%	print Help\uiscroll -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%       J.Virkkala 22-Jan-95
%       J.Virkkala  5-Mar-95 Part of ScanUtil.
%       J.Virkkala 20-May-95 Added parameter c to scroll data.

if nargin<4,c=[];end
if nargin<3,y=[];end
if nargin<2,width=[];end
if nargin<1,limit=[];end

if isempty(limit),
  limit=get(gca,'xlim');
end
if ~isempty(c);
  c=[ c ',' o2s(gca) ');'];
end
if isempty(y),       % y-position
  set(gca,'units','pixel');
  y=get(gca,'position');
  set(gca,'units','norm');
  y=y(2)-30;
end             % show in screen
if isempty(width),
  width=(limit(2)-limit(1))/10;
end
h=uicput('s                 sb1bb1bb123b',y);
%JVIR, value must be between limits
set(h(1),'min',limit(1),'value',limit(1),'max',limit(2)-width,'callback',...
    ['tmp' uicval(h(1)) 'set(' o2s(gca) ',''xlim'',[tmp tmp+'...
    o2s(width) ']);' c]);
set(h(2),'string','<','callback',['tmp=get(gca,''xlim'');tmp=tmp-'...    
	o2s(width) ';tmp2' uicval(h(1),'min')...
	'if tmp2>min(tmp),tmp=[tmp2 tmp2+' o2s(width) '];end,set('...
	o2s(gca) ',''xlim'',tmp);set(' o2s(h( 1)) ',''value'',tmp(1));' c]);
set(h(3),'string','>','callback',['tmp=get(gca,''xlim'');tmp=tmp+'...
	o2s(width) ';tmp2' uicval(h(1),'max') 'if tmp2<max(tmp),'...
	'tmp=[tmp2 tmp2+' o2s(width) '];end,set(gca'...
	',''xlim'',tmp);set(' o2s(h(1)) ',''value'',tmp(1));' c]);

set(h(4),'string','Hlp','callback','uihelp(''uiscroll.hlp'');');
%set(h(5),'string','Cls','callback','close');
set(gca,'xlim',[limit(1) limit(1)+width]);

%END OF UISCROLL
