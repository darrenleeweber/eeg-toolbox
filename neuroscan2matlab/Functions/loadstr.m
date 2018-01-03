function [txt,p]=loadstr(file);
%LOADSTR Load ascii file.
%	[TXT,P]=STR(FILE) Loads strings from file. Works atleast
%	with SUN4, SGI and PCWIN. Returns text and path of file.
%
%SEE ALSO 
%	Uses fgetl, feof. See also loadstr, savestr.
%
%EXAMPLES
%	[str p]=loadstr('uiscroll.hlp')      % load help file

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR, 31-Jan-1999 Changes for Matlab 5.2, ~= by isempty

%	J.Virkkala 21-Aug-94
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

	% ppen for reading
if strcmp(computer,'PCWIN');
  fid=fopen(file,'rb');
else
  fid=fopen(file,'r');  
end;
	% if file error
if fid==-1;
  errorr('hff Cann''t read','loadstr');
return;end

txt=[];
row=fgetl(fid);
	% through all lines
while isstr(row)&feof(fid)==0;
  showwait;
  if isempty(txt)
    txt=row;
  else
    txt=str2mat(txt,row);
  end;
  row=fgetl(fid);
end;
[n,p]=filename(fid);
fclose(fid);
  
%END OF LOADSTR