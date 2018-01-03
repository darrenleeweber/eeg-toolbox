function [new]=rmrow(line,pos);
%RMROW	Removes indicated rows from matrice.
%	[NEW]=RMROW(LINE,POS) Rows indicated in pos are removed from matrice
%	line and result is given in new.
%
%DIAGNOSTICS
%	Works with numbers and strings.
%
%SEE ALSO
%	Strfind.
%
%EXAMPLES
%	rmrow(str2mat('mond','tues','wedn','thurs','frid','end'),[3;6])
%	rmrow([1;2;3;4;5;6],[3;6])

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 17-Jun-94
%	J.Virkkala 23-Dec-94 Works with numbers too, artefact rejection.
%	J.Virkkala  3-Mar-95 Faster with numbers, part of ScanUtil.

str=isstr(line);	% for number
if str==0,
  i=1:size(line,1);
  i(pos)=ones(size(pos))*Inf;
  i=i(find(i~=Inf));
  new=line(i,:);
else			% for text
  pos=pos(:);
  if size(line,1)~=0&size(pos,1)~=0;pos=pos(:,1);new=[];
	% if there is something to remove
  for i=1:size(line,1);
    if ~isempty(find(pos==i));else;if size(new,1)==0;new=line(i,:);
         else;new=str2mat(new,line(i,:));
      end; 
    end
  end;
    else new=line;
  end;
end     

%END OF RMROW