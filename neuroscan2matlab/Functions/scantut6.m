function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=scantut6(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
global x y la ot
creafigs(1)
plotdata(x,y,la,[50 50]);
title('EEG from testec.cnt');
xlabel('t (s)');
ylabel('division 100 uV');

creafigs(1)
[hz,p,a]=fftspect(y,eval(ot(5,:)),[0 10 20 30],[128 10 0.5],...
         hanning(128));
pos1020(la,0,1,'.',1,10);
[h rh]=axes1020(la);
for i=1:size(la,1);
  axes(h(i));plot(hz,a(i,:))
end
set([h rh(4)],'xlim',[0 30],'ylim',[0 30])
set(h,'xticklabels',[],'yticklabels',[]);
set(rh(4),'visible','on');
axes(rh(4));xlabel('f (Hz)');ylabel('Amplitude (uV)');

