function file=makem(name,file,a);
%MAKEM Create m files name0..9.m from R0..R9 macro.
%	MAKEM(NAME) Create m files from current macro which can be 
%	evaluated as function with name0. For DOS compatible use only names
%	size of 7 characters. Strings evalstr(RX,'Y') in beginning are 
%	replaced with corresponding nameX(Y).
%
%DIAGNOSTICS
%	Remember that transfer parameters are i1..i9 and o1..o9. There 
%	cann't be many evalstr in same row in macros. 
%
%SEE ALSO
%	Uses strfind, putstr, savestr, showwait. See also evalstr, maker.
%	Used global variables are R0..R9.
%
%EXAMPLES
%	R0='0';R1='1';R2='2';R3='3';R4='4';R5='5';R6='6';R7='7';R8='8';
%	makem('testmac')          % converting macros
%	type testmac0

%	J.Virkkala 15-Aug-94
%	J.Virkkala 24-Feb-95 Options removed.
%	J.Virkkala  3-Mar-95 Part of ScanUtil.

global R0 R1 R2 R3 R4 R5 R6 R7 R8 R9

%*** CALLING TO REPLACE evalstr(R,...) ****
if nargin==3;
  k=strfind(file,'evalstr(R');
	% evalstr should be first in row
  for i=1:size(k,1);
    row=file(k(i,1),:);
    if row(1)~='%',
      r=row(k(i,2)+9);
      par=find(')'==row);
      if par(1)==k(i,2)+10;
        file=putstr([row(1:k(i,2)-1) name r row(par(1)+1:size(row,2))],...
        file,k(i,1),1); 
      else
        file=putstr([row(1:k(i,2)-1) name r '(' row(k(i,2)+12:par(1)-2) ...
        row(par(1):size(row,2))],file,k(i,1),1); 
 
      end
    end
  end;
else;

%*** GOING THROUGH EVERY PAGE ***
% if nargin==2;eval(['save ' name ' L1 C1 E1']);end;
  for i=0:9;
    showwait
    hea=['function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=' name int2str(i) ...
        '(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)'];
    str=makem(name,eval(['R' int2str(i)]),1);
    if size(str,1)<2;str=str2mat(str,'');end;
	% In R only first row is seen by help 
    str=str2mat(hea,str(1,:),str(2:size(str,1),:));
	% save m file
    savestr(str,[name int2str(i) '.m']);
  end;
end;    

% END OF MAKEM