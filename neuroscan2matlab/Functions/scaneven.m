function [va,text,data,style,ele]=scaneven(var,events,filen,dataw);
%SCANEVEN Eventtable of NeuroScan file.
%	[VA,TEXT,DATA,STYLE,ELE]=SCANEVEN(VAR,EVENTS,FILEN,DATAW) Variable 
%	names, helptext, data from file and stylestrings for fread are
%	returned. Extra record is data position (*) where sweep's position
%	is in points.
%
%	In var text "EVENT  begin and end events fields. Those fields are 
%	returned for 1..events. If var=[], then all fields and events=[] all
%	events are returned. If dataw is given data is written to  file. 
%
%	Fourth returned parameter E is a matrice with columns evaluated from
%	var. If only file given, [ele]=scaneven(filen) where ele=['Stim'
%	'posi']. Ele is saved into mat like oth, from scanelec.
%
%DIAGNOSTICS
%	Writing works only into existing files, use to change copies of old
%	files. If file is changed remove file.mat for new events. There are
%	two different length of event types. Used global variable is DIRS.
%
%LIMITATIONS
%	Reading all events is too slow to do online. Use batch to do it
%	overnight or write more spesific scaneven, or mex file. First time 
%	command ele=scaneven('testp3.cnt') takes 30 min! 
%
%SEE ALSO
%	Uses scanhead, putstr, fpos. See also scanelec, loadcnt.
%
%EXAMPLES
%	[v1,t1]=scaneven([],[]);  % list of all variables
%	subplot(211);plottext(v1);
%	                        % load 5 first events
%	[v,t,d]=scaneven([],5,'testp3.cnt');
%	subplot(212);plottext(tiestr(['=';'{';'}'],v,d,t));
%	                        % load all events 
%	[ele]=scanevent('testp3.cnt')
%	                        % calculate two averages
%	s=[-0.1 0.9];r=250;el=[];[x,y,el]=loadcnt('testp3.cnt',...
%	el,1,2);s=s(1)*r:s(2)*r;y11=zeros(size(el,1),size(s,2));
%	y12=y11;y21=y11;y22=y11;n1=0;n2=0;
%	for i=1:size(ele,1),et=ele(i,1);x=ele(i,2);
%	  disp(sprintf('event %3.0f/%3.0f type %1.0f at %3.1f s',...
%	  i,size(ele,1),et,x/r));
%	  [x,y,el]=loadcnt('testp3.cnt',el,x+min(s),x+max(s));
%	  if et==1,n1=n1+1;     % show events
%	  if i/2==floor(i/2),y11=y11+y; else y12=y12+y;end
%	  else,n2=n2+1;
%	  if i/2==floor(i/2),y21=y21+y; else y22=y22+y;end
%	end
%	end;y11=y11/n1;y12=y12/n1;y21=y21/n2;y22=y22/n2;
%	x=1000*s/r;save testp3a x y11 y12 y21 y22 el n1 n2
%	                        % load data ans plot figure
%	load testp3a
%	f1=creafigs(1);title('event 1');f2=creafigs(1);
%	title('event 2');set([f1 f2],'defaulttextfontsize',8);
%	figure(f1);pos1020(el,0,1,'.',1,10);a1=axes1020(el);
%	figure(f2);pos1020(el,0,1,'x',1,10);a2=axes1020(el);
%	for i=1:size(el,1);
%	  axes(a1(i));plot(x,-y11(i,:),x,-y12(i,:));title(el(i,:));
%	  axes(a2(i));plot(x,-y21(i,:),x,-y22(i,:));title(el(i,:));
%	end;set([a1 a2],'xlim',[-100 500],'xtick',[-100 100 400]);

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 30-Jun-94
%	J.Virkkala 21-Nov-94
%	J.Virkkala 21-Feb-95 Using file.mat for slow loading parameters.
%	J.Virkkala 22-Feb-95 Parameter can text or fid.
%	J.Virkkala  3-Mar-95 Part of ScanUtil.

global DIRS kukkuu kakkuu

%*** DEFINING TABLES***
EVENTS_SIZE=[2
1
1
4
0
2
2
4
1
1
1];

EVENTS_FREAD=str2mat('short',...
'int8',...
'int8',...
'ulong',...
'calc',...
'short',...
'short',...
'float',...
'char',...
'char',...
'char');

EVENTS_VAR=str2mat('StimType',...
'KeyBoard',...
'KeyPad/Accept',...
'Offset',...
'position',....
'Type',...
'Code',...
'Latency',...
'EpochEvent',...
'Accept',...
'Accuracy');

EVENTS_TEXT=str2mat('range 0-65535',...
'0-11 corresponding to function keys+1',...
'response bad values/0xd=Accept, 0xc=Reject',...
'file offset of event',...
'int2str((to-900)/2/nc-75/2);%data position (*)',...
'-',...
'-',...
'-',...
'-',...
'-',...
'-');
%end;

%*** DEFINING VARIABLES ***
va='';
text='';
style='';
data=[];

%*** PREPARING ****
	% reading from file

if nargin==1,			% Stim,Offs and posi fast
%*** FILENUMBER OR NAME AS PARAMETER ***
  if isstr(var),
     file=fopen(var,'r','l');
  else
     file=var;
  end
  name=[filename(file) '.mat'];
  if exist(name),eval(['load ' name]);else 
     [v,t,d,s,ele]=scaneven(['Stim';'posi'],'',file);
     eval(['save datac' DIRS name ' cal lab oth ele'],'');   
  end
  if ele==[],
     [v,t,d,s,ele]=scaneven(['Stim';'posi'],'',file);
     eval(['save datac' DIRS name  ' cal lab oth ele']);   
  end;
  va=ele;
  if isstr(var),fclose(file);end
  return;
