function hdl=figtext(t1,t2);
%FIGTEXT Create figure text. 
%	HDL=FIGTEXT(T1,T2) Creates figure's text at top of current figure. 
%
%SEE ALSO
%	Uses clock.
%
%EXAMPLES
%	figure;figtext('demo');
%	figure;figtext('demo','test');
%	print fixtext -djpeg

%	Left corner date and time and right corner given t1. If both t1 and t2 at
%	given then t1 at middle enlarged, t2 right. This command should be the
%	last before printing. Returns axes, text handles.

%Mention source when using or modifying these Shareware tools

%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR,23-Feb-1999 Putting text in middle
%JVIR, 3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 29-Jul-94
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala  9-Mar-95 Corrected horizontalaligment position.
%	J.Virkkala 29-May-95 If two parameters then center and right.

	% if one given it's to right corner
if nargin<2,
  t2=t1;
  t1='';
end
day=date;
c=clock;
	% text into left topcorner
hdl=axes;
	% replace tabulators
t1=deblanks(strrep(t1,setstr(9),'/'));
t2=deblanks(strrep(t2,setstr(9),'/')); 
set(hdl,'units','norm','position',[0 0 1 1],'units','pix','visible','off');
pos=get(gca,'position');
lim=get(gca,'ylim');
y=(pos(4)-5)*lim(2)/pos(4); %position of text
%JVIR,23-Feb-1999 Putting text in middle
%hdl=[hdl text(0.025,y,sprintf('%s %1.0f:%1.0f',date,c(4),c(5)))];
%if ~isempty(t2);
% hdl=[hdl text(0.975,y,t2)];
% set(hdl(3),'HorizontalA','right');
%end
%if ~isempty(t1); % text(0.5,y,[t1)
 hdl=[hdl text(0.5,y,sprintf('%s %1.0f:%1.0f %s %s',date,c(4),c(5),t1,t2))];
 set(hdl(length(hdl)),'HorizontalA','center','fontsize',...
	1.2*get(gcf,'defaulttextfontsiz'));
%end
	% works with rescaling
set(gca,'units','norm');

%END OF FIGTEXT