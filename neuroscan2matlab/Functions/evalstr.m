function [v1,v2,v3,v4,v5,v6,v7,v8,v10]=evalstr(str,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10);
%EVALSTR Evaluate string as m file.
%	[V1,...,V10]=EVALSTR(STR,P1,...P10) String str is saved to temp file 
%	which is then called with parameters prm. Files tempfilx.m are reserved
%	for such temporal files. Global variable FILETMP_INDEX points current
%	index in temporal file.
%
%	Line 'function [o1...o10]=tmp(i1...i10)' is added to beginning of
%	str and these variables should be used inside str.
%
%DIAGNOSTICS
%	Used global variable FILETMP_INDEX.
%
%SEE ALSO
%	Uses savestr. See also evalmcw, editmacr, makem.
%
%EXAMPLES
%	FILETMP_INDEX=1;
%	evalstr('o1=mean([i1(:) i2(:)]);',[2 3 4],[5 6 7])
%	                              % use of input parameters
%	run=str2mat('i1','o1=randn(i1(1),1);','o2=plot(o1);');
%	[o1,o2]=evalstr(run,5)        % parameters as ascii
%	evalstr(run,10)

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 26-Jul-94
%	J.Virkkala  9-Jan-95 Files tmp*.* are reserved for temporary.
%	J.Virkkala 27-Feb-95
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala 10-Mar-95 Parameters can be given as separate.

global FILETMP_INDEX

if isempty(FILETMP_INDEX);FILETMP_INDEX=0;end;

	% calling
row=['function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=' ... 
      'tmp(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)'];
row=str2mat(row,'o1=[];o2=[];o3=[];o4=[];o5=[];o6=[];o7=[];o8=[];o9=[];o10=[];');
if isempty(str);str='break';end;
FILETMP_INDEX=FILETMP_INDEX+1;
name=['tmpfil' int2str(FILETMP_INDEX)];
savestr(putstr(str,row),[name '.m']);
eval(['clear ' name]);
if nargin<2;
   eval(['[v1,v2,v3,v4,v5,v6,v7,v8,v9,v10]=' name ';']);
else
   row='p1';		% all 10 parameters
   for i=2:nargin-1,
     row=[row ',p' int2str(i)];
  end    
  %name
  %p1
  %[v1,v2,v3,v4,v5,v6,v7,v8,v9,v10]=tmpfil1(p1,p2);
  %['[v1,v2,v3,v4,v5,v6,v7,v8,v9,v10]=' name '(' row ');']
  eval(['[v1,v2,v3,v4,v5,v6,v7,v8,v9,v10]=' name '(' row ');']);
end
%type tmpfil1
%eval(['delete ' name '.m']);
FILETMP_INDEX=FILETMP_INDEX-1;

%END OF EVALSTR