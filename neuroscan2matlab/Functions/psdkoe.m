x=sin(1:1024)+(rand(1:1024)-0.5)*10;
[Pxx, Pxxc, F] = PSD(x,[],[],[],0,0.95);
plot(F,Pxx,'-',F,Pxxc,'+');