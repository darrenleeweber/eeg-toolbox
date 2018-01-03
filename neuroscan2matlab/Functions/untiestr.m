function [t1,t2,t3,t4,t5,t6,t7,t8,t9,t10]=untiestr(sep,line);
%UNTIESTR Untie strings from matrice.
%	[T1..T10]=UNTIESTR(SEP,LINE) Untie strings to separate string 
%	t1...t10. Line has separator marks, line=[sep(1,:) t1 sep(2,:)...
%	sep(11,:)]. If not enough parameters then sep(1,:) and sep(10,:)
%	are []. Lines starting with * or " are returned to t1.
%
%SEE ALSO
%	Uses showwait. See also tiestr.
%
%EXAMPLES
%	[var val]=untiestr(['!';'=';'{'],['  !name=jussi{firstname}';
%	'!addr=messi{internet)   '])

%	J.Virkkala 20-Jun-1994
%	J.Virkkala  6-Mar-1995 Part of ScanUtil.

length=size(line,2);
na=nargout;
for i=1:size(line,1);
	% global wait procedure
    showwait;
	% if sep haven't enough rows
    if nargout>=size(sep,1);k=0;old=1;else
      old=findstr(sep(1,:),line(i,:))+1;k=1;end
    for j=1:na;
	% lines beginning with " or * left alone
      if find(line(i,1)==['"','*']);
         if j==1;row=line(i,:);else;row='';end;
      else
         if nargout>size(sep,1)&j==na;pos=length+1;
         else;
	% where control character is found
           pos=findstr(sep(j+k,:),line(i,old:length))+old-1;
         end;
         row=line(i,old:pos-1);
      end;
      row=deblank(row);
      if i==1;run=['t',int2str(j),'=row;'];else
      run=['t',int2str(j),'=str2mat(t',int2str(j),',row);'];end;
      eval(run);
      old=pos+1;    
    end;
end;

% END OF UNTIESTR