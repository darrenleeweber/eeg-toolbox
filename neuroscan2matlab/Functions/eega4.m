function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=eega4(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%EEGA4 Plot spectrum, table
%       EEGA4

%	J.Virkkala 10-Oct-95 fftspect changed.

global y la ot file
claa;          % hanning window, 1/2 overlap
w=(1-cos(2*pi*(1:128)/129))/2;
[p,hz]=fftspect(y,[128 10 0.5 w],[],eval(ot(5,:)));
for i=1:size(p,1);p(i,:)=p(i,:)-mean(p(i,:));end
i=find(hz<50);
plotdata(hz(i),sqrt(p(:,i)),la);
xlabel('f (Hz)');
ylabel('uV');   % one label

