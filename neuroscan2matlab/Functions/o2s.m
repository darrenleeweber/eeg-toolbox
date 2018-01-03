function s=o2s(h);
%O2S Return object as string.
%	S=O2S(H) Return object number as string. Use when creating
%	uicontrols.
%
%DIAGNOSTICS
%	Created for 4.2c.1 where mat2str doesn't work all the time,
%	h must be a vector. 
%
%SEE ALSO
%	Mat2str.
%
%EXAMPLES
%	o2s(gco)

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  4-Feb-1999 By default showing menubars.

%	J.Virkkala 12-Jan-95
%	J.Virkkala 27-Jan-95 Removing zeros from end.
%	J.Virkkala  6-Mar-95
%	J.Virkkala 16-May-95 Renamed from h2s to o2s.

s=size(h);
if s(1)>s(2),sep=';';else,sep=' ';end
 
if h==floor(h),		% integer object, ex. figure
   s=sprintf(['%1.0f' sep],h);
else  			% floating point objec
   s=sprintf(['%1.15f ' sep],h);
   while findstr(s,'0 '),s=strrep(s,'0 ',' ');end
end
s=['[' s ']'];

%END OF O2S