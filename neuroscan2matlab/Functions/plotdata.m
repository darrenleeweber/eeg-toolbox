function [hdl]=plotdata(x,y,labels,height,ticks,ticklab,ticktext);
%PLOTDATA Plot data with labels into current axes.
%	[HDL]=PLOTDATA(X,Y,LABELS,HEIGHT,TICKS,TICKLAB,TICTEXT)  Y is a 
%	matrice where rows are different datasets. Height(1:2) gives 
%	point below and upper to zero for each chanels. Ticks gives relative 
%	minor ticks for each channels, zeros aren't printed. Those matrices 
%	are expanded to match the height of y. First row in y is shown at top.
%	Labels can also be [] or format for sprintf.
%
%	Ticklabel is corresponding boolean matrice whether to print minortick
%	text: 0 don't print, 1 print value with %g, >1 print text in ticktext
%	(i,:). If ticktext given, first gives number format for value 1. Hdl 
%	returns handles for lineobjects.
%
%DIAGNOSTICS
%	If height not given maximum 2*std from datasets is used.
%
%SEE ALSO 
%	map1020, uiscroll.
%
%EXAMPLES
%	x=1:100;y=randn(3,100);		% random numbers
%	y(1,:)=y(1,:)/2;
%	subplot(211);title('data');
%	plotdata(x,y,['a)';'b)';'c)'],[2 2],[-1 1])
%	subplot(212);title('more vertical space');
%	plotdata(x,y,['a)';'b)';'c)'],[4 2;2 2;2 2],[-1 1;-1 1;-1 1],...
%	[0 2;0 1 ;0 1],str2mat('%1.1g','signal'));
%	print Help\plotdata -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  4-Feb-1999 Corrected tickpos
%JVIR,  3-Feb-1999 Addded plotdata
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 12-Aug-94
%	J.Virkkala 17-Dec-94 First entry printed at top.
%	J.Virkkala  3-Mar-95 Part of ScanUtil.
%	J.Virkkala 23-May-95 Added line userdata to have vertical change.

	% How many plots
nc=size(y,1);
if nc==0;return;end
	% make height to full length
if nargin<3,
  labels=[]
else
%JVIR, not needed   labels=flipud(labels);
end	% create label

if size(labels,1)==1,
  format=labels;
  for i=1:size(y,1),		
    labels=putstr(sprintf(format,i),labels,i,1);
  end
end
if nargin<4;height='';end;
if isempty(height);height=ones(1,2)*2*max(std(y'));end;
[hy,hy]=size(height);
if hy~=nc;height=ones(nc,2)*diag(height(1,1:2));end;
	% make tick to full length
if nargin<5;ticks='';end;
if isempty(ticks);ticks=0;end;
if size(ticks,1)~=nc;ticks=ones(nc,size(ticks,2))*diag(ticks(1,:));end;
	% if boolean to ticklabels not given then all active
if nargin<6;ticklab='';end;
if isempty(ticklab);ticklab=ones(nc,size(ticks,2));end;
if size(ticklab,1)~=nc;ticklab=ones(nc,size(ticks,2))*diag(ticklab(1,:));end
	% if format for sprintf for ticktext not given %g
if nargin<7;ticktext='%g';end;
	% create ticks for signals
points=fliplr(height');points=points(1:2*nc);points=fliplr(cumsum(points));
points=points(1:2:size(points,2));
ticks_pos=points;
ticks_lab=labels;
	% minor ticks
for i=1:nc;
  for j=1:size(ticks,2);
    yrel=ticks(i,j);
    if yrel;ticks_pos=[ticks_pos,(points(i)+yrel)];
      ytlab=ticklab(i,j);
	% ticklabels are numbers or text
      if ytlab>0;label=sprintf(ticktext(ytlab,:),yrel);else;label='';end;
      ticks_lab=str2mat(ticks_lab,label);
    end;
  end;
  hdl(i)=line(x,y(i,:)+points(i));
  set(hdl(i),'userdata',points(i));
	% extensions planned
% set(hdl(i),'userdata',points(i));		
end;
	% Updating labels
%JVIR, Ticks must be sorted for Matlab 5.2
[ticks_pos,i]=sort(ticks_pos);
ticks_lab=ticks_lab(i,:);
set(gca,'ytick',ticks_pos);
%JVIR, Yticklabel is new name
set(gca,'yticklabel',ticks_lab);
set(gca,'yticklabelmode','man');
	% ylim 0...last+height
set(gca,'ylim',[min([0,min(ticks_pos)]),max(ticks_pos)+height(nc,2)]);
set(gca,'xlim',[min(x) max(x)]);

%END OF PLOTDATA