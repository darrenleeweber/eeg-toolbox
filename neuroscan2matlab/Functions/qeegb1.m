function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega1(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA1 Creating sELection figure.	
%	HDL=QEEGA1(NAME) Returns handle for axes.
%
%DIAGNOSTIC
%	Used global variables HDL, NAME, S, and R.

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  8-Feb-1999 ELectrode sELection
%JVIR,  4-Feb-1999 

global HDL NAME CA S R EL S1 S2 S3 S4 S5 S6 S7
	% what file
   
close all
uihelp('qeega.hl1')   
HF=[];HDL=[];
disp(' ');
disp('  QEEGA Analysis, ver         : 8-Feb-1999')
if nargin==0,
   
name=input('  Give continuous file        : ','s');
  if isempty(name),[name p]=uigetfile('*.cnt','Give continuous file');name=[p name];end  
else
  if i1==1,i1=NAME;end
  disp(sprintf('  Continuous file is          : %s',i1));
  name=i1;
end
if exist(name)~=2,
  errorr('hff File not found from path','QEEGA');
  showwait([]);return
end
load qeega1
[x,y,EL,ca,c1,o1]=loadcnt(name,'',1,1);
h1=selelec(EL,1);
selelec('',S1);
set(gcf,'name','S0 Scrolling selection');
h2=selelec(EL,2);
selelec('',S2);
set(gcf,'name','S1 Spectrum 1');
h2=selelec(EL,3);
selelec('',S3);
set(gcf,'name','S2 Spectrum 2');
h2=selelec(EL,4);
selelec('',S4);
set(gcf,'name','S3 Spectrum 3');
h2=selelec(EL,5);
selelec('',S5);
set(gcf,'name','S4 Spectrum 4');
h2=selelec(EL,6);
selelec('',S6);
set(gcf,'name','S5 Spectrum 5');
h2=selelec(EL,7);
selelec('',S7);
set(gcf,'name','S6 Spectrum 6');

uihelp('QEEGA.HL1')
	% which channELs for sELection
   %SELN=str2mat('FZ','EOG2','VEOG');
	% loading parameters, data
%JVIR,   showwait('loading data - %1.0f')
creafig([0 0.7 1 0.3],'name','QEEGA, range','numbertitle','off');
[x,y,EL,ca,c1,o1]=loadcnt(name,'',1,1);
S=eval(o1(6,:));
R=eval(o1(5,:));
disp(sprintf('  Creation date MM/DD/YY      : %s',o1(2,:)));
disp(sprintf('  Creation time HH/MM/SS      : %s',o1(3,:)));
disp(sprintf('  Sampling rate               : %i',R));
%JVIR, increases form 100000 to 150000
if S>150000,
%JVIR,  showwait([]);
  errorr('hpw Filesize too large to continue','QEEGA1');
  return
end
	% selection figure
SELN=str2mat(EL(S1,:));%JVIR, 'FZ','EOGR','EOGL');
SELN
[x,y,la,ca,c1,o1]=loadcnt(name,SELN,1,S);
plotdata(x,y,la,[50 50],50);
CA=gca;

xlabel('t (s)')
	% 10 s window
uiscroll([],10,1);
	% return axes handle
HDL=getband(floor((S/R))-12:floor(S/R)-9,8);
h=uicput('b12345b/b1234bb12bb12bb12b',-20);
set(h(1),'string','Close all','callback','close all');
	% in makem one evalstr in one row
   set(h(2),'string','Again','callback','global NAME S1 S2 S3 S4 S5 S6 S7;save qeega1 S1 S2 S3 S4 S5 S6 S7;close all;qeega1(NAME);');
set(h(3),'string','Cal','callback',['global HDL;HDL=' o2s(HDL) ';qeega2;qeega3;']);
set(h(4),'string','Hlp','callback','uihelp(''QEEGA.HL1'')');
set(h(5),'string','Prn','callback','print');
	% change print options
set(gcf,'PaperP',[1 5 27 8],'PaperOr','lands');
NAME=name;
name=[name setstr(9) o1(2,:)];		
set(gcf,'name',name);
figtext(name);
%JVIR, showwait('');
o1=HDL;