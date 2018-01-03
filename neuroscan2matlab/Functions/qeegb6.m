function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega6(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA6 Create test signal analysis
%	QEEGA6

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  4-Feb-1999 

global HDL NAME R R2 R3 y

R=250;
NAME=['TEST 4,8,10&14,14&16,14,16' setstr(9) 'TEST'];
creafig([0 0 0.1 0.1],'name',NAME);
HDL=axes;
t=(0:2047)/R;
y=zeros(12,2048);

y(1,:)= 10*sin(2*pi*4.*t);	% T6-O2
y(3,:)= 10*sin(2*pi*8.*t);	% T5-O1
				% C4-P4
y(5,:)= 10*sin(2*pi*10.*t)+10*sin(2*pi*14.*t);
				% C3-P3
y(7,:)= 10*sin(2*pi*12.*t)+10*sin(2*pi*16.*t);	
y(9,:)= 10*sin(2*pi*14.*t);	% F4-C4
y(11,:)=10*sin(2*pi*16.*t);	% F3-C3	
%y=y+randn(size(y));    % little noise
 y=y+2*randn(size(y));  % more noise

qeega2(1)	% so it is test signal
qeega3

%qeega6