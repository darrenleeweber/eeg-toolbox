function [old]=putstr(what,old,pos,replace);
%PUTSTR	Puts rows of string into another string.
%	[OLD]=PUTSTR(WHAT,OLD,POS,REPLACE) Adds what to old(pos,:) If 
%	nargin=2 then what adds to end. What, old can have multiple rows.
%	If pos greater than size of old+1 [] are added before what. With
%	replace=1 doesn't insert rows, but replaces. 
%
%SEE ALSO
%	Rmrow.
%
%EXAMPLES
%	putstr(str2mat('is','almost'),str2mat('today','monday'),2)
%	putstr('is',str2mat('today','isn''t','monday'),1,1)
%	putstr('is',str2mat('today','isn''t','monday'),2,1)
%	putstr('is',str2mat('today','isn''t','monday'),3,1)

%Mention source when using or modifying these Shareware tools

%JVIR,11-Mar-1999 Corrrected to work with Matlab 5.0 str2mat.m
%JVIR, 2-Feb-1999 Modified for PCWIN Matlab 5.2.
%JVIR,Jussi.Virkkala@occuphealth.fi

%	J.Virkkala 23-Jun-94
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

	% adding rows;
if nargin>2;for i=1:pos-size(old,1)-1;old=str2mat(old,'');end;end;
n_old=size(old,1);
n_what=size(what,1);

	% if old is empty
if n_old==0;old=what;return;end;
	% if no pos then into end	
if nargin==2;if size(what,1)~=0;old=str2mat(old,what);end;
else
  if pos==1;if replace&n_old>0;old=str2mat(what,old(2:n_old,:));else;
    old=str2mat(what,old);end
  else
    if pos>n_old;old=str2mat(old,what);end
    if nargin==4
        if replace;pos_end=pos+size(what,1);else;pos_end=pos;end;
     else
        pos_end=pos;
     end;
%JVIR,11-Mar-1999 modifications to work with Matlab 5.0 str2mat
     if pos_end>=n_old,
        old=str2mat(old(1:pos-1,:),what);
     else
        old=str2mat(old(1:pos-1,:),what,old(pos_end:n_old,:));
	  end        
%JVIR,one extra end removed
%    end;
  end;
end;

%END OF PUTSTR