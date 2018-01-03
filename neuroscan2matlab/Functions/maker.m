function file=maker(name,file);
%MAKER Create macro R0..R9 from m files name0..9.m.
%	MAKER(NAME) Read files created by makem and transform them to
%	current R0...R9. If using editmacr select an another page to
%	see changes.
%
%DIAGNOSTICS
%	All the text NAME are replaced by eval(Rx,...). One error 
%	possibility is strings with NAME. Used globals are R0..R9.
%
%SEE ALSO
%	Uses loadstr, strfind, putstr, showwait. See also makem. 
%
%EXAMPLES
%	R0=[];R1=[];R2=[];R3=[];R4=[];R5=[];R6=[];R7=[];R8=[];R9=[];
%	maker('test');         % convering m files
%	R1
%	maker('qeega');        % from m files into macro
%	R0

%	J.Virkkala 15-Aug-94
%	J.Virkkala  3-Mar-95 Part of ScanUtil.
%	J.Virkkala  2-Jun-95 Corrected some problems which exist.

global R0 R1 R2 R3 R4 R5 R6 R7 R8 R9

%*** CALLING TO REPLACE nameR() ****
if nargin==2;
  k=strfind(file,name);				% where name found
	% where name text exists
  for i=1:size(k,1);
    row=file(k(i,1),:);
    r=row(k(i,2)+size(name,2));
    par=find(')'==row);
	% no parameters
    if size(par,1)==0;
      par(1)=k(i,1)+size(name,2);
      file=putstr(deblank([row(1:k(i,2)-1) 'evalstr(R' r ')' ...  
        row(k(i,2)+1+size(name,2):size(row,2))]),file,k(i,1),1); 
    else
      file=putstr(deblank([row(1:k(i,2)-1) 'evalstr(R' r ',''' ... 
         row(k(i,2)+size(name,2)+2:par(1)-1) '''' row(par(1):size(row,2))]),...
         file,k(i,1),1); 
    end
  end;
else;

%*** GOING THROUGH EVERY PAGE ***
  for i=0:9;
    showwait
    file=loadstr([name int2str(i) '.m']);	% load m file
    file=file(2:size(file,1),:);	% remove extra rows
	% In R only first row is seen by help 
    file=maker(name,file);
    eval(['R' int2str(i) '=file;']);		% change to R0...R9
  end;
end;    

% END OF MAKER