function hdl=plottext(text,array,hdl);
%PLOTTEXT Plot text with numerical values into current axes.
%	HDL=PLOTTEXT(TEXT,ARRAY) Plots numerical values from array into 
%	current axes in format defined in text. If text has one row then it
%	defines file name. In text % defines places where to print values. 
%
%	Text is shown in edit uicontrol. Text can be edited. Text can be 
%	printed by transforming it into image by scrimage or to text 
%	objects by scrimage or convtext. With Matlab 5.2 also direct priting
%  is available.
%
%DIAGNOSTICS
%
%SEE ALSO
%	Scrimage, convtext.
%
%EXAMPLES
%	subplot(211),title('VALUES')
%	h=plottext(str2mat('TABLE','%1.2f	%1.2f','END'),[0.12 2.22]);
%	print datah\plottext -djpeg
%	              % continue in scrimage

%JVIR, following is not needed
%	Use Uicontrols Font as New Courier 9 from Matlab Command Window, 
%	Options. Screen size of [1024 768] is supposed.

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR,  4-Feb-1999 Changed color for direct printing.
%JVIR,  3-Feb-1999
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala  6-Jan-95 For QEEG.
%	J.Virkkala  6-Mar-95 Part of ScanUtil.
%	J.Virkkala  7-Apr-95 Must be extended.
%	J.VIrkkala 20-May-95 Leaving old axes visible, units normalized.

		% set apperance
if nargin<2,array=[];end
if nargin<3,hdl=[];end
if isempty(hdl),
  pos=get(gca,'position');
%JVIR, saving figure but removing axes 
  set(gca,'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1],...
	'xticklabel','','yticklabel','','zticklabel','');
  hdl=uicontrol('style','edit','position',pos, 'units',get(gca,'units'),...
    'min',1,'max',10,'back',[0 0 0],'backg',[1 1 1],'fore',[0 0 0],'fontname','new courier','fontsize',9,'horizontalal','left');
end
	
if nargin>0,	% load format
  if size(text,1)==1,text=loadstr(text);end
  s=size(array);
  format=[];
  for i=1:s(2),
    format=[format ',array(#,' mat2str(i) ')'];
  end
  edit=[];
  j=1;
  for i=1:size(text,1),
    row=['#' text(i,:)];
    p=findstr(row,'%');
    if isempty(p)|j>size(array,1),
      run=row;
    else   
      run=['sprintf(''' row '''' strrep(format,'#',int2str(j)) ')'];
      run=eval(run);
      j=j+1;
    end		% remove multiple printouts
    p=findstr(run,'#');		
    if size(p,2)>1,
      run=run(2:p(2)-1);
    else
      run=run(2:size(run,2));
    end
    edit=putstr(run,edit);
  end
  set(hdl,'string',edit,'units','norm');
end

%END OF PLOTTEXT