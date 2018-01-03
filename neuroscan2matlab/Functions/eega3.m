function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=eega3(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%EEGA3 Plot spectrum, 1020
%       EEGA3

%	J.Virkkala 10-Oct-95 fftspect changed.

global y la ot file
claa;          % hanning window, 1/2 overlap
w=(1-cos(2*pi*(1:128)/129))/2;
[hz,p,a]=fftspect(y,eval(ot(5,:)),[],[128 10 0.5],w);
pos1020(la,0,1,'.',1,10);
[h rh]=axes1020(la);
for i=1:length(h);
  set(gcf,'currenta',h(i));
  plot(hz,a(i,:));
end             % axes for electrodes
i=1:max(find(hz<50));
set(rh(4),'visible','on');
set([h rh(4)],'xlim',[0 50],'ylim',...
  [0 sqrt(max(max(p(:,i)')))]);
set(h,'xticklabels','','yticklabels','');
set(gcf,'currentaxes',rh(4));
xlabel('f (Hz)');
ylabel('uV');   % one label