end;

showwait('loading eventtable tk - %1.0f');
if nargin>2;			% using variable o1
%*** FILENUMBER OR NAME AS PARAMETER ***
  if isstr(filen),
     file=fopen(filen,'r','l');
  else
     file=filen;
  end;
  name=[filename(file) '.mat'];
  if exist(name),eval(['load ' name]);else 
     [a,a,oth]=scanhead(['rev  ';'date ';'time ';'ncha ';'rate ';...
	'datas';'Chann';'size ';'TeegT'],file);

     eval(['save datac' DIRS name ' cal lab oth']);   
  end;
  [tmp,tmp,header]=scanhead(str2mat('offset','event_pos'),file); 
  Teegtype=eval(oth(9,:));
  size_events=eval(oth(8,:));
  offset=eval(header(1,:));
	% where to start actual events
  pos0=eval(header(2,:));
	% to calculate position have variables
  nc=eval(oth(4,:));
else
  Teegtype=0; 
end;
	% there are two different types of events
if Teegtype==2|nargin<3;n_v=11;else;n_v=5;end;
length=sum(EVENTS_SIZE(1:n_v));
	% how many events
if nargin>0;
  if nargin>1;
    if size(events)==[0,0];
    if nargin>2;
      events=size_events/length;
    else;events=1;end;
    end;
	  else;events=1;var='';end;
else;events=1;var='';end;
%end;
	% if all wanted, n_v number of variables
if size(var)==[0,0];var=EVENTS_VAR(1:n_v,:);end;
	% separating text is "EVENT
pos1=strfind(var,'"EVENT ');
	% which part is for comments and repeated text
if size(pos1,1)<2;pos1=[0;size(var,1)+1];end;
	% comment text
    s=pos1(1,1)-1;
    if s>0
      va=var(1:s,:);
      text(s,1)=' ';
      data(s,1)=' ';      
    end
%end;
	% repeat 'variable' for each event
repeat=var(pos1(1,1)+1:pos1(2,1)-1,:);
	% searching done only once
n=size(repeat,1); found_var(1,2)=0;
	% found_var, variable and it's position
for i=1:n;tmp=strfind(EVENTS_VAR,deblank(repeat(i,:)));
	% position field is special, 99
  if isempty(tmp);if strcmp(deblank(repeat(i,:)),'position');
    tmp=99;end;;tmp=0;end;
  found_var(i,1)=tmp(1,1);
  found_var(i,2)=sum(EVENTS_SIZE(1:tmp-1));
end;%end;

%*** REPEATING FOR EACH ELECTRODE, ALMOST IDENTICAL TO EEGELECT ****
kukkuu=events;
for i=1:events;
%  kakkuu=i;
%  showwait(['index i ' int2str(i)]);	
  showwait; 
  va=putstr(['"EVENT ',int2str(i)],va);
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
      style_numb=deblank(EVENTS_FREAD(var_pos,:));    
      va=str2mat(va,EVENTS_VAR(var_pos,:));
	% text has also calculations
      etext=EVENTS_TEXT(var_pos,:);
      p=find('%'==etext);if isempty(p);p=0;end
      text=str2mat(text,etext(1,p(1,1)+1:size(etext,2)));
      if nargin>2;
% if filehandle given
        pos=pos0+(i-1)*length+found_var(j,2);
        fpos(file,pos);
% writing to file, fprintf for characters and fwrite for numbers
        if nargin>3&~strcmp(style_numb,'calc');% if writing
          pos2=(i-1)*(size(repeat,1)+1)+j+pos1(1,1)+1;
          row=dataw(pos2,:);
          if strcmp(style_numb,'char');
            if size(row)<length,row(1,length)=' ';
              else if size(row)>length;row=row(1,1:length);end;end;
            fprintf(file,'%c',row);
          else;
            value=eval(row);
            fwrite(file,value,style_numb);
          end;
        else;		% if reading
% reading from file, scanf for characters and fread for numbers
          if strcmp(style_numb,'calc');
             pos=pos0+(i-1)*length+4;
             fpos(file,pos);
             to=fread(file,1,'ulong');% eventtable offset
             p=find('%'==etext);
             eval(['row=' etext(1,1:p-1)]);
          else;
          if strcmp(style_numb,'char');
            row=fscanf(file,'%c',length);
          else       
% if style is pos then returning file position, electrodes, events
            if findstr(style_numb,['double','float']);st='%1.3f';
               else st='%1.0f';end;
            row=sprintf(st,fread(file,1,style_numb)); 
          end;
          end;
          data=str2mat(data,row);
        end; 		% file
      else;
        data(size(data,1)+1,1)=EVENTS_SIZE(var_pos);
      end; %not file, nargin >2
      if nargout>3;style=str2mat(style,style_numb);end;
    else; 		%not variable, if size(a,1)>0
      va=str2mat(va,row);
      text=str2mat(text,'');
      if nargin>2,data=str2mat(data,'');
        else;data(size(data,1)+1,1)=EVENTS_SIZE(var_pos);end;
      if nargout>3;style=str2mat(style,'');end;
    end;
  end;	% if size(...
  end;	% for j
%end;	% for i
       
if nargin>3;data=dataw;end;

% returning evaluated values
if nargout>4;
  n=size(repeat,1)+1;
  for i=1:size(data,1)/n;
    for j=2:n;
	% as many as variables
      ele(i,j-1)=eval(data((i-1)*n+j,:));
    end
  end;
end;
     
%*** FILENUMBER OR NAME AS PARAMETER ***
if nargin>2,
  if isstr(filen);
    fclose(file)
  end
end;
showwait('');

%END OF SCANEVEN