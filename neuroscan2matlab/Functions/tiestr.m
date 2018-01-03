function [line]=tiestr(sep,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10);
%TIESTR Tie rows of strings into one matrice.
%	[LINE]=TIESTR(SEP,T1...T10) Create a string with rows line=
%	[sep(1,:) t1 sep(2,:).. t10 sep(11,:)]. Strings are deblanked.
%	Up to 10 strings can be used as parameters. If sep has less
%	rows than parameters+1 [] is put to the beginning (and to end).
%	Lines in t1 starting with * or " are returned as same to line.
%
%SEE ALSO
%	Uses showwait. See also untiestr.
%
%EXAMPLES
%	tiestr(str2mat('=','{','}'),str2mat('name','address'),...
%		str2mat('jussi','messi'),str2mat('firstname','internet'))
%	tiestr([],'first','last')

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 20-Jun-94
%	J.Virkkala 29-Nov-94 Bug with tiestr(t,v).
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala 18-May-95 Bug in row=t1(1,:), added different size.
%	J.Virkkala  7-Jun-95 Some changes.

line='';
if isempty(sep),sep=[' ';' '];end
	% is sep doesn't have enough arguments

	% through rows
for i=1:size(t1,1);
	% global wait procedure
  showwait;				% if not enough parameters
  if nargin>size(sep,1),row='';k=0;else,
    k=1;row=sep(1,:);
  end
	% lines beginning with " or # special
  if find(t1(i,1)==['"','#']);row=t1(i,:);
  else
    for j=1:nargin-1;   
	% through input parameters, check for sizes
      eval(['t=t' int2str(j) ';']);
      if size(t,1)>=i,
        run=['row=[row,deblank(t(i,:)),deblank(sep(',int2str(j+k),',:))];'];
        eval(run);
      end
    end;
  end;
	% line is what is returned
  if i==1;line=row;else;line=str2mat(line,row);end;
end;

%END OF TIESTR