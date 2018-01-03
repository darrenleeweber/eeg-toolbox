function dir=findpath(what);
%FINDPATH Return given path from Matlab path.
%	DIR=FINDPATH(WHAT) Return directory from path. Path has directory
%	separator at end.
%
%SEE ALSO
%	Uses path.
%
%EXAMPLES
%	findpath('scanutil')

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 11-Jan-95
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala  6-Apr-95 Correction if many appearance.
%	J.Virkkala 29-Jan-96 Changed to work in different drive than Matlab.

global DIRSS DIRS

a=path;
f1=findstr(a,DIRSS);
f2=findstr(a,what);
if isempty(f1)|isempty(f2),
  errorr(['hpw ' what ' not in path'],'findpath');
  dir=[];
%JVIR
  break;
end
i1=max(f1(find(f1<f2(1))));
i2=min(f1(find(f1>f2(1))));
if isempty(i2),i2=size(a,2)+1;end
dir=[a(i1+1:i2-1) DIRS];


% FINDPATH