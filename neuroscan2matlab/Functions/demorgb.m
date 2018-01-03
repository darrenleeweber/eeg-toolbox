function demorgb(n);
%DEMORGB Demonstratate RGB colors.
%	DEMORGB(N) Gives some basic ideas of uicontrols. If n given it 
%	tells how many subdivisions there are for each axes, $n^3$ colors.
%
%SEE ALSO
%	Uses showwait, uicview, uicput, uicval.
%
%EXAMPLES
%	demorgb
%	print demorgb -djpeg

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 30-Jul-94	
%	J.Virkkala  6-Mar-95 Part of ScanUtil.

x=[0 0 1 1 0];		% square in xy plane
y=[0 1 1 0 0];
	% if no parameters given
if nargin==0;n=2;else;n=round(n);end;
n=n-1;
step=1/n;
	% scale RGB colors from 0...1
x=x./(n+1);		
y=y./(n+1);
cf=n/(n+1);
	% text
xlabel('(R)ed');
ylabel('(G)reen');
zlabel('(B)lue');
view(3);
axis('square')
hold on;
	% uicontrols to change angle of view
uicview;
	% make sure
set(gcf,'units','pixels','numbertitle','off','name','RGB Colors',...
  'menubar','none');
	% creating uicput
hdl=uicput('b12345b/t123te123e',-20);
hdl=[hdl;uicput('/s123  123s',-40)];
	% close buttons
set(hdl(1),'string','Close','callback','close;');
	% change N
set(hdl(2),'string','N');
set(hdl(4),'value',n+1,'min',2,'max',6);
	% change number of divides
set(hdl(3),'callback',['n' uicval(hdl(3),'string',1) ';clf;demorgb(n)'],...
  'string',int2str(n+1));
set(hdl(4),'callback',['n' uicval(hdl(4)) ';clf;demorgb(n)']);
	% loop drawing, nested loops -> slow
showwait('creating colors (%1.0f s)');
for i=0:step:1;
  for j=0:step:1;
    for k=0:step:1;
       fill3(x+cf*i*ones(1,5),y+cf*j*ones(1,5),ones(1,5)*k,[i j k])
    end;
    showwait;     
  end;
end;
hold off
showwait('');

%END OF DEMORGB