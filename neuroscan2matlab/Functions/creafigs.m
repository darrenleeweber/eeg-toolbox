function [hdl]=creafigs(n,set1,val1,set2,val2,set3,val3);
%CREAFIGS Create figures spacely around screen.
%	[HDL]=CREAFIGS(N,SET1,VAL1,...,SET3,VA3) Create n figures spacely 
%	around screen, not overlapping. Return figure handles. If val and 
%	set given these properties are set for all figures. With property, 
%	menubar, figure there will be some overlapping.
%
%DIAGNOSTICS
%	Creating maximum of 9*9=81 figures.
%
%SEE ALSO
%	Uses creafig.
%
%EXAMPLES
%	creafigs(7,'name','name','numbertitle','off')
%	           % maximum number of figures
%	h=creafigs(81,'buttondownfcn','close');
%	for i=1:81,
%	 figure(h(i));hh=title(['FIG ' int2str(i)]);set(hh,'fontsize',20);
%	end

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%       J.Virkkala  1-Jul-94
%       J.Virkkala 18-Dec-94 Using creafig
%       J.Virkkala  5-Mar-95 Part of ScanUtil

if n>81,
  if errorr('hppToo many figures, maximum 81.','CREAFIGS');return;end
end
	% screen isn't square
x=sqrt(n);
if x==round(x);x=floor(x);else;x=floor(x+1);end;
if (x^2-n)>=x;y=x-1;else;y=x;end;

	% defining position
for i=1:y;
 for j=1:x;
   if n==1,hdl=creafig([0 0 1 1]);else
     fi=j+(i-1)*x;
	% changing default value before creating
     if fi<=n;hdl(fi)=creafig([j i x y]);end;
   end
  end;
end;

	% common properties
if nargin>2;
  set(hdl,set1,val1);
  if nargin>4;
    set(hdl,set2,val2);
    if nargin>6;
      set(hdl,set3,val3);
    end;
  end;
end;

%END OF CREAFIGS
