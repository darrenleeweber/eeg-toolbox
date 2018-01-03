function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=eega1(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%EEGA1 Ask for EEG file, create figures.
%        EEGA1(file)
       
%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  4-Feb-1999 Modified for PCWIN Matlab 5.2.

global file la S1
if nargin==0,	% asking from keyboard
  file=input('  Give file for eega: ','s');
  if isempty(file),
    [file p]=uigetfile('*.cnt','Give file for eega'),
 	 if file==0,return,end;
	 file=[p file];
  end
else
  file=i1;
end            % using uigetfile

for i=1:2,     % creating analyses figures
  creafig(2+i);
  set(gcf,'name',file,'numbertitle','off');
  h=uicsetup('eega',3,'P%1.0f %s','b123b');
  set(h(5),'string','Prn','callback','print');
end           % create selection figure
[x,y,la]=loadcnt(file,[],1,1);
selelec(la,1);
S1=selelec('',1:size(la,1));
