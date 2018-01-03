function [h]=scrollda(run,div,ma,di,ax);
%SCROLLDA To scroll data, with uiscroll.
%	SCROLL(RUN,DIV,MA,DI,AX) Run is evaluated when current xlim goes
%	beyond xdata in objects. Run must be functions of x and y, see 
%	example. Div is ]0 1[, 0.5 normally, 0.9 if not likely to change 
%	scroll direction. Ma is minimum and maximum x value for run and if 
%	di given run is shown with loading. Ax is axis handle.
%
%DIAGNOSTICS
%	Works only with line objects, like plot or plotdata. Created
%	line objects are supposed to be in reversed order of rows in y.
%
%SEE ALSO
%	plotdata, plot.
%
%EXAMPLES
%	                % frequency modulated signal 1-11 Hz.
%	run='x=x:1/1000:(x+d);y=sin(2*pi*(1+x./10).*x);'
%	x=0;d=20;eval(run);plot(x,y);
%	uiscroll([0 100],1,[],['scrollda(''' run ''',0.5,[0 100],1']);	
%	                % showing 200 Hz sampled closed.cnt
%	run='x=x*200;[x,y,la,e,c,o]=loadcnt(''closed.cnt'',[],x+1,x+3000);'
%	x=0;eval(run);plotdata(x,y,la,[50 50]);
%	run=strrep(run,'''','''''');
%	uiscroll([0 eval(o(6,:))/200-2],2,[],['scrollda('''...
%	  run ''',0.5,[0 ' int2str((eval(o(6,:))-3000)/200-1) '],1']);
%	print Help\scrollda -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR,25-Feb-1999 Saving into help directory.
%JVIR, 3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 22-May-95 Loading large files continuously.
%	J.Virkkala 29-May-95 Added checking of minimum value.

if nargin==4;ax=di;di=[];end
set(gcf,'currentaxes',ax);
h=findobj(gca,'Type','line');
if isempty(h),
  errorr('hpi no X(Y) data found','scrollda');
  return;
end
lx=get(gca,'xlim');
	% old properties
x=get(h(1),'xdata');
mi=min(x);
mx=max(x);
clear x;
	% xlim beyound data
if lx(1)<mi|lx(2)>mx
  if ~isempty(di),disp(['scrollda : Evaluating ' run(1:min([60 length(run)]))]);end
  d=mx-mi;
	% left
  if lx(1)<mi
    x=lx(1)-div*d;
    x=[x x+d];
  else
	% right
    x=lx(1)-(1-div)*d;
    x=[x x+d];
  end
  x=x(1);
  x=min([x ma(2)]);
  x=max([x ma(1)]);
  eval(run);
		% don't redraw update only
  set(h,'Xdata',x);
  n=size(y,1);
%*** ARE AXES ALWAYS CREATED THIS WAY ***
  for i=1:n,
    l=get(h(n-i+1),'userdata');
    if isempty(l),l=0;end
    set(h(n-i+1),'Ydata',y(i,:)+l);
  end
end 

%END OF SCROLLDA  