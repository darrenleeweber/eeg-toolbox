function uihelp(file);
%UIHELP Read ascii string and show it in help figure.
%	UICHELP(FILE) If file not found from path then uses file 
%	notfound.hlp to display error message or 'PATH ERROR...' if 
%	notfound.hlp not found. User only files with lower case.
%
%DIAGNOSTICS
%	Setscan should be run to set variables global and path should be
%	correct. Save button saves text into help file directory, don't
%	use if you don't have access.	
%	
%	Used global variables are UIHELP_FIG, UIHELP_TXT, UIHELP_FILE,
%	BORDERX and BORDERY.
%
%SEE ALSO
%	Uses loadstr, savestr, uicsetup.
%
%EXAMPLES
%	uihelp('default.hlp')
%	uihelp('notfound.hlp')
%	print Help\uihelp -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  4-Feb-1999 Replace newplot.
%JVIR,  3-Feb-1999 Horizontal aligment left.
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 15-Aug-94
%	J.Virkkala 21-Nov-94
%	J.Virkkala 10-Mar-95 Part of ScanUtil, disable plotting.
%	J.Virkkala 24-Apr-95 Saving into same directory.
%	J.Virkkala  2-May-95 Use of lower case, for IBM RS.

global UIHELP_FIG UIHELP_TXT UIHELP_FILE BORDERX BORDERY

	% test for existance
eval('get(UIHELP_FIG,''Parent'');','UIHELP_FIG=[];');
eval('get(UIHELP_TXT,''Parent'');','UIHELP_FIG=[];');

if nargin<1;file='';end;
file=lower(file);
%*** CREATE UIHELP FIGURE ***
if isempty(UIHELP_FIG);
  pos=get(0,'screensize');pos(1)=pos(3)-500-BORDERX;pos(2)=pos(4)-320-...
	3*BORDERY;  %JVIR, 420 replaced by 320
  pos(3)=500;pos(4)=200;
  UIHELP_FIG=creafig(pos);
  set(UIHELP_FIG,'numbertitle','off');
%JVIR,
  UIHELP_TXT=uicontrol('style','edit','position',[5 5 490 170],...
    'back',[1 1 1],'min',1,'max',10,'horizontala','left');
  hdl=uicput('/b12b    ',-20);
  set(hdl(1),'String','Save','callback',...
    'savestr(get(UIHELP_TXT,''string''),UIHELP_FILE);')
  set([UIHELP_TXT hdl],'units','normalized')
  h=uicsetup('uihelp.hlp',1);
%JVIR,   
  set(h(1),'visible','off');
  uihelp(file);
%JVIR, protected from close all  
  hidegui;  
else

%*** WHEN FIGURE EXIST ***
%JVIR, set(0,'currentfi',UIHELP_FIG);
  figure(UIHELP_FIG);
  if isempty(file);break;end;
  set(UIHELP_FIG,'name',['help file - ' file]);
	% if not found then saving is done to supposed name
  if exist(file),
    [txt p]=loadstr(file);
 else;
    p='';
    if exist('notfound.hlp');txt=loadstr('notfound.hlp');
	% notfound.hlp should always exist
    else;txt='PATH ERROR...';end;
  end;
  UIHELP_FILE=[p file];
  set(UIHELP_TXT,'string',txt);
end;
%JVIR
%set(gcf,'nextplot','new');		% disable plotting
  
%END OF UIHELP