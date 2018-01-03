function [hz,pow,amp,ahz,a1,a2]=fftspect(y,rate,limits,type,window);
%FFTSPECT Calculate power and amplitude spectrum using FFT.
%	[HZ,POW,AMP,AHZ,A1,A2]=FFTSPECT(Y,RATE,LIMITS,TYPE,WINDOW) Rows
%	of different data. pow power spectrum density, rate is sampling
%	rate (Hz). If limits [] then [0 rate/2]. With [h1 h2 h3] a1 has
%	powerspectrum sum  between h1...h2 and h2...h3. ah gives actual
%	range (Hz) and amp amplitude spectrum and a2 sum of amplitude
%	spectrum.
%	
%	type=[N n o] defines n*N samples with o*100 % overlapping which are
%	averaged for analysis. If n*N too big for data then zeropad. Window
%	is vector of size N, used before fft and averaging. Mean from data
%	is removed before analysis. 
%
%DIAGNOSTICS
%	To get correct amplitude multiple $2 norm(w)/sum(w)$, where w is
%	window.
%
%REFERENCES
%	Signal processing toolbox 3.0, 1-67 \cite{sp3}.
%
%SEE ALSO
%	Uses fft. Used by qeega. See also psd, spectrum from signal processing
%	toolbox.
%
%EXAMPLES
%	t=0:0.001:1.023;                % defined signal
%	y=10*sin(2*pi*50*t)+15*sin(2*pi*120*t)+20*randn(size(t));
%	hb=[0 100 200 300];              % analyze
%	run=[...
%	'subplot(311);plot(t(1:100),y(1:100));title(''signal'');'...
%	'subplot(312);plot(h,log10(po));title(''power (dB)'');'...
%	'set(gca,''ylim'',[min(log10(po)) max(log10(po))]);'...
%	'plotband(ah,a1);subplot(313);plot(h,2*am*norm(w)/sum(w));'...
%	'plotband(ah,2*a2*norm(w)/sum(w));'];
%	run=run';run=run(:)';
%	f=1000;l1=1024;l2=256;		% with window
%	figure;w=ones(l1,1);[h,po,am,ah,a1,a2]=fftspect(y,f,hb,...
%	[l1 1 0],'');eval(run);title('amplitude, 1*1024');
%	figure;w=hanning(l1);[h,po,am,ah,a1,a2]=fftspect(y,f,hb,...
%	[l1 1 0],w);;eval(run);title('amplitude, hanning');
%	figure;w=hanning(l2);[h,po,am,ah,a1,a2]=fftspect(y,f,hb,...
%	[l2 7 0.5],w);eval(run);
%	title('amplitude, 50 % overlap hanning');
%	print Help\fftspect -djpeg
%					% test with psd, sp 3.0
%	y=randn(1,32);y=y-mean(y);
%	[p1,h1]=psd(y,32,100);
%	[h2,p2]=fftspect(y,100,[],[32 1 0],hanning(32));
%	[h1 p1 [0 0;h2' p2']]

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 15-Aug-94
%	J.Virkkala  6-Dec-94
%	J.Virkkala 23-Dec-94 Making faster.
%	J.Virkkala 28-Feb-95 Correcting coefficents.
%	J.Virkkala  3-Mar-95 Part of ScanUtil.
%	J.Virkkala 25-May-95 Detrend from signal tbx replaced by -mean.

	% rows are data
s=size(y);
if s(1)>s(2),y=y';end
	% Default N 1 0	
if nargin<4;type=[];end
if isempty(type),
  type=[size(y,2) 1 0];
end;
if type(1)/2~=floor(type(1)/2),type(1)=type(1)-1;end
N=type(1);
type=type(:);
if size(type,1)<2;type=[type 1 0];
  elseif size(type,1)<3;type=[type 0];
end;
	% default options
if nargin<5;window=[];end;
if isempty(window);window=ones(N,1);end;
window=window(:);
	% to Nyqvist limit
if nargin<3;limits='';end;
if size(limits(:),1)==1;limits=[0 limits];end;
if isempty(limits);limits=[0 rate/2];end;
limits=limits(:)';	
	% highest frequency in hertz and pows
upper_hz=limits(size(limits,2));
limits=limits';
%*** ANALYSIS PART DONE IN COLUMNS ***
y=y';
	% for many rows in y should be
length=N+(type(2)-1)*N*(1-type(3));
	% if enough data N1=N otherwise zeropadding
if length>size(y,1);
  e=size(y,1)/type(2);
  window(e:N,1)=zeros(size((e:N)'));
  for r=1:type(2);
    y_tmp=y(floor(1+(r-1)*e:r*e),:);
    y_tmp=[y_tmp;zeros(N-size(y_tmp,1),size(y,2))];
    if r==1;y_new=y_tmp;else;y_new=[y_new;y_tmp];end; 
  end;
  y=y_new;
end;
a=window(:)';
	% in vectorized form too much memory
for i=2:size(y,2),	
  a=[a;window(:)'];
end
window=a';
n=size(y,1);
pow=zeros(N/2,size(y,2));
amp=zeros(size(pow));
s=N*(1-type(3));
	% repeats fft
for r=1:type(2);
	% right part
  y_tmp=y(floor(1+(r-1)*s:N+(r-1)*s),:);
	% -MEAN AND WINDOW, DATA IN COLUMNS
  y_tmp=(y_tmp-ones(size(y_tmp,1),1)*mean(y_tmp)).*window;
  f=fft(y_tmp,N);
  f=f(2:N/2+1,:);
  amp=amp+abs(f);
  pow=pow+f.*conj(f);
end;

%*** COEFFICENTS SIGNAL PROCESSING TOOLBOX, 1-67 ***

pow=pow/(type(2)*norm(window(:,1))^2);	% power
amp=amp/(type(2)*norm(window(:,1)));	% amplitude
	% only to upper_hertz data returned
hz_div=(rate/2)/(N/2);
hz=hz_div:hz_div:upper_hz;
pow=pow(find(hz<=upper_hz),:);
amp=amp(find(hz<=upper_hz),:);

	% calculate frequency borders and area
for i=1:size(limits,1)-1;
  pos=find(hz<=limits(i+1)&hz>=limits(i));
  ahz(i)=hz_div*pos(1);  
  a1(:,i)=sum(pow(pos,:))';			% power
  a2(:,i)=sum(amp(pos,:))';			% amplitude
end;
	% from columns back to rows;
ahz(i+1)=limits(i+1);
%*** RETURN DATA INTO ROWS ***
pow=pow';
amp=amp';

%END OF FFTSPEC