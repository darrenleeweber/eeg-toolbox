function [va,text,data,style]=scanelec(var,elec,filen,dataw);
%SCANELEC Electrode specific part of the NeuroScan header.
%	[VA,TEXT,DATA,STYLE]=SCANELEC(VAR,ELEC,FILEN,DATAW) Variable names, 
%	helptext, data from filen and stylestring for fread are returned.
%
%	In va text "ELECTRODE begins and ends electrode fields. Those 
%	fields are returned for 1..elec. If var=[], all fields and elec=[] 
%	all electrodes. If dataw is given dataw is written to file.
%
%DIAGNOSTICS
%	Writing only to existing files. If filen is changed remove 
%	file.mat for new calibration values.
%
%SEE ALSO
%	Uses scanhead, putstr, fpos. See also scaneven, loadcnt.
%
%EXAMPLES
%	[v,t]=scanelec([]);     % list of all variables
%	subplot(211);plottext(v);
%	                        % load 5 first channels
%	[v1,t1,data,st]=scanelec(['lab  ';'basel';'sensi'],5,...
%	   'testec.cnt');
%	subplot(212);plottext(tiestr(['=';'{';'}'],v1,data,t1));

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 27-Jun-94
%	J.Virkkala 29-Dec-94
%	J.Virkkala  3-Mar-95 Part of ScanUtil.


%*** DEFINING TABLES***
ELECTRODES_SIZE=[10
5
2
30
2
10
4
8
4];

ELECTRODES_FREAD=str2mat('char',...
'char',...
'short',...
'char',...
'short',...
'char',...
'float',...
'char',...
'float');

ELECTRODES_VAR=str2mat('lab',...
'reserved1',...
'n',...
'reserved2',...
'baseline',...
'reserved3',...
'sensitivity',...
'reserved4',...
'calib');

ELECTRODES_TEXT=str2mat('Electrode label - last byte contains NULL',...
'*',...
'observations at each electrode',...
'*',...
'baseline offset in raw ad units',...
'*',...
'channel sensitivity',...
'*',...
'calibration coefficient');

%*** DEFINING VARIABLES ***
va='';
text='';
style='';
data=[];
length=sum(ELECTRODES_SIZE);

%*** PREPARING ****
			% reading from file
if nargin>2;
  [a,a,header]=scanhead(str2mat('nchannels','elect_pos'),filen); 
  nchannels=eval(header(1,:));
  pos0=eval(header(2,:));
end;

			% how many electrodes
if nargin>0,
  if nargin>1,
    if size(elec)==[0,0],elec=nchannels;end
    if nargin>2;
      if isstr(filen),
        if nargin>3,		% reading or writing
          file=fopen(filen,'w','l');
        else
          file=fopen(filen,'r','l');     
      end,else
        file=filen;     
      end;  
      if file==-1,errorr('hff','scanelec');break;end
    else;elec=1;end;
  else;elec=1;end;
else;elec=1;var='';end;
%JVIR,
%end;

	% if all wanted
if size(var)==[0 0];var=ELECTRODES_VAR;end;
	% separating text is "ELECTRODE
pos1=strfind(var,'"ELECTRODE');
	% which part is for comments and repeated text
if size(pos1,1)<2;pos1=[0;size(var,1)+1];end;
	% comment text
if pos1(1,1)>1;
   s=pos1(1,1)-1;
   va=var(1:s,:);
   text(s,1)=' ';
   data(s,1)=' ';      
end;
	% repeat 'variable' for each electrode
repeat=var(pos1(1,1)+1:pos1(2,1)-1,:);
	% searching done only once
n=size(repeat,1); found_var(1,2)=0;
	% found_var, variable and it's position
for i=1:n;tmp=strfind(ELECTRODES_VAR,deblank(repeat(i,:)));
  if isempty(tmp);tmp=0;end;found_var(i,1)=tmp(1,1);
  found_var(i,2)=sum(ELECTRODES_SIZE(1:tmp-1));
end;
%JVIR,
%end;

%*** REPEATING FOR EACH ELECTRODE ****
for i=1:elec;
va=putstr(['"ELECTRODE ',int2str(i)],va);
text=putstr(' ',text);
if nargin>2,data=putstr(' ',data);
  else;data(size(data,1)+1,1)=0;end;
if nargout>3;style=putstr(' ',style);end;
for j=1:size(repeat,1);
  row=repeat(j,:);
	% finds variable
  if size(found_var(j,:),1)>0&found_var(j,1)>0;
    var_pos=found_var(j,1);
% where found
    style_numb=deblank(ELECTRODES_FREAD(var_pos,:));
    var_length=ELECTRODES_SIZE(var_pos);
    va=str2mat(va,ELECTRODES_VAR(var_pos,:));
    text=str2mat(text,ELECTRODES_TEXT(var_pos,:));
    if nargin>2;
% if filehandle given
      pos=pos0+(i-1)*length+found_var(j,2);
      fpos(file,pos);
% writing to file, fprintf for characters and fwrite for numbers
      if nargin>3;	% if writing
        pos2=(i-1)*(size(repeat,1)+1)+j+pos1(1,1)+1;
        row=dataw(pos2,:);
        if strcmp(style_numb,'char');
          if size(row)<var_length,row(1,var_length)=' ';
            else if size(row)>var_length;row=row(1,1:var_length);end;end;
          fprintf(file,'%c',row);
        else;
          value=eval(row);
          fwrite(file,value,style_numb);
        end;
      else;		% if reading
% reading from file, scanf for characters and fread for numbers
        if strcmp(style_numb,'char');
          row=fscanf(file,'%c',var_length);
        else       
% if style is pos then returning file position, electrodes, events
          if findstr(style_numb,['double','float']);st='%1.10g';
             else st='%1.0f';end;
          row=sprintf(st,fread(file,1,style_numb)); 
        end;
        data=str2mat(data,row);
      end; % file
    else;
      data(size(data,1)+1,1)=ELECTRODES_SIZE(var_pos);
    end; %not file, nargin >2
    if nargout>3;style=str2mat(style,style_numb);end;
  else; 		% not variable, if size(a,1)>0
    va=str2mat(va,row);
    text=str2mat(text,'');
    if nargin>2;data=str2mat(data,'');
      else;data(size(data,1)+1,1)=ELECTRODES_SIZE(var_pos);end;
    if nargout>3;style=str2mat(style,'');end;
  end;
end;
end; 			% i, electrodes
 
if nargin>3;data=dataw;end;

%END OF SCANELEC