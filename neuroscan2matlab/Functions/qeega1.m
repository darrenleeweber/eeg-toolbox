function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega1(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA1 Creating selection figure for qEEGa.	
%	HDL=QEEGA1(NAME) Returns handle for axes. Reads and plots electrodes
%  'FZ','EOGL','EOGL'. To change these edit qeega1, qeega2 and pos1020. Changed
%	
%DIAGNOSTIC
%	Used global variables HDL, NAME, S, and R.

%JVIR, 8-Apr-1999 Changed EOG position
%JVIR,23-Feb-1999 Changed scrolling, corrected labels.
%JVIR, 8-Feb-1999 Electrode selection in qEEGb version
%JVIR,Jussi.Virkkala@occuphealth.fi

global HDL NAME S R EL EOG

%*** CHANGE HERE NAMES OF TWO EOG CHANNEL NAMES ***
%
EOG=str2mat('EOGL','EOGR');
%

close all
uihelp('qeega.hl1')   
HF=[];HDL=[];
disp(' ');
disp('  qEEGa Analysis, ver         :  8-Apr-1999 Corrected warnings, changed EOG')
disp('                              :  4-Mar-1999 Print Dialog option')
disp('                              :  9-Feb-1999 version for PCWIN Matlab 5.2')

if nargin==0,   
	name=input('  Give continuous file        : ','s');
	if isempty(name),
		[name p]=uigetfile('*.cnt','Give continuous file');name=[p name];
	else
	 	if ~isempty(findstr(name,'*')),
         [name p]=uigetfile(name,'Give continuous file');name=[p name];
      end
   end
else
   if i1==1,
      i1=NAME;
   end
	disp(sprintf('  Continuous file is          : %s',i1));
	name=i1;
  	findstr(name,'*')
	if exist(name)~=2,
	  errorr('hff File not found from path','QEEGA');
	  showwait([]);return
	end
end
[x,y,EL,ca,c1,o1]=loadcnt(name,'',1,1);
uihelp('QEEGA.HL1')
	% which channels for selection, atleast 3
SELN=str2mat('FZ',EOG);
	% loading parameters, data
creafig([0 0.7 1 0.3],'name','QEEGA, range','numbertitle','off');
[x,y,EL,ca,c1,o1]=loadcnt(name,'',1,1);
S=eval(o1(6,:));
R=eval(o1(5,:));
disp(sprintf('  Creation date MM/DD/YY      : %s',o1(2,:)));
disp(sprintf('  Creation time HH/MM/SS      : %s',o1(3,:)));
disp(sprintf('  Sampling rate               : %i',R));
%JVIR, increases form 100000 to 150000 and to 200000
if S>200000,
  errorr('hpw Filesize too large to continue','QEEGA1');
  return
end
	%selection figure, all data
[x,y,la,ca,c1,o1]=loadcnt(name,SELN,1,S);
plotdata(x,y,la,[50 50],50);
xlabel('t (s)');
	%20 s window, used to be 10 s
uiscroll([],20,1);
	%return axes handle
HDL=getband(floor((S/R))-12:floor(S/R)-9,8);
h=uicput('b12345b/b12bb12bb12b',-20);
set(h(1),'string','Close all','callback','close all');
	%in makem one evalstr in one row
set(h(2),'string','Cal','callback',['global HDL;HDL=' o2s(HDL) ';qeega2;a=gcf;qeega3;figure(a);']);
set(h(3),'string','Hlp','callback','uihelp(''QEEGA.HL1'')');
set(h(4),'string','Prn','callback','printdlg(gcf)'); 
	%change print options
set(gcf,'PaperP',[1 5 27 8],'PaperOr','lands');
NAME=name;
name=[name setstr(9) o1(2,:)];
	%replacing forbidden / with : which exist in some dates
set(gcf,'name',name);
figtext(strrep(name,'\',':'));
o1=HDL;

%end of qeega1