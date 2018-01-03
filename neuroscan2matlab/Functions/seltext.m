function [selected,hdl]=seltext(tex,num,width);
%SELTEXT Select strings.
%	[SELECTED,HDL]=SELTEXT(TEX,NUM,WIDTH) Checkbuttons for selecting 
%	text. Calling with two parameters creates figure with buttons in
%	tex and callbacks to return selected text to variable S[num]. 
%
%	With tex=[] sets figures buttons num on and with no parameters 
%	returns which buttons are on. There are buttons for help and for
%	selecting all on or off. If width not given box width 80
%	pixels is assumed.
%
%SEE ALSO
%	Uses uicsetup. See also selelec, loadcnt, plotdata
%
%EXAMPLES
%	[v,t,d]=scanhead('datas','eyes-closed.cnt')		
%	row='';	         % continue from selelec
%	for i=1:1000:eval(d);           
%	  row=putstr(sprintf('%g',i),row);
%	end;             % select range with S2 and
%	seltext(row,2);	 % press at background to update.
%	S2=seltext('',[1 2]);
%	run=['showwait(''wait...'');x0=(min(S2)-1)*1000+1;x1='...
%	'(max(S2)-1)*1000+1;[x1,y1]=loadcnt(''eyes-closed.cnt'',[],x0,x1)'...
%	';figure(pf);clf;plotdata(x1,y1(S1,:),l1(S1,:));showwait([]);'];
%	set(gcf,'windowbuttondownfcn',run);
%	eval(run);

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 14-Jul-94
%	J.Virkkala 29-Nov-94 New example
%	J.Virkkala  6-Dec-94 Can control boxeswidth
%	J.Virkkala  6-Mar-95 Part of ScanUtil

global BORDERX BORDERB
if nargin==0;tex='';end;

%*** CALLING ITSELF ****
if size(tex)==[0 0];
  chan=get(gcf,'userdata');
  chan=chan(:);
  for i=1:size(chan,1);
	% to set checkbuttons or to read what are pressed
    if nargin==2;
%     selected=num;
      if find(i==num);set(chan(i),'value',1);selected=[selected i];
        else;set(chan(i),'value',0);
      end;
    elseif get(chan(i),'value');selected=[selected i];end;
  end;
  hdl=gcf;
else

%*** CREATING FIGURE ***
  if nargin<3,width=80;end
  n=size(tex,1);
  pos=get(0,'screensize');
	% in how many rows
  sy=floor((pos(4)-100)/20);	% depends about platform, try -70
  nx=ceil(n/sy);
  pos(1)=pos(3)+90-num*(90+BORDERX)-nx*width;pos(2)=BORDERB;
  if nx==1;pos(3)=width+5;else;pos(3)=width*nx+5;end;
  if n<sy;pos(4)=n*20+45;else;pos(4)=sy*20+45;end
  fig=creafig(pos);
  set(fig,'numbert','off','menub','none',...
    'name',['S' int2str(num)],'resize','off')
  for i=1:nx;
    for j=1:sy;
      if (i-1)*sy+j<=n;
        hdl(j+(i-1)*sy)=uicontrol('style','check','units','pix',...
        'posi',[i*width-(width-5) j*20-15 width-5 15],'strin',...
        tex(j+(i-1)*sy,:),'horizontala','left');
      end;
    end;
  end;
	% close and On/Off/Hlp buttons
  if nx==1; 
    h=uicput('b1b/p123p',-35);
    set(h(1),'string','C','callback','close;');
  else
    h=uicput('b12b/p1234p',-35);
    set(h(1),'string','Cls','callback','close;');
  end
	% callback
  set(h(2),'string','On|Off|Hlp','callback',['tmp' uicval(h(2)) ...
    'if tmp==3;uihelp([''S' int2str(num) '.hlp'']);else;sel=' ...
     int2str(size(tex,1)) ';if tmp==2;sel=0;end;S' int2str(num) ...
     '=seltext('''',1:sel);end;']);
  set(fig,'userdata',hdl);
	% returned variables are
  set(hdl,'callback',['S',int2str(num),'=seltext;']);
end;

% END OF SELTEXT