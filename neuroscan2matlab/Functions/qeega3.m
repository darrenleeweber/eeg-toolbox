function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega3(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA3 Plotting FFT and derived parameters.
%	QEEGA3
%
%SEE ALSO
%	Uses convtext.

%JVIR,25-Feb-1999 Changed hz into Hz.
%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR, 4-Feb-1999 

global X0 HDL EL H P2 A2 P A PA PAA R4 R5 th
name=get(get(HDL,'parent'),'name');

creafig([0 0 1 1],'name','QEEGA, FFT analysis','numbertitle','off');
set(gcf,'paperposition',[1 1 18 28]);

PAA=[];
ax=qeega4;
for i=1:6,
  axes(ax(i+1));
  P=P2(i,:);
  A=A2(i,:);
	% calculation bands
  qeega5
  PAA=[PAA PA];
  plot(H,P);
  title(EL(i,:))
	%plot each subplot
  set(gca,'xlim',[0 20],'ylim',[0.01 200]);%JVIR, 7.5])
  h=plotband([1.5 4.2 7.6 14.1 20],[],[0.01 100 0.3 0.2],':'...
	,'%1.1f');
  set(gca,'yscale','log');
	%JVIR, added ticks  
  set(gca,'ytick',[0.01 .1 1 10 100])
  set(h(find(h(:,1)~=0)),'color',[1 1 1]);
  if i==1|i==4,
     ylabel('uV^2');
  end
  if i>3,
    xlabel('f (Hz)');
  else
    set(gca,'xticklabels',[]);
 end
end
	% plot numerical values
s=size(PAA)+[1 0];
PAA(s(1),s(2))=0;
PAA(s(1),1:4)=X0';
figtext(strrep(name,'\',':'));
axes(ax(1));
th=plottext('QEEGA.PLT',PAA);
h=uicsetup('QEEGA.HL3',1,'/b12bb12bb12b');
com=['#1j<2|i==2#2''horizontala'',''left''#3#1j==3#2''position'','...
     '[x+45 y]#3;'];com=strrep(com,'''','''''');
set(h(3),'string','New','callback','close all;qeega1;');
set(h(4),'string','Prn','callback','printdlg(gcf);');
set(h(5),'string','Dat','callback',['showwait(''Appending data into Results\\qeega.txt'')'...
	';global PAA NAME HDL;a=[];for i=1:2:11,a=[a;PAA(1:15,[i i+1])];'...
	'end;a=a'';a=a(:);row=[get(get(HDL,''par''),''name'')  sprintf('...
	'''#%1.5f'',a)];row=strrep(row,''#'',setstr(9));'...
	'savestr(row,''Results\qeega.txt'',''a'');pause(1);'... % disptype Results\qeega.txt;pause(1);
	'showwait([]);']);
o1=th;

%end of qeega3