function [hdl]=plotband(x,value,yl,format,style);
%PLOTBAND Plots vertical bands with multiple values.
%	[HDL]=PLOTBAND(X,VALUE,YL,FORMAT,STYLE) Where hdl's first column
%	for lines and second column for text handles.  Format is for line 
%	format and style for printing values with sprintf. Values first row 
%	is printed on top and following below that, x has one more column
%	than matrice of value. 
%
%	Use possible other plot and xlim to axes before this command, this
%	should last command to axis. Rows of values are printed between top 
%	half of axes. If yl given that defines absolute position in yl(1,:).
%	Vertical lines between yl(2,1)-yl(3,1).
%
%SEE ALSO
%	Getband, uiscroll.
%
%EXAMPLES
%	y=5*randn(4,5)               % plotting different bands
%	a1=subplot(311);plot(randn(1,25));set(gca,'ylim',[-5 5]);
%  	h1=plotband([0 5 10 15 25],y,[],'-','%1.1f');
%	a2=subplot(312);plot(randn(1,25));set(gca,'ylim',[-5 5]);
%  	h2=plotband([0 5 10 15 25],y(1,:),[4;-5;5],':','%1.2f');
%	a3=subplot(313);plot(randn(1,25));set(gca,'ylim',[-5 5]);
%  	h3=plotband([0 5 10 15 25],y,[4:-2:-2],'-.','%1.3f');
%	set(h1(1:2:5,1),'linest',':')% every second dotted
%	set(h3(1:4:13,2),'fontsi',12)% top row large
%	print help\plotband -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR,23-Feb-1999 Removed color
%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR, 2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 10-Aug-94
%	J.Virkkala 21-Dec-94 Can control lines height, moving.
%	J.Virkkala 25-Feb-95 Text at middle and lines in white color.
%	J.Virkkala 10-Mar-95 Part of ScanUtil, more parameters.
%	J.VIrkkala 20-May-95 Change and expand the use yl.

if nargin<5;style='%1.2f';end
if nargin<4;format='-';end
if nargin<3;yl=[];end
if nargin<2;value=[];end

x=x(:);
if size(value,2)==1,value=value';end

n=size(x,1);
nv=size(value,1);
x=[x x zeros(n,1)*NaN];
lim=get(gca,'ylim');

if isempty(yl),	% test and line y-positions
   if nv~=0,
      yl=lim(2):(lim(1)-lim(2))/(nv*2):lim(1)/2;
   end
   ll=[lim(1) lim(2)];
else
%JVIR,23-Feb-1999 following check removed
%  if size(yl,1)==3;
     ll=[yl(2) yl(3)];
   if size(yl,2)==1;
     yl=lim(2)-(lim(2)-yl(1))*[1:nv];
   end
end
y=[ones(n,1)*ll(1) ones(n,1)*ll(2) zeros(n,1)*NaN];
			% plot lines
hdl(:,1)=line(x',y');
%JVIR,23-Feb-1999 Color has to be removed.         
set(hdl(:,1),'linestyle',format);%,'color',[1 1 1]);
			% plot text
if nargin>1;
  old=get(gca,'xlim');
  dx=(old(2)-old(1))/50;
  for i=1:n-1;
    for j=nv:-1:1;	% values 
      hdl((i-1)*nv+j,2)=text(mean([x(i) x(i+1)]),yl(j),...
	sprintf(style,value(j,i)));
    end;
  end;			% values at center
  if size(hdl,2)>1,set(hdl(find(hdl(:,2)~=0),2),'HorizontalA','center',...
	'verticalalig','top');end
end;  

%END OF PLOTBAND