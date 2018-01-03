function editmacr(ta,ls,f);
%EDITMACR Create figure to load, edit and save macro.
%	EDITMACR(TA,LS,F) Calling, without parameters creates figure to edit 
%	global variable R0...R9, which can then be evaluated by streval 
%	function. Use script setscan to define R0..R9 global.
%
%	Use this page/all pages to select which are affected by load/merge 
%	and save/append command. With loading %PAGE R in file indicates where
%	to put the text. MAKEM text is for converting macro to m file by 
%	makem with name given in the box.
%
%	With parameters you can run desired operation for f(ile): Ta is for 
%	t(his page) or a(all pages) and ls is for selecting l(oad), m(erge)
%	or s(ave) command
%
%DIAGNOSTICS
%	When saving macros it is wise to use *.r1, *.r2 for different
%	versions. If you exit Matlab, macros aren't saved automatically.
%	Used global variables are R0..R9, OLDR, EDITMACR_HDL, EDITMACR_FILE,
%	DIALOGX, DIALOGY, BORDERX, BORDERY and BORDERB. Plotting to figure is
%	disabled.	
%
%SEE ALSO
%	Uses uigetfile and loadedit. See also evalstr, savestr, loadstr, 
%	makem and maker.
%
%EXAMPLES
%	editmacr;                   % setting up
%	editmacr('a','l','test.r1');% loading 

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 27-Jul-94 Adding macro concept to Matlab.
%	J.Virkkala 23-Dec-94 Name changed from uicedit to editmacr.
%	J.Virkkala 24-Feb-95 Adding button for makem.
%	J.Virkkala  3-Mar-95 Part of ScanUtil.
%	J.Virkkala 28-May-95 Saving and loading with path included.

global R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 OLD_R EDITMACR_HDL EDITMACR_FILE 
global DIALOGX DIALOGY BORDERX BORDERY BORDERB

	% test for figure
eval('get(EDITMACR_HDL,''parent'');','EDITMACR_HDL=0;');

%*** WHEN FIGURE EXIST ***

if ~isempty(EDITMACR_HDL)&EDITMACR_HDL~=0;
	% setting active again or if closed then create
  figure(get(EDITMACR_HDL,'parent'));
  set(gcf,'nextplot','add');	% disable plotting
  
%*** LOADING STRING ***
  if ls=='l'|ls=='m';
    if ls=='l';sts='Load';st='l';else;sts='Merge';st='m';end;
	% loading this page
    if ta=='t';
      if nargin<3; % can be given as parameters
      [f,p]=uigetfile('*.r*',[sts ' page'],DIALOGX,...
           DIALOGY);end;
        if f
           showwait('loading page - %1.0f s');
           if st=='m'
             old0=eval(['R' OLD_R]);
             loadedit([p f],1,eval(OLD_R));
             eval(['R' OLD_R '=str2mat(' old0 ',R,' OLD_R ');']);
           else
             loadedit([p f],1,eval(OLD_R));
           end;
           set(EDITMACR_HDL,'string',eval(['R' OLD_R]));
           showwait('');
        end;
    else
	% loading all pages
      if nargin<3;
        [f,p]=uigetfile('*.r*',[sts ' all - ' ...
        EDITMACR_FILE],DIALOGX,DIALOGY);
      end;
        if f
          set(gcf,'Name',['Macro R0...R9 - ' f]);
          showwait('loading pages - %1.0f s');
          p='';
          if st=='m';
             for i=0:9;is=int2str(i);eval(['old' is '=R' is ';']);end
             loadedit([p f],1);
             for i=0:9;is=int2str(i);eval(['R' is '=str2mat(old' is ...
               ',R' is ');']);end
   		else
             loadedit([p f],1);
          end;
          set(EDITMACR_HDL,'string',eval(['R' OLD_R]));
          EDITMACR_FILE=f;
          showwait('');
         end; 
    end;

