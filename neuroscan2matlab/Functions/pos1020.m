function [pos,label,hdls]=pos1020(label,xyz,points,pointst,outline,z);
%POS1020 Plot scalp electrode positions in XY or XYZ.
%	[POS,LABEL,HDLS]=POS1020(LABEL,XYZ,POINTS,PST,OLINE,Z) Plot EEG 
%	electrodes into current axes. Also return electrodes's xy
%	coordinates, xyz if xyz given.  
%       
%       Xyz, points and oline are boolean whether to print them. Pst is 
%       stylestring for points and z is used with xy option. Returned handles
%       (1,:) is for text, (2,1) for markers and (2,2) for outline curve.
%
%SEE ALSO
%       Map1020.
%
%REFERENCES
%	Principles of neural Science, 3rd edition. Neurosoft manual, 
%       version 3.0.    
%
%EXAMPLES
%	t=0:1/100:1;creafig([0 0 1 1])  % sine signals in electrodes
%	la=['FZ';'O1';'O2';'OZ'];
%	[xy,label,hdls]=pos1020(la,0,1,'x',1,10);
%	title('1020 SYSTEM')
%	[hdl,rhdl]=axes1020(la);        % return axes after plotting
%	for i=1:size(la,1);
% 	  axes(hdl(i));plot(sin(2*t*pi*i));title(la(i,:))
%	end
%	set(rhdl(5),'visible','on');    % common scale
%	set([hdl rhdl(2:5)],'xlim',[1 100],'ylim',[-1 1]);
%	set(hdl,'xticklabels','','yticklabels','');
%	print pos1020 -djpeg	

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  7-Feb-1999 Made room for OZ.
%JVIR,  3-Feb-1999

%       J.Virkkala 9-Aug-94

%JVIR, Adding OZ and EOGL and EOGR
LABELS=str2mat('FP1',...
'FP2',...
'F7',...
'F8',...
'F3',...
'F4',...
'FZ',...
'CZ',...
'A1',...
'A2',...
'T3');
LABELS=str2mat(LABELS,'T4',...
'C3',...
'C4',...
'PZ',...
'P3',...
'P4',...
'T5',...
'T6',...
'O1');
LABELS=str2mat(LABELS,'O2',...
'VEOG',...
'EOG2',...
'EOGL',...
'EOGR',...
'OZ');

%JVIR, electrode position
POSITION=[-0.231        0.538   0.308
0.231   0.538   0.308
-0.615  0.410   0.205
0.615   0.410   0.205
-0.282  0.256   0.744
0.282   0.256   0.744
0.000   0.205   0.949
0.000   0.000   1.000
-1.000  0.026   -0.410
1.000   0.026   -0.410
-0.795  -0.051  0.128
0.795   -0.051  0.128
-0.282  -0.115  0.718
0.282   -0.115  0.718
0.000   -0.308  0.949
-0.282  -0.487  0.436
0.282   -0.487  0.436
-0.538  -0.513  0.051
0.538   -0.513  0.051
-0.255  -0.795  0.026
0.255   -0.795  0.026
-0.231  0.9     0.308
0.231   0.9     0.308
-0.231  0.9     0.308
0.231   0.9     0.308
0  -0.795  0.026
];

%JVIR, -.205 AND 0.205 for O1 and O2
%JVIR, Outline curve

OUTL=[
    0.0000    1.0601
   -0.1753    0.9339
   -0.4257    0.8257
   -0.5326    0.7326
   -0.6661    0.5703
   -0.7462    0.4381
   -0.8030    0.2217
   -0.8264    0.1346
   -1.0000    0.1346
   -1.0023   -0.0968
   -0.8230   -0.0998
   -0.7863   -0.2140
   -0.7162   -0.4124
   -0.5993   -0.6077
   -0.5025   -0.6888
   -0.3022   -0.8270
   -0.1119   -0.9022
    0.0083   -0.9142];

if nargin<6;z=0;end
if nargin<5;outline=0;end
if nargin<4;pointst='x';end
if nargin<3;points=0;end
if nargin<2;xyz=0;end
if nargin<1;label='';end
n=size(label,1);
	% If all wanted
if n==0;index=1:size(POSITION,1);
else;
  index=[];
  for i=1:n;
    row=deblank(label(i,:));
    f=strfind(LABELS,upper(row));
    if isempty(f)
       errorr(['hpw label ' upper(row) ' not found in pos1020'],'pos1020.m')
    else
    	j=1;	% only once every
%JVIR,    while find(f(j,1)==index)&j<size(f,1);j=j+1,end;
	 	if i==1;
      	index=f(j,1);
    	else 
      	index=[index;f(j,1)];end;
    end;
    end  
end;
	% xy or xyz
if ~xyz;pos=POSITION(index,1:2);else;pos=POSITION(index,1:3);end;
	% Label text
label=LABELS(index,:);
if xyz;z=pos(:,3)+z;
else
  z=ones(size(pos(:,2)))*z(1);
end;
	% draw text
hdls=[];
if points;
  hdls(:,1)=text(pos(:,1)-0.01,pos(:,2)-0.025,z,label);
  hold on;
  hdls(1,2)=plot3(pos(:,1),pos(:,2),z,pointst);
end
	% draw outline
if outline;
  x=[OUTL(:,1);-OUTL(18:-1:1,1)];
  y=[OUTL(:,2);OUTL(18:-1:1,2)];
  hdls(2,2)=line(x,y,ones(size(y))*z(1));
end;

%END OF POS1020