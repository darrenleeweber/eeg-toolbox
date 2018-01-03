function [selected,hdl]=selelec(ELE,num);
%SELELEC Select EEG electrodes from scalp.
%	[SELECETED,HDL]=SELELEC(ELE,NUM) Checkbuttons for selecting EEG 
%	electrodes. Calling with two parameters creates figure with buttons in
%	ELE and callbacks to return selected text to variable S[num]. Scalp
%	figure is created with pos1020. 
%
%	With eke=[] sets figures buttons on and with no parameters returns 
%	which buttons are on. There are buttons for help, for file S[num] and
%	for selecting all on or off.
%
%SEE ALSO
%	Uses uicsetup, pos1020. See also seltext.
%
%EXAMPLES
%	[x1,y1,l1]=loadcnt('eyes-closed.cnt','',1,1000);
%	h1=selelec(l1,1);S1=selelec('',1:5); % plotting data
%	run=['showwait(''wait...'');figure(pf);clf,plotdata(x1,y1(S1,:),'...
%	  'l1(S1,:));showwait([])'];
%	set(gcf,'windowbuttonupfcn',run);    % press at S1 background
%	print Help\selelec -djpeg
%	figure;
%	uicsetup('selelec.hlp',1);
%	title('Channels S1, Range S2 in f1');
%	pf=gcf;
%	eval(run);                           % continue in seltext

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  7-Feb-1999 Added printing
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%     J.Virkkala  1-Aug-94     
%		J.Virkkala 10-Jan-95
%		J.Virkkala  6-Mar-95 Part of ScanUtil

global BORDERX BORDERB
if nargin==0;ELE='';end;

%*** CALLING ITSELF ***
if size(ELE)==[0 0];
  chan=get(gcf,'userdata');
  chan=chan(:);
%JVIR, all variables must be defined
  selected=[];
  for i=1:size(chan,1);
	% to set checkbuttons or to read what are pressed
    if nargin==2;
       %     selected=num;
    	if ~isempty(num),
      	if find(i==num);set(chan(i),'value',1);selected=[selected i];
    	end
	 else;set(chan(i),'value',0);
    	end;
    elseif get(chan(i),'value');selected=[selected i];end;
  end;
  hdl=gcf;
else

%*** CREATING FIGURE ***
	% in how many rows
  pos=get(0,'screensize');
  pos(1)=pos(3)-125*num-75-BORDERX;pos(2)=BORDERB;%JVIR, -200 changed into -100
  pos(3)=200;pos(4)=200;
  fig=creafig(pos);
  set(fig,'numbert','off','menub','none',...
    'name',['S' int2str(num)],'resize','off')
  set(gca,'pos',[0 0 1 1],'visible','off','xlim',[-1 1],'ylim',[-1 1]);
  [xy,ELE]=pos1020(ELE,0,1,'.',1);
  hold on;
  n=size(ELE,1);
  for i=1:n;
    hdl(i)=uicontrol('style','check','units','norm','posi',...
    [(xy(i,1)+0.87)/2 (xy(i,2)+0.93)/2 0.05 0.05]);
  end;
	% Close buttons
  h=uicput('b12b/p1234p',-35);
  set(h(1),'string','Cls','callback','close;');
	% callback
  set(h(2),'string','On|Off|Hlp','callback',['tmp' uicval(h(2)) ...
    'if tmp==3;uihelp([''S' int2str(num) '.hlp'']);else;sel=' ...
     int2str(size(ELE,1)) ';if tmp==2;sel=0;end;S' int2str(num) ...
     '=selelec('''',1:sel);end;']);
  set(fig,'userdata',hdl);
	% returned variables are
  set(hdl,'callback',['S',int2str(num),'=selelec;']);
  selected=h;
end;

%END OF SELELEC