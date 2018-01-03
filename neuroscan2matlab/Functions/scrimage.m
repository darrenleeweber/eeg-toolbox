function [H,X,C]=scrimage(hdl,rec)
%SCRIMAGE Display handle as image.
%	[X,C]=SCRIMAGE(HDL,REC) Uses roots properties to get image and changes
%	current colormap before displaying image. Hdl can be 0 (hole screen)
%	or figure or axes handle. If rect not given hole handle is captured,
%	<1 normalized units [x y width height] and with >1 pixels.
%             
%DIAGNOSTICS
%	Created colormap not correct, 'getframe' not supported in 16
%	color mode.
%           
%SEE ALSO
%	Uses image, colormap. See also makeblt.
%           
%EXAMPLES
%	makeblt;        % copy bottom half of screen
%	scrimage(0,[0 0 1 0.5]);
%	makeblt
%	                % continue from scrimage
%	scrimage(h)
%
		
%	J.Virkkala 16-Aug-94
%	J.Virkkala 29-Nov-94 Documention for physics department.
%	J.Virkkala  9-Jan-95 Adding axes capturing, plottext.

		% 3rd width and 4th height
ssize=get(0,'screensi');	
if nargin<1,hdl=gcf;end
		% hole screen
if hdl==0,			
  if nargin<2,
    rec=ssize;
  elseif max(rec)<=1,
    rec=[ssize(3) ssize(4) ssize(3) ssize(4)].*rec;
  end				
else
  C=colormap;
  if hdl==floor(hdl),figure(hdl);end  
  old=get(gcf,'units');
  set(gcf,'units','pixels');
  pos=get(gcf,'position');
  C=colormap;
		% figure
  if strcmp(get(hdl,'type'),'figure'),
    if nargin<2,
      rec=[0 0 pos(3:4)];
    elseif max(rec)<=1,
      rec=rec.*pos;
    end
    rec(1:2)=rec(1:2)+pos(1:2);
  end
  set(gcf,'units',old);
		% uicontrol, axes
  if strcmp(get(hdl,'type'),'figure')==0,
    old=get(hdl,'units');
    set(hdl,'units','pixels');
    po2=get(hdl,'position');
    if nargin<2,
      rec=[0 0 po2(3:4)];
    elseif max(rec)<=1,
      rec=rec.*pos;
    end
    rec(1:2)=rec(1:2)+pos(1:2)+po2(1:2);
    set(hdl,'units',old);
  end    
end
		% remove borders
rec=ceil(rec);
set(0,'capturerect',rec+[-1 -1 1 1]);
H=[];
X=get(0,'capturematrix');
colormap(gray(max(max(X))-min(min(X))));
C=colormap;
C(max(max(X)),1:3)=[0 0 0];
C(min(min(X)),1:3)=[1 1 1];
if nargout<2,
  if hdl==floor(hdl),
    creafig(rec);
    H=[gcf axes('position',[0 0 1 1])];
  else
    H=axes('position',get(hdl,'position'));
  end
  image(X);
  colormap(C) 
  drawnow;
  set(gca,'visible','off');
  set(hdl,'visible','off');
end;

% END OF SCRIMAGE