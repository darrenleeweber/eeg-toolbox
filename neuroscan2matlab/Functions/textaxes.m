function h1=textaxes(h2,dx,dy,set1,val1,set2,val2,set3,val3);
%TEXTAXES Converts plottext output into separate text objects.
%	H1=TEXTAXES(H2,DX,DY,SET1,VAL1,SET2,VAL2,SET3,VAL3) Converts
%	edit uicontrol into text object in same axes for printing or
%
%DIAGOSTIC
%	Use Uicontrols Font as Terminal 9 from MATLAB Command Window,
%	Options.
%
%EXAMPLES
%	a=randn(15,12);			% random numbers
%	creafig([0 0.4 1 0.6]);
%	axes('position',[0.01 0.01 0.98 0.85]);
%	ph=plottext('QEEGA.PLT',a);	% adding uicontrols
%	h=uicput('b123456bb12356b/b123456b',0.9);
%	set(h(1),'String','Text','callback',['th=textaxes(' h2s(ph) ');']);
%	set(h(2),'String','Back','callback',['textaxes(' h2s(ph) ',-1);']);
%	set(h(3),'String','Print','callback',['textaxes(' h2s(ph) ');' ...
%		'prnutil;textaxes(' h2s(ph) ',-1);']);
%

%ALGORITHM
%	I have tried Apr-95 to convert for loops into m file of rows but
%	time consumption was the same.
%
%REFERENCES
%

%	J.Virkkala  7-Apr-95 Better printing quality for QEEGA
%	J.Virkkala 20-May-95

if nargin<2,dx=65.0;end %
if nargin<3,dy=11.7;end
%*** REMOVING TEXT ***
if dx==-1,
  close(gca);set(h2,'visib','on');
  return;
end

%*** CREATE TEXT STRINGS FOR PRINT OUT ***
a=axes('position',[0 0 1 1]);
set(a,'defaulttextfontsize',10,'defaulttextHorizontalA','right');
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
  ex=-1;		% extra tabulator if more than 7 characters
  row=txt(i,:);
  if row~=[],
    ind=[find(row==setstr(9)) size(row,2)];
    if row(1)==setstr(9),old=2;else;old=1;end
		% through indexes.
    for j=1:length(ind),
      if old<(ind(j)-1),
        t=row(old:ind(j)-1);
        x=i;y=j;
        xx=x0+(j+ex)*dx;yy=y0-i*dy;
        h1(x,y)=text;
        set(h1(x,y),'units','pixels','Position',[xx yy],'String',t,'units','norm');
        if j==3,
          set(h1(x,y),'units','pixels','Position',[xx+45 yy],'units','norm');
        end
        if j<2|i==2,         
           set(h1(x,y),'HorizontalA','left');
        end;
        n=length(t);
	if n>7,
          ex=ex+floor(n/7);
        end
      end 
      old=ind(j)+1;
    end
  end
end
showwait([]);
set(h2,'visible','off')

	% common properties
if nargin>3;
  set(hdl,set1,val1);
  if nargin>5;
    set(hdl,set2,val2);
    if nargin>7;
      set(hdl,set3,val3);
    end;
  end;
end;

% END OF TEXTAXES