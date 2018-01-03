function s1=deblanks(s);
%DEBLANKS Strip blanks in the beginning and end.
%	S1=DEBLANKS(S) Removes blanks.
%
%SEE ALSO
%	Uses deblank.
%
%EXAMPLES
%	['+' deblanks('  remove blanks  ') '+']

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 28-May-95 Part of ScanUtil.
%	J.Virkkala  6-May-95 Corrected bug, last char left out.

s1=deblank(s);
n=length(s1);
if ~isempty(s1),
  while s1(1)==' ',
    s1=s1(2:n);
    n=n-1;
  end
end

%END OF DEBLANKS