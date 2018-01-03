function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega4(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA4 Creating axes.
%	QEEGA4

%JVIR,Jussi.Virkkala@occuphealth.fi
%JVIR,23-Feb-1999 Reduced width of 
%JVIR, 4-Feb-1999 

	% define axes
h(1)=axes;
set(h(1),'position',[0.06 0.47 0.90 0.47]) % [0.03 0.47 0.97 0.50]
h(5)=axes;
set(h(5),'position',[0.07 0.07 0.26 0.14])
h(6)=axes;
set(h(6),'position',[0.40 0.07 0.26 0.14])
h(7)=axes;
set(h(7),'position',[0.73 0.07 0.26 0.14])
h(2)=axes;
set(h(2),'position',[0.07 0.27 0.26 0.14])
h(3)=axes;
set(h(3),'position',[0.40 0.27 0.26 0.14])
h(4)=axes;
set(h(4),'position',[0.73 0.27 0.26 0.14])
o1=h;

%END OF R4
