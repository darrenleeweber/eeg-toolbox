function hdl=getband(band,x);
%GETBAND Get bands from axes.
%	HDL=GETBAND(BAND,X) Where band is vector of x-positions and x is
%	width of each band. 
%
%DIAGNOSTICS
%	Press mouse button on x-axis, not on any other object. Used objects
%	are gca, userdata.
%
%SEE ALSO
%	Uses uiscroll.
%
%EXAMPLES
%	a1=subplot(211);plot(randn(1,1024)),set(gca,'xlim',[1 1024])
%	h1=uiscroll;getband(10:100:1000,10);					
%	a2=subplot(212);plot(randn(1,1024)),set(gca,'xlim',[1 1024])
%	h2=uiscroll;getband(10:100:1000,10);	
%	print Help\uiscroll -djpeg
%	                      % after selecting bands
%	d=get(a1,'userdata');d(:,1)
%	d=get(a2,'userdata');d(:,1)

%Mention source when using or modifying these Shareware tools
%JVIR,23-Feb-1999 Removed color [1 1 1]
%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR, 3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 22-Jan-95 Using axes properties.
%	J.Virkkala 10-Mar-95 Part of ScanUtil.

%*** CALLING FROM BUTTONDOWNFCN ***
if nargin==0,
  band=get(gca,'userdata');	% userdata
  hdl=band(:,2:size(band,2));
  band=band(:,1);
  sel=get(gcf,'selectiontype');
  pos=get(gca,'currentpoi');	% current point
  pos=pos(1);
  if strcmp(sel,'alt'),
  else
     if strcmp(sel,'normal'),	% left from right, right from left
       i=find(band(:,1)<=pos(1));
       if ~isempty(i),i=i(length(i));end
     else
       i=find(band(:,1)>=pos(1));
       if ~isempty(i),i=i(1);end
     end
     if ~isempty(i),
       band(i,1)=pos;
       x=get(hdl(i,1),'xdata');
       set(hdl(i,1),'xdata',[pos pos NaN]);
       if size(hdl,2)>2,
         xx=get(hdl(i,3),'xdata');
         set(hdl(i,3),'xdata',xx+[pos pos NaN]-x);
       end
%      set(hdl(i,1),'xdata',pos);
       if hdl(i,2)~=0,
         xx=get(hdl(i,2),'position');
         set(hdl(i,2),'position',[xx(1)+pos-x(1) xx(2)]);
         set(gca,'userdata',[band hdl]);
       end      
     end
  end
		
%*** SETUP ***   
else
  if nargin<3,div=[1.10 0.90];end
  if isempty(band),
    creafig([0 0 1 0.3]);
  else  
    band=band(:);
			% width shown at one time
    n=size(band,1);
    d=get(gca,'xlim');
    h=plotband(band(:,1),1:n,'','-','%1.0f');
%JVIR,23-Feb-1999
    %    set(h(:,1),'color',[1 1 1]);
    p=get(h(1,2),'position');
			% names 
    h(n,2)=text(n,p(2),int2str(n));set(h(n,2),'verticala','top');
    for i=1:n;
      set(h(i,2),'position',[band(i,1)+(d(2)-d(1))/50 p(2)]);
    end;
    if nargin<2,x=[];end
    if size(x)~=[0 0],          
      h=[h plotband(band(:,1)+x(:),[],[],':')];
%JVIR,24-Feb-1999 end of selection      
%     set(h(:,3),'color',[1 1 1]);
    end
    set(gca,'buttondownfcn','getband;');
    set(gca,'userdata',[band h]);
    hdl=gca;
  end
end;

%END OF GETBAND