function w=hanning(i)
w=(1-cos(2*pi*(1:i)/(i+1)))/2;
w=w(:);