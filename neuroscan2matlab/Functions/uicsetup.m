function [hdl]=uicsetup(file,style,string,extra);
%UICSETUP Setup basic uicontrols at the top of figure.
%	[HDL]=UICSETUP(FILE,STYLE,STRING,EXTRA) Setup uicontrols at the top
%	of figure for closing figure and to view help. File is filename for 
%	calling uichelp. Styles are following:
%
%	1) Cls and Hlp buttons, uses file for uihelp.
%	2) Cls, R0...R9 and Hlp buttons. 
%	3) Cls, F0...F9 and Hlp buttons, uses file for eval F.
%
%	If no parameters given [],2 is assumed and new figure opened for use 
%	with uicedit.
%
%DIAGNOSTICS
%	Used global is BRK.
%
%SEE ALSO
% 	Uses mutexc, uicput, uihelp.
%
%EXAMPLES
%	uicsetup                        % different controls
%	uicsetup('test.hlp',1);
%	uicsetup('macro.hlp',2);        % some other controls
%	h=uicsetup('test.hlp',2,'  ','s123sp123p')
%	print uicsetup -djpeg

%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  3-Feb-1999 Saving JPEG output.
%JVIR, 31-Jan-1999 Changes for Matlab 5.2, ~= by isempty

%	J.Virkkala 28-Jul-94
%	J.Virkkala 23-Feb-95 String and extra fields
%	J.Virkkala 16-May-95 Part of ScanUtil.

global BRK

BRK=0;
if nargin<1;file='';end;
if nargin<2;style=2;figure,end;
if nargin<3;string=[];end
if nargin<4;extra=[];end
	% Different styles
if style==1;
  if isempty(string)|sum(string=='p')==0,h=-20;else;h=-30;end
  hdl=uicput(['b12b/b12b' string],h);
  set(hdl(2),'string','Hlp','callback',['uihelp(''' file ''');']);
elseif style<4;
  row=['R0';'R1';'R2';'R3';'R4';'R5';'R6';'R7';'R8';'R9'];
  put='b12bb123b/p#pb12b';
  put=strrep(put,'#',blanks(round(3+1.5*size(string,2))));
  hdl=uicput([put extra],-30);
  set(hdl(2),'string','Brk','callback','BRK=1;'); 
if style<3,
	% evaluate R0..R8, which can be interrupted
  set(hdl(3),'string',row,'interrupti','yes');
  set(hdl(3),'callback',['BRK=0;showwait(''evaluating'');' ... 
    'evalstr(eval([''R'' int2str(get(' o2s(hdl(3)) ...
    ',''value'')-1)]));showwait('''')']);
elseif style<5;
	% evaluate FILES0..FILES8, which can be interrupted
  row=['F0';'F1';'F2';'F3';'F4';'F5';'F6';'F7';'F8';'F9'];
  set(hdl(3),'callback',['BRK=0;showwait(''evaluating'');' ... 
  'tmp' uicval(hdl(3)) ';eval([''' file ''' int2str(tmp-1)]);showwait('''')']);
  set(hdl(3),'string',row,'interruptible','yes');
else

end;
  set(hdl(4),'string','Hlp','callback',['uihelp(''' file ''');']);
end  
set(hdl(1),'string','Cls','callback','close');

%END OF UICSETUP