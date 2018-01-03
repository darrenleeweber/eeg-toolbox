function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega2(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA2 Calculating spectrum and showing raw data.
% 	QEEGA2(I1) If parameter given uses global y as input.
%

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  4-Feb-1999 Sampling rate can vary!

global HDL R S EL X0 H P2 A2 Y S1 S2 S3 S4 S5 S6 S7
name=get(get(HDL,'parent'),'name');
file=name(1:find(name==setstr(9))-1);
	% figure for data
creafig([0 0 1 1],'name','QEEG1, raw data','numbertitle','off');
set(gcf,'paperposition',[1 1 18 28]);
h=uicsetup('QEEGA.HL2',1,'/b12b');
set(h(3),'string','Prn','callback','print');
	% what channels used
elec=['T6';'O2';'T5';'O1';'C4';'P4';'C3';'P3';'F4';'C4';'F3';'C3'];
	% reading from axes or test signal
if nargin==0,
  u=get(HDL,'userdata');
  X0=u(:,1);
else X0=[0 0 0 0]';end
	% create derived labels
la=EL;   
EL=[];
elect=[];
%for j=1:2:11,
for j=2:7,
   r=eval(['S' int2str(j)])
   if length(r)>1
      elec=putstr(la(r(1),:),elec);
      elec=putstr(la(r(2),:),elec);
      EL=putstr([deblanks(la(r(1),:)) '-' deblanks(la(r(2),:)) ' '],EL);
   else
      EL=putstr(deblanks(la(r(1),:)),EL);
      elec=putstr(la(r(1),:),elec);
      elec=putstr(la(r(1),:),elec);
   end
end;
el=EL;
	% window and coefficent for 1/2 true amplitude
w=hanning(1024);
c=norm(w)/sum(w);
%c=2*norm(w)/sum(w);
%FOR CORRECT PEAK 2* BUT NOW 1*

%*** THROUGH 4 SECTIONS ***
showwait('loading sections - %1.0f');
P2=[];A2=[];
%JVIR, P2=zeros(6,249*250/R+1);A2=zeros(6,249);
for i=1:4,
  x1=X0(i)*R;
  if x1>S-2047,
    errorr('hpw Selection to end of data.','QEEGA');
    x1=S-2047-1;
  end
  x2=x1+2047;
	% loading data or test signal
  if nargin==0,
       [x,y,pa]=loadcnt(file,elec,x1,x2);
  else	% using global y, see R8 for testin
       x=(0:2047)/R;
  end
  Y=[];
  for j=1:2:11,
%JVIR     
     if y(j,:)==y(j+1,:),
        Y=[Y;y(j,:)];
     else
        Y=[Y;y(j,:)-y(j+1,:)];
     end
  end;
	% calculating spectrum
  [H,P,A]=fftspect(Y(1:6,:),R,[0 61],[1024 3 0.5],w);
  P=P*c^2;A=A*c;
  if isempty(P2),P2=P;else,P2=P2+P;end
  if isempty(A2),A2=A;else,A2=A2+A;end
	% read eye movements or test signal
  if nargin==0,
   %JVIR, [x,y,pa]=loadcnt(file,['EOG2';'VEOG'],x1,x2);
    [x,y,pa]=loadcnt(file,str2mat(la(S1(1),:),la(S1(2),:)),x1,x2);%['EOGR';'EOGL'],x1,x2);
   Y=[Y;y];
    el=str2mat(EL,[' ' deblank(pa(1,:))],[' ' deblank(pa(2,:))]);
	% plotting data
  end
  a=axes;
  set(a,'position',[0.15 0.24*i-.20 0.80 0.2]);
  plotdata(x,Y,el,[25 25]);
  if i==4,
    ylabel('division 50 uV');
  end
  xlabel('t (s)');
  drawnow;
end
P2=P2/4;A2=A2/4;
	% end of all axes
showwait('');
figtext(name);

%end of qeega2