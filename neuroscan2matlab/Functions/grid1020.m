function [X,Y,Z,hdl1,hdl2,hdl3]=grid1020(label,value,grid,n,legend);
%GRID1020 Interpolate values between electrodes.
%	[X,Y,Z,HDL1,HDL2,HDL3]=GRID1020(LABEL,VALUE,GRID,N,LEGEND) Plot map
%       of EEG label's values on head and interpolates with griddata values 
%       between electrodes. XY-values are [-1 1]x[-1 1], default grid is 
%       20x20. Scalar n gives number of color to legendtext. Vector n gives
%       value of each legendtext. 
%
%       With legend you can change defaultstyle %1.1f, if matrice different 
%       text for each legend. If one row and has #, creates matrice with #
%       replaced with corresponding label text. Returned hdl1 is for legend
%       text, hdl2(1) for surface, hdl2(2) for electrode markers and hdl3 
%       for electrode text and pointtext.
%
%SEE ALSO
%	Pos1020, griddata.
%       
%EXAMPLES
%	subplot(221);title('TYPE ELECTRODES');h=plottext;
%                       % 3 different outputs from values
%	run=['t' uicval(h,'string') '[l,v]=untiestr(''='',t);n=size(l,1),'...
%	 'v=[v ones(n,1)*'' ''];v=v'';v=eval([''['' v(:)'' '']'']);'...
%	 'claa(0.5,1);subplot(222);colormap(cool);grid1020(l,v,10,v,'...
%	 '''%2.2f #'');subplot(223);[X Y Z h1 h2 h3]=grid1020(l,v,10,v,'...
%	 '''%2.2f #'');close(h1);set([h2(2);h3],''color'',[1 1 1]);'...
%	 'colorbar;subplot(224);set(gca,''vis'',''off'');axes(''posit'','...
%	 '[0.4 0 0.6 0.6]);[dx dy]=gradient(Z);quiver(X,Y,dx,dy);hold ',...
%	 'on;pos1020(l,0,1,''x'',1);set(gca,''visible'',''off'');'];
%	set(h,'string',['FZ=10';'O1=20';'O2=30'],'callback',run);
%	eval(run)

%       J.Virkkala 13-Jul-94
%       J.Virkkala  3-Mar-95 Part of ScanUtil.
%	J.Virkkala 20-May-95 Name changed from map1020 to grid1020.

if nargin<5;legend='%1.2f';end;
if nargin<4;n=10;end;
if nargin<3;grid=20;end;
	% X identical columns, Y identical rows
[X,Y]=meshgrid(-1:2/grid:1);
	% read coordinates
[xy,label]=pos1020(label);
	% # in legend is replaced with corresponding label
if find('#'==legend(1,:));
  row=legend(1,:);
  a=strrep(row,'#',label(1,:));
  for i=2:size(label,1);
    a=[a;strrep(row,'#',label(i,:))];
  end;
  legend=a;
end;
	% inverse distance method
Z=griddata(xy(:,1),xy(:,2),value,X,Y);
	% ellipse
out=find(((abs(X)+.09).^2+Y.^2)>=1^2);
Z(out)=NaN*zeros(size(out));
hdl2(1)=surf(X,Y,Z);
	% find minimun and maximum
cl=caxis;
max_z=cl(2);
min_z=cl(1);
	% n gives legend number or corresponding color
n=n(:);
if size(n,1)>1|n(1)>0;
	% only if n given and >0
  tcolor=colormap;
  if size(n,1)==1;z=min_z:(max_z-min_z)/(n-1):max_z;
    tcolor=tcolor(1:size(tcolor,1)/n:size(tcolor,1),:);
  else 
    [z,ind]=sort(n);
    tmp='';
	% sorts n and legend
    for i=1:size(legend,1);tmp(i,:)=legend(ind(i),:);end;
    legend=tmp;
    n=size(n,1);
    i=upper((z-min_z)/(max_z-min_z+1)*size(tcolor,1))+1;
    tcolor=tcolor(i,:);end;
	% y position
    y=-1:2/(n-1):1;
	% z value
    for i=1:n;
      if size(legend,1)==1;row=sprintf(legend,z(i));
	else row=sprintf(legend(i,:),z(i));end;
      hdl1(i)=text(1,y(i),row);
      set(hdl1(i),'color',tcolor(i,:));
    end;
end;
	% handles
hold on

view(2)
	% more
hdl2(2)=plot3(xy(:,1),xy(:,2),max_z*ones(size(xy(:,1))),'kx');
hdl3=text(xy(:,1)-0.1,xy(:,2)-0.05,max_z*ones(size(xy(:,1))),label);
set(hdl3,'color',[0 0 0]);
set(gca,'xlim',[-1 1.1])
set(gca,'visible','off')

% END OF GRID1020