%*** SAVING STRING ***          
	% SAVING string
  else
	% whether to write or append
    if ls=='s';sts='Save';st='w';else;sts='Append';st='a';end;
	% one page
    if ta=='t';
      if nargin<3;
       [f,p]=uiputfile('*.r*',[sts ' page'],DIALOGX,...
       DIALOGY);
      end;
        if f;
           showwait('saving page - %1.0f s')
           savestr(putstr(eval(['R' OLD_R]),['%PAGE R' OLD_R]),f,st);
           showwait('')
        end;
    else
	% saving all pages
      if nargin<3;% can be given as parameter
         [f,p]=uiputfile('*.r*',[sts ' all - ' ...
         EDITMACR_FILE],DIALOGX,DIALOGY);
      end;
        if f;
          set(gcf,'Name',['Macro R0...R9 - ' f])
          showwait('saving pages - %1.0f s')
          savestr(putstr(R0,'%PAGE R0'),[p f],st);
          for i=1:9;
            savestr(putstr(eval(['R' int2str(i)]),['%PAGE R' int2str(i)]),...
               [p f],'a');
          end;
          EDITMACR_FILE=f;
          showwait('');
        end;        
    end;
  end;  
else

%*** CREATE EDITMACR FIGURE ***
	% if OLD_R not defined then empty R0...R9
  if isempty(OLD_R);
    EDITMACR_FILE=' ';
%   for i=0:9;
%     eval(['R' int2str(i) '='' '';']);
%   end;
    OLD_R='0';
  end;
	% creating figure with default position
  pos=get(0,'screensize');pos(1)=pos(3)-500-BORDERX;pos(2)=pos(4)-200-2*BORDERY;
  pos(3)=500;pos(4)=200;
  fig=creafig(pos);
  set(fig,'numbertitle','off','name','Macro R0...R9 -');
	% bottom row control buttons
  hdl=uicput('b12bb12be12345e/p12345678pp1234567pp1234567p',5);
  set(hdl(1),'string','Cls','callback','close');
  set(hdl(2),'string','Hlp','callback','uihelp(''editmacr.hlp'');');
	% making m files from strings
  set(hdl(3),'back',[1 1 1],'string','MAKEM','callback',['a' uicval(hdl(3),'string') 'makem(a);']);
	% editing text, background white
  hdl=[hdl;uicontrol('style','edit','min',1,'max',10,'back',...
        [1 1 1],'position',[5 35 490 140],'string',eval(['R' OLD_R]),'horizontala','left')];
%JVIR, HorizontalAligment default was center with Matlab 5.2  
  set(hdl,'units','norm')			% to works with resize
  set(hdl(7),'callback',['eval([''R'' OLD_R ''=get(' o2s(hdl(7)) ....
    ',''''string'''');''])']);
	% callbacks
  set(hdl(4),'string',['this page';'all pages'],'value',2);
  set(hdl(5),'string',['load ';'merge']);
  
  set(hdl(5),'callback',['tmp' uicval(hdl(4)) 'if tmp==1;tmp1=''t''' ...
    ';else;tmp1=''a'';end;tmp' uicval(hdl(5)) 'if tmp==1;tmp2=''l'';else;'... 
    'tmp2=''m'';end;editmacr(tmp1,tmp2)']);
  set(hdl(6),'string',['save  ';'append']);
  set(hdl(6),'callback',['tmp' uicval(hdl(4)) 'if tmp==1;tmp1=''t''' ...
    ';else;tmp1=''a'';end;tmp' uicval(hdl(6)) 'if tmp==1;tmp2=''s'';else;'... 
    'tmp2=''a'';end;editmacr(tmp1,tmp2)']);
	% radiobuttons
  hdl2=uicput('r000rr111rr222rr333rr444rr555rr666rr777rr888rr999r',180);
	% mutually exclusive buttons, switching between Ri and string
  mutexc(hdl2,1,['#2;OLD_R=int2str(tmp-1);set(' o2s(hdl(7)) ,...
  ',''string'', eval([''R'' OLD_R]));']);
	% creating names for R0...R9
  for i=1:10;
    set(hdl2(i),'string',['R' int2str(i-1)]);
  end;
  EDITMACR_HDL=hdl(7);
	% load wanted text
  if nargin==3;
    editmacr(ta,ls,f);
  elseif nargin==2;
    editmacr(ta,ls);
  end;
end;	% disable plotting
%JVIR,
%set(gcf,'nextplot','new');	

%END OF EDITMACR