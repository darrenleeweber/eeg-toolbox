function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega5(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA5 Calculate bands, peaks and means.
%	QEEGA5
%
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999

global H P A PA R
%JVIR, bands like in eeg4ana
%JVIR, any sampling rate not only 250 Hz
low= round([ 6 17 31 58  83 123 201]*250/R);
high=round([16 30 57 82 122 246 209]*250/R);

PA=[];	% delta, theta, alfa and beta
for i=1:4,
  PA=[PA;sum(A(low(i):high(i))) sum(P(low(i):high(i)))];
end
	% sum
PA=[PA;sum(PA)];
	% 20-30
PA=[PA;sum(A(low(5):high(5))) sum(P(low(5):high(5)))];
	% 30-60, 50 hz notch filter
a=sum(A(low(6):high(6)))-sum(A(low(7):high(7)));
p=sum(P(low(6):high(6)))-sum(P(low(7):high(7)));
PA=[PA;a p];
	% max theta-alfa
a=A(low(2):high(3));
p=P(low(2):high(3));
h=H(low(2):high(3));
i=find(a==max(a));
j=find(p==max(p));
PA=[PA;h(i(1)) h(j(1))];
	% mean frequency in theta-alfa
PA=[PA;sum(A(low(2):high(3)).*H(low(2):high(3)))...
	/sum(A(low(2):high(3))) sum(P(low(2):high(3)).*H(low(2)...
	:high(3)))/sum(P(low(2):high(3)))];
	% mean frequency in delta-beta
PA=[PA;sum(A(low(1):high(4)).*H(low(1):high(4)))...
	/sum(A(low(1):high(4))) sum(P(low(1):high(4)).*H(low(1)...
	:high(4)))/sum(P(low(1):high(4)))];
	% alfa/theta
PA=[PA;PA(3,:)./PA(2,:)];
	% alfa/delta
PA=[PA;PA(3,:)./PA(1,:)];
	% alfa/(theta+delta)
PA=[PA;PA(3,:)./(PA(1,:)+PA(2,:))];
	% (alfa+beta)/(theta+delta)
PA=[PA;(PA(3,:)+PA(4,:))./(PA(1,:)+PA(2,:))];

%end of qeega5