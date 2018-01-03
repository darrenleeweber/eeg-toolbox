function [k]=strfind(where,what,break);
%STRFIND Extension to findstr, accept matrice.
%	[K]=STRFIND(where,what,break) Finds string what from string where
%	with findstr function and returns k(:,1) containing rownumbers 
%	in ascending order and k(:,2:...) positions in that row. If break 
%	given stops with first match.
%
%SEE ALSO
%	Uses showwait. See also findstr.
%
%EXAMPLES
%	strfind(str2mat('monday','tuesday','wednesday','thursday'),'d')
%	strfind(str2mat('monday','tuesday','wednesday','thursday'),'d',1)

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 14-Jun-94
%	J.Virkkala  6-Mar-95 Part of ScanUtil.

k=[];
for i=1:size(where,1);
  showwait;
  p=findstr(where(i,:),what);
  if p;y=size(k,1)+1;k(y,1)=i;k(y,2:size(p,2)+1)=p;
%	whether to break with match
    if nargin>2;return;end;end;
end;

%END OF STRFIND