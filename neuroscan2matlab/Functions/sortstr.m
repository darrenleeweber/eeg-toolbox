function [sorted,i]=sortstr(str);
%SORTSTR Sort in ascending order.
%	[SORTED,I]=LOADEDIT(STR) Sort string str into sorted. Index i
%	defines sorted=str(i,:).
%
%SEE ALSO 
%	Uses sort.
%
%EXAMPLES
%	str=str2mat('Jan','Feb','Mar','Apr','May','Jun','Jul');
%	sortstr(str)       

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 17-May-95 For new Reference.

s=(str+0)*256.^(size(str,2):-1:1)';
[s,i]=sort(s);
sorted=str(i,:);

% END OF SORTSTR