function freeze(def)
%FREEZE Freeze, unfreeze figure by toggling visible.
%	FREEZE(DEF) Freezed figure is shown by selecting it's axes and to 
%	figures name is added /F=(total size of all x,y,z and c). Function
%	is called by clicking any axes (not border). 
%
%	With parameters defines operation. With 'no preview', def 1 first
%	click show total size and second click draws. 
%
%DIAGNOSTICS
%	There is also figure property DrawMode, fast/normal to fasten 
%	redrawing. Selection shown by gcf, selected. Redrawing inhibited 
%	by hdl, visible.
%
%EXAMPLES
%	freeze(0)                            % normal setup
%	freeze(1)                            % no preview setup
%	[X,Y]=meshgrid(-2:.2:2,-2:0.2:2);		
%	Z=X.*exp(-X.^2-Y.^2);                % many subplots
%	subplot(221);mesh(Z);subplot(222);meshc(Z);
%	subplot(223);surf(Z);subplot(224);contour(Z);
%	[X,Y]=meshgrid(-2:.05:2,-2:0.05:2);  % one large plot
%	Z=X.*exp(-X.^2-Y.^2);mesh(Z);
%	

%	J.Virkkala  3-Aug-94
%	J.Virkkala  3-Mar-95 Part of ScanUtil.

	% Does defaultsetup if def given
if nargin>0;
  set(0,'defaultaxesbuttondownfcn','freeze')
  if def>0;st='off';else;st='on';end;
  set(0,'defaultsurfacevisible',st)	
  set(0,'defaultlinevisible',st)
  set(0,'defaultimagevisible',st);
  set(0,'defaultpatchvisible',st);		  
  break
end;
	% Freeze/Unfreeze current figure
hdl1=get(gcf,'children');
name=get(gcf,'name');
pos=findstr('/F=',name);
if size(pos);set(gcf,'name',name(1:pos(1)-1));end;
	% 'unfreeze' current figure
if strcmp(get(gcf,'selected'),'on'); 
  set(gcf,'selected','off');
% set(gcf,'resize','on');	% needed with matlab 4.0
  for i=1:size(hdl1(:),1)
   if strcmp(get(hdl1(i),'type'),'axes');
     set(hdl1(i),'selected','off');
     hdl2=get(hdl1(i),'children');
     set(hdl2,'visible','on'); 
   end
  end
else
	% 'freeze' current figure
  set(gcf,'selected','on');
% set(gcf,'resize','off');	% needed with matlab 4.0
  s=0;
  for i=1:size(hdl1(:),1)
    if strcmp(get(hdl1(i),'type'),'axes');
     set(hdl1(i),'selected','on');
     hdl2=get(hdl1(i),'children');
     for j=1:size(hdl2(:),1);
       eval('x=get(hdl2(j),''Xdata'');','x=0;');s=s+size(x(:),1);
       eval('x=get(hdl2(j),''Ydata'');','x=0;');s=s+size(x(:),1);
       eval('x=get(hdl2(j),''Zdata'');','x=0;');s=s+size(x(:),1);
       eval('x=get(hdl2(j),''Cdata'');','x=0;');s=s+size(x(:),1);
     end;
     set(hdl2,'visible','off'); 
   end
  end
	% shows that figure is freezed and number of elements
  set(gcf,'name',[name '/F=' int2str(s)]);
end;
  
% END OF FREEZE