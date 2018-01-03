function h1=convtext(h2,dx,dy,com);
%CONVTEXT Convert plottext output into separate text objects.
%	H=CONVTEXT(H2,DX,DY,COM) Convert edit uicontrol into text objects
%	in same axes for styling and, or printing. From text tabulator, 
%	char(9) are searched and printed with spacing (dx,dy) with fontsize
%	9 and aligment right.
%
%	If dx, dy not given 61, 16 is supposed. com is used to change
%	properties of each text object. #1 is replace with "if ," #2 with 
%	";set(h,')" and #3 with ");end;" and variables to use are x, y, h
%	and t.
%
%DIAGNOSTICS
%	Use Uicontrols Font as Courier New 9 from Matlab Command Window,
%	Options.
%
%SEE ALSO
%	plottext, scrimage.
%
%EXAMPLES
%	a=abs(5*randn(15,12));          % random numbers 
%	creafig([0 0.4 1 0.6]);
%	axes('position',[0.01 0.01 0.95 0.90]);
%	com=['#1j<2|i==2#2''horizontala'',''left''#3#1j==3#2'...
%	 '''position'',[x+45 y]#3'];com=strrep(com,'''','''''');
%	ph=plottext('QEEGA.PLT',a);     % adding uicontrols
%	h=uicput('b123456bb12356b/b123456b',0.9);
%	set(h(1),'String','Text','callback',['th=convtext(' ...
%	       o2s(ph) ',''' com ''');']);
%	set(h(2),'String','Back','callback',['convtext(' ...
%              o2s(ph) ',-1);']);
%	set(h(3),'String','Print','callback',['convtext('...
%              o2s(ph) ',''' com ''');print;convtext('...
%	 o2s(ph) ',-1);']);
%	print convtext -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala  7-Apr-95 Better printing quality for QEEGA
%	J.Virkkala 22-May-95 General structure, setup for strings.

if nargin<4,com=' ';end
if nargin==2,com=dx;end 
if nargin<3,dx=61;dy=16;end
%*** REMOVING TEXT ***
if com==-1,
  close(gca);set(h2,'visib','on');
  return;
end
com=strrep(com,'#1','if ');
com=strrep(com,'#2',';set(h,');
com=strrep(com,'#3',');end;');

%*** CREATE TEXT STRINGS FOR PRINT OUT ***
a=axes('position',[0 0 1 1]);
set(gcf,'defaulttextfontsize',9,'defaulttextHorizontalA','right');
%,'defaulttextfontname','Time New Roman');
set(h2,'units','pixels');
pos=get(h2,'position');
set(h2,'units','norm');
txt=get(h2,'String');
		% through all rows.
set(a,'visible','off');
showwait('creating text labels - %1.0f');

for i=1:size(txt,1);
  x0=pos(1);
  y0=pos(2)+pos(4);
  
  showwait;
  ex=-1;	% extra tabulator if more than 7 characters
  row=txt(i,:);
  if ~isempty(row),
    ind=[find(row==setstr(9)) size(row,2)];
    if row(1)==setstr(9),old=2;else;old=1;end
		% through indexes.
    for j=1:length(ind),
      if old<(ind(j)-1),
        t=row(old:ind(j)-1);
        x=x0+(j+ex)*dx;y=y0-i*dy;
        h=text;
        set(h,'units','pixels','Position',[x y],'String',t);
		% evaluate command
        eval(com);
	h1(i,j)=h;
        n=length(t);
		% handle tabulators
	if n>7,
          ex=ex+floor(n/7);
        end
      end 
      old=ind(j)+1;
    end
  end
end
showwait([]);
set(h1,'units','norm');
set(h2,'visible','off')
	% just to make certain
set(0,'units','pixels');

%END OF CONVTEXT