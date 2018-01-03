function [hdl,rhdl]=axes1020(label);
%AXES1020 Return axes for each electrode position.
%	[HDL,RHDL]=AXES1020(LABEL) label can be matrix of electrode positions
%	or labels. hdl are corresponding axes. rhdl gives handles for old 
%	axes and handles for 4 additional axes, one in each corner which can
%	be used to show scale for example.
%       
%	Old axes, rhdh(1) x, y and z coordinates colors are made black to 
%	make them invisible.
%
%SEE ALSO
%	Uses pos1020. See also grid1020.
%
%EXAMPLES
%	creafig([0 0 1 1])          % 3 axes
%	subplot(211);title('3 axes of small size')
%	[hdl,rhdl]=axes1020([-0.5 -0.5;0 0;0.5 0.5])
%	subplot(212);plot(randn(1,512));
%	set(gca,'xlim',[1 512])
%	print axes1020 -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%       J.Virkkala 14-Jul-94
%       J.Virkkala  3-Mar-95 Part of ScanUtil
%       J.Virkkala 20-May-95 Returned values are column vectors, old axes
%               is added and title values are sustained.

if ~isempty(label)&isstr(label),
   label=pos1020(label);
end;

dx=0.12;        % constant for positions
dy=0.20;
x1=-1.13;
x2=1.13;
y1=-1;
y2=1.11;

ax=gca;
set(ax,'xlim',[x1 x2]);
set(ax,'ylim',[y1 y2]);
set(ax,'units','norm');         % remove axes
set(ax,'xcolor',[0 0 0],'ycolor',[0 0 0],'zcolor',[0 0 0],...
'xticklabels','','yticklabels','');
p=get(ax,'position');
rhdl(1)=ax;
	
n=size(label,1);
hdl=[];
for i=1:n;
  x=label(i,1);
  y=label(i,2);
	% axes position
  pos=[p(3)*(x-dx-x1)/(x2-x1)+p(1) p(4)*(y-y1)/(y2-y1)+p(2) ...
     p(3)*2*dx/(x2-x1) p(4)*dy/(y2-y1)];
  hdl=[hdl axes('position',pos)];
end;
	% reference axes;
x=[-0.85 0.75 -0.85 0.75];
y=[ 0.70 0.70 -0.8  -0.8];
for i=1:4;
  pos=[p(3)*(x(i)-dx-x1)/(x2-x1)+p(1) p(4)*(y(i)-y1)/(y2-y1)+p(2) ...
    p(3)*3*dx/(x2-x1) p(4)*2*dy/(y2-y1)];
  rhdl(i+1)=axes('position',pos);
end;            % reference axes invisible
set(rhdl(2:5),'visible','off');

%END OF AXES1020