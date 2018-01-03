function fid=loadedit(file,type,which);
%LOADEDIT Load ascii string for editmacr and editscan.
%	[FID]=LOADEDIT(FILE,TYPE,WHICH) Loads strings from ascii file into
%	R, uicedit with type true or into ES, editscan with type false. 
%
%	If which given it defines which "PAGE R or "SCAN ES is returned 
%	and if nothing found returns hole file, use to transfer pages. 
%	Function works atleast with SUN4, SGI and PCWIN.
%
%DIAGNOSTICS
%	Referred scanedit is not included in this version of ScanUtil 
%	toolbox. Used global variables are R0...R9, EE0...EE2.
%
%SEE ALSO
%	Uses fgetl. See also loadstr, savestr, editmacr.
%
%EXAMPLES
%	loadedit('qeega.r0',1,0)         % page R0
%	R0
%	

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 31-Aug-94
%	J.Virkkala  3-Mar-95 Part of ScanUtil.

global R0 R1 R2 R3 R4 R5 R6 R7 R8 R9
global ES0 ES1 ES2

	% Open file for input
if strcmp(computer,'PCWIN')
  fid=fopen(file,'rb');
else
  fid=fopen(file,'r');  
end;
	% if file error
if fid==-1;return;end

	% which type
if type,
  eval_s='R';find_s='%PAGE R';
else
  eval_s='ES';find_s='%SCAN ES';
end

	% which page or all pages
if nargin>2
  st=which;
  en=which;
else
  st=0;
  if type
    en=9;
  else
    en=2;
  end
end

%*** READING THROUGH FILE ***  
for i=st:en;
  showwait;
  if i==st;				% First string needs extra
    row=fgetl(fid);
	% Finds separating rows
    while isstr(row)&isempty((findstr(row,[find_s int2str(i)]))|size(row,2)<8)
      row=fgetl(fid);
    end;
	% right part
  end;
  txt=[];
  if isstr(row);row=fgetl(fid);end
  while isstr(row)&isempty((findstr(row,[find_s int2str(i+1)]))|size(row,2)<8)
    if isempty(txt);txt=row;else;txt=str2mat(txt,row);end
    row=fgetl(fid);
  end;
	% if nothing found then return hole file
  if isempty(txt);
    if nargin>2;txt=loadstr(file);
      else;txt=' ';end
  end; 
  eval([eval_s int2str(i) '=txt;']);
end;
fclose(fid);

%END OF LOADEDIT