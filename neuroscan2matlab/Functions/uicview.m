function [hdl,fig]=uicview(y);
%UICVIEW Add uicontrols to fig to control view in 3D. 
%	[HDL,FIG]=UICVIEW(Y) Returns 2*(text, edit, slide) handlevectors. 
%	Y is position where to add controls to current figure, if y<1 then
%	normalized otherwise pixels and <0 from top.
%
%SEE ALSO
%	Uses uicput, uicval. See also demorgb, view.
%
%EXAMPLES
%	subplot(211);surf(randn(10,10));uicview(-1);
%	subplot(212);surf(randn(10,10));uicview(0);
%	print uicview -djpeg

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR, 31-Jan-1999 Changes for Matlab 5.2, ~= by isempty

%	J.Virkkala 10-Aug-94 
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala  9-Jun-95 Changed mat2str to o2s.

	% if not enough parameters
if nargin==0;y=0;end;
fig=gcf;
	% position
old=get(gcf,'units');
set(gcf,'units','pixels');
pos=get(gcf,'position');
if y<1;
  if y<0;y=y+pos(4)-45;
    else;y=pos(4)*y+5;
  end;
end;
	% create uicontrol with UICPUT
hdl1=uicput('t12te   e/t12te   e',y+25);
hdl2=uicput('s       s/s       s',y);
	% back to normalized to work with resizing
set(hdl1(1),'string','AZ');
set(hdl1(3),'string','EL');
%JVIR, hdl was not defined
hdl=[hdl1(:)' hdl2(:)'];
set(hdl,'units','normalized');
	% controls
edt1s=o2s(hdl1(2));
edt2s=o2s(hdl1(4));
sli1s=o2s(hdl2(1));
sli2s=o2s(hdl2(2));
gets='[AZ,EL]=view;';
ax=get(fig,'currentaxes');
puts=['set(',int2str(fig),',''currentaxes'',',o2s(ax),');view(AZ,EL)'];
	% slider controls
set(hdl2(1),'value',-37.5,'min',-180,'max',180,'callback',...
   [gets,'AZ',uicval(hdl2(1)),';set(',...
   edt1s,',''string'',sprintf(''%1.1f'',AZ));',puts]);
set(hdl2(2),'value',30,'min',-180,'max',180,'callback',...
   [gets,'EL',uicval(hdl2(2)),'set(',...
   edt2s,',''string'',sprintf(''%1.1f'',EL));',puts]);
	% azimunth
set(hdl1(2),'callback',[gets,'AZ',uicval(hdl1(2),'string',1),'set(',...
   sli1s,',''value'',AZ);',puts],'string','-37.5');
	% horizontol elevation
set(hdl1(4),'callback',[gets,'EL',uicval(hdl1(4),'string',1),'set(',...
   sli2s,',''value'',EL);',puts],'string','30');
	% old properties
set(gcf,'units',old);

%END OF UICVIEW