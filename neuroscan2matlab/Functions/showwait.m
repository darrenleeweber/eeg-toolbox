function showwait(text);
%SHOWWAIT Show calculation time on figures name.
%	SHOWWAIT(TEXT) Text is used by sprintf to print toc when showwait
%	is called without parameters. 
%
%	When text<>[] it is saved to recursivly into global variable 
%	SHOWWAIT and with text=[] figure's old name is restored. Pointer 
%	is also changed to watch when running. Use showwait(-1) after error to
%	to clear showwait variable and to restore arrow pointer.
%
%DIAGNOSTICS
%	Global variable used is SHOWWAIT.
%
%SEE ALSO
%	Uses tic, toc.
%
%EXAMPLES
%	showwait('calculating %1.1f s');
%	for i=1:1000;showwait;end;
%	showwait('');
%	    % remember old names
%	for i=1:5;showwait(['index i' int2str(i)])
%	  pause(1)
%	  for j=1:5;showwait(['index j' int2str(j)]);pause(1)
%	    showwait('');end;
%	  showwait('')
%	end;               

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala 29-Jun-94
%	J.Virkkala 20-Feb-95 Plotting to next figure
%	J.Virkkala  6-Mar-95 Part of ScanUtil

global SHOWWAIT
	% First fields is figure handle
n=size(SHOWWAIT,1);
if n>0;
  fig=eval('SHOWWAIT(1,:)','SHOWWAIT=[];fig=[]');
  eval('fig=eval(fig);','');  
  eval('get(fig,''name'');','SHOWWAIT=[];')
end
if nargin==1;
  if isempty(text);
	% then comes text and old name text 
     if n>2;
	% return old name
      eval('get(fig,''parent'');','SHOWWAIT=[];');
      if isempty(SHOWWAIT);break;end;
      set(fig,'name',SHOWWAIT(3,:));
      set(fig,'pointer','arrow');
      SHOWWAIT=rmrow(SHOWWAIT,[1 2 3 4]);;
    end;
 else
%JVIR, moved here
    if text==-1;set(gcf,'pointer','arrow');SHOWWAIT='';break;end;   
    fig=gcf;
    name=get(fig,'name');if isempty(name);name=' ';end;
    SHOWWAIT=putstr(SHOWWAIT,str2mat(int2str(fig),...
      text,name,get(fig,'pointer')));
    set(gcf,'pointer','watch');
    tic;
	% first time
    set(fig,'name',sprintf(SHOWWAIT(2,:),toc));
    drawnow;
  end;
else
	% showing time 
  if n>1;
    if size(SHOWWAIT,1)>1,
       set(fig,'name',sprintf(SHOWWAIT(2,:),toc))
    else
       showwait(-1);
    end
  end
end;

%END OF SHOWWAIT