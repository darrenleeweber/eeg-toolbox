function [hdls]=uicput(what,y,style,hdls,height);
%UICPUT Create uicontrols.
%	[HDLS]=UICPUT(WHAT,Y) Returns handles for controls. If y<1 it's 
%	normalized pixels otherwise pixels. If y<0 then it's pixels from the
%	top down.
%
%	What is string with t(ext), e(dit), c(echkbox), r(adiobutton), 
%	b(pusbutton), p(opupmenu), s(lider) and f(rame) which twice used
%	defines position of uicontrols. Backslash separes uicontrols on
%	left and right. Other characters are ignored.
%
%SEE ALSO
%	Uicview.
%
%EXAMPLES
%	h1=uicput('12345678 t123t e   e/t123t e   e 12345678',0.5);
%	h2=uicput('12345678 t123t e   e/t123t e   e 12345678',0);
%	uicsetup('uicput.hlp',1);         % past in parts
%	set([h1(1) h2(1)],'String','XGrid');
%	set([h1(3) h2(3)],'String','YGrid');
%		% callbacks
%	tmp=['set(',int2str(gcf),',''currentaxes'','];
%	r1=['[X,Y]=meshgrid(-2:4/G1:2,-2:4/G2:2);Z=X.*exp(-X.^2',...
%	'-Y.^2);',tmp,o2s(subplot(2,1,1)),');mesh(X,Y,Z);'];
%	r2=['[X,Y]=meshgrid(-2:4/G3:4,-2:4/G4:2);Z=X.*exp(-X.^2',...
%	'-Y.^2);',tmp,o2s(subplot(2,1,2)),');surf(X,Y,Z);'];
%	G1=4;G2=4;G3=4;G4=4;
%	set([h1(2) h1(4) h2(2) h2(4)],'String','4');
%	        % upper screen, mesh
%	set(h1(2),'callback',['G1' uicval(h1(2),'string',1) 'eval(r1);']);
%	set(h1(4),'callback',['G2' uicval(h1(4),'string',1) 'eval(r1);']);
%	eval(get(h1(2),'callback'));
%	uicview(0.5);
%	        % lower screen, surf
%	set(h2(2),'callback',['G3' uicval(h2(2),'string',1) 'eval(r2);']);
%	set(h2(4),'callback',['G4' uicval(h2(4),'string',1) 'eval(r2);']);
%	eval(get(h2(2),'callback'));
%	uicview(0);
%	print uicput -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J. Virkkala 15-Jul-94
%	J. Virkkala  5-Mar-95 Part of ScanUtil

global RIGHT_POS SIZE_X			% temporary

if nargin<2;y=0;end;
if nargin<3;
	% determing figuresize
  old=get(gcf,'units');
  set(gcf,'units','pixels');
  pos=get(gcf,'position');
  if y<1;
   if y<0;y=pos(4)+y;
    else y=y*pos(4)+5,end;end; 
	% after / are justified to right corner
  tmp=find('/'==what);
  if isempty(tmp);tmp=size(what,2)+1;
    else;
       SIZE_X=pos(3)-10*size(what,2);
  end;
	% restroring unit
  set(gcf,'units',old);
  if find('p'==what);height=25;else;height=15;end;
  RIGHT_POS=tmp(1,1);
	% recursivly calling
  hdls=[];
  hdls=uicput(what,y,'text',hdls,height); 
  hdls=uicput(what,y,'edit',hdls,height);
  hdls=uicput(what,y,'checkbox',hdls,height);
  hdls=uicput(what,y,'radiobutton',hdls,height);
  hdls=uicput(what,y,'button',hdls,height);
  hdls=uicput(what,y,'popupmenu',hdls,height);
  hdls=uicput(what,y,'slider',hdls,height);
  hdls=uicput(what,y,'frame',hdls,height);
	% sort handles
  [a index]=sort(hdls);
  hdls=a(index(:,1),2);
	% to resize figures
  set(hdls,'units','normalized');
else;
  pos=find(style(1,1)==what)-1;
	% button is really pushbutton
  if strcmp(style,'button');style='pushbutton';end;
  for i=1:2:size(pos,2)-1;
	% justified to left or right
    if pos(i)>=RIGHT_POS dx=SIZE_X;else dx=0;end;
    hdl=uicontrol('style',style,'position',[dx+5+pos(i)*10 y ...
         (pos(i+1)-pos(i))*10 height]);
%JVIR, Uicontrol change.  
    set(hdl,'units','pixels');
    hdls=[hdls;pos(i)+1 hdl];
  end;
end

%END OF UICPUT