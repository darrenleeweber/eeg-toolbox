function hdl=creafig(pos,set1,val1,set2,val2,set3,val3);
%CREAFIG Create figure at wanted location.
%	HDL=CREAFIG(POS,SET1,VAL1,...,SET3,VAL3) Create figure at pos(1), pos(2)
%	with width pos(3) and height pos(4). If pos<1 then normalized, if 
%	pos<10 then pos indicates divisions otherwise pixels. If scalar 1..4
%	then one fourth of screen. If val and set given these properties are
%	set for all figures
%
%SEE ALSO 
%	creafigs.
%
%EXAMPLES
%	creafig(4,'name','right bottom corner');
%	creafig([2 3 5 5]);
%	creafig([100 100 500 100]);

%JVIR, following is not needed
%	Use Uicontrols Font as New Courier 9 from Matlab Command Window, 
%	Options. Screen size of [1024 768] is supposed.

%	J.Virkkala 27-Dec-94 Documented.
%	J.Virkkala 23-Feb-95 Added val,set options.
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

global BORDERX BORDERY BORDERB

errorr;
	% figure opened at desired location
fig_pos=get(0,'defaultfigureposition');
fig_uni=get(0,'defaultfigureunits');

if size(pos)==[1 1],
   if pos==1|pos==3,i=1;else,i=2;end
   if pos==3|pos==4,j=2;else,j=1;end
   pos=[i j 2 2];
end

s=get(0,'screensize');
if max(pos)<=1,
   pos=pos.*[s(3) s(4) s(3) s(4)];
   pos=pos+[BORDERX BORDERB -2*BORDERX -BORDERB-BORDERY];
elseif max(pos)<10,
   i=pos(1);
   j=pos(4)-pos(2)+1;
   dx=(s(3)-1*BORDERX)/pos(3);
   dy=(s(4)-BORDERB)  /pos(4);
   pos=[(BORDERX+(i-1)*dx) (BORDERB+(j-1)*dy) dx-BORDERX dy-2*BORDERY];
end

% for resize to work
set(0,'defaultfigureunits','pixels')
set(0,'defaultfigureposition',pos);
	% changing default value before creating
hdl=figure;
set(0,'defaultfigureunits','normalized')
	% restoring old default
set(0,'defaultfigureposition',fig_pos);
set(0,'defaultfigureunits',fig_uni);

	% common properties
if nargin>1;
  set(hdl,set1,val1);
  if nargin>3;
    set(hdl,set2,val2);
    if nargin>5;
      set(hdl,set3,val3);
    end;
  end;
end;

%END OF CREAFIG