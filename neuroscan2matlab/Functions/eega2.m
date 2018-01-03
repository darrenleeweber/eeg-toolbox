function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=eega2(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%EEGA2 Load, plot raw data
%       EEGA2

global x y la ot file S1
[x,y,la,el,ca,ot]=loadcnt(file,S1,1,1024);
claa;
plotdata(x,y,la,[50 50]);
xlabel('t (s)');
ylabel('division 100 uV');
title(file);

