%
%MAKEBLT Prepare current figures for gray screen capture.
%	MAKEBLT Toggle gray and colors for current figures. First time 
%	converts all figures to gray for screen capture and second time
%	restores old colors.
%
%	If doing lot of screen captures you may find it usuful to change
%	Windows colors and screen background.
%
%SEE ALSO
%	Uses blt, cinvert. See also scrimage.
%
%EXAMPLES
%	c=creafigs(4);
%	figure(c(1));plotdata(1:100,randn(10,100));
%	figure(c(2));pos1020('',1,1)
%	figure(c(3));surf(randn(5));
%	delete(c(4));editmacr;uihelp
%	makeblt
%	!snapshot % platform dependent, Print Screen in Windows
%	makeblt

%	J.Virkkala 21-Aug-94
%	J.Virkkala  6-Mar-95 Part of ScanUtil.
%	J.Virkkala 20-May-95 Using findobj for uicontrols/edit.

if exist('BLT_0');
%*** RETURNS ORIGINAL COLORS ***
  for BLT_I=1:size(BLT_0,1)
    figure(BLT_0(BLT_I));
    cinvert(BLT_0(BLT_I));
    blt(BLT_0(BLT_I),gray(256),eval(['BLT_' int2str(BLT_I)]));
    eval(['colormap(BLT_C' int2str(BLT_I)]);
    eval(['clear BLT_' int2str(BLT_I) ' BLT_C' int2str(BLT_I)]);
  end;
  clear BLT_0
else

%*** CONVERT TO GRAY ***
  BLT_0=get(0,'children');
  for BLT_I=1:size(BLT_0,1)
    set(0,'currentfigure',BLT_0(BLT_I));
    eval(['BLT_' int2str(BLT_I) '=blt(BLT_0(BLT_I),gray(256));']);
    eval(['BLT_C' int2str(BLT_I) '=colormap;']);
    colormap(gray);
    cinvert(BLT_0(BLT_I));
  end;
  set(findobj(findobj(0,'Type','uicontrol'),'Style','edit'),'backg',...
	[1 1 1],'foreg',[0 0 0]);
end;
clear BLT_I;
    
% END OF MAKEBLT