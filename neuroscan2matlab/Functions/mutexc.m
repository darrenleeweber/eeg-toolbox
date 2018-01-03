function [handles]=mutexc(handle,offset,command)
%MUTEXC Create mutually exclusive uicontrols.
%	HANDLES=MUTEXC(HANDLE,OFFSET,COMMAND) For creating mutually exclusive
%	radio and check buttons. Returns handle numbers. Handle defines how 
%	many buttons or handlevector for them.
%
%	Object handles(1), userdata(offset+1) has data which one is selected 
%	and userdata(offset+2) is command which is run when button is selected. 
%	In command string #1 is replaced with handles and #2 with selected
%	button, tmp has value, see example. 
%
%SEE ALSO
%	Uses putstr. See also uicval, o2s.
%
%EXAMPLES
%	set(gcf,'units','pixels','position',[10 100 300 225]);
%	subplot(1,2,2);	                % plotting randn
%	b0=uicontrol('style','pushbut','string','Close figure',...
%	'callback','close;','position',[5 205 100 15]);
%	                                % button commands
%	b1=mutexc(10,1,'#2;plot(randn(2^tmp,1),1:2^tmp);');
%	for i=1:10;set(b1(i),'position',[5 20*i-15 100 15],...
%	'string',['randn ',int2str(2^i)],'horiz','left');end;
%	                                % position, allow resize
%	set([b0 b1],'units','norm')		

%	J.Virkkala  4-Aug-94
%	J.Virkkala 12-Jan-95 Using o2s function.
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

%*** CREATING BUTTONS ***
if nargin>2;
	% creating or using vector
  if size(handle)==[1 1];
    for i=1:handle;handles(i)=uicontrol('style','radiobutton');end;
	% # is replaced with handles number
    else handles=handle(:)';
  end
	% replacing #1 with handles and #2 with selected one
  command=strrep(command,'#1',['tmp' uicval(handles(1),'userdata') ...
        'tmp=eval(tmp(' int2str(offset) ',:))']);
  command=strrep(command,'#2',['tmp' uicval(handles(1),'userdata') ...
        'tmp=eval(tmp(' int2str(offset)+1 ',:))']);
	% first handle stores others handle numbers		
  set(handles(1),'userdata',putstr(str2mat(o2s(handles),...
     '1',command),get(handles(1),'userdata'),offset));
	% setting command
  run=['eval(mutexc(',o2s(handles(1)),',',int2str(offset),'));'];
  set(handles,'callback',run);    
  set(handles(1),'value',1);

%*** RUNTIME CALLING ***
else
  userdat=get(handle,'userdata');
  others=eval(userdat(offset,:)); 
	% one one, others off
  set(others,'value',0)
	% uses figure, current object to detect which was pressed
  co=get(gcf,'currentob');
  set(co,'value',1)
  text=get(handle,'userdata');
	% store which one is selected
  set(handle,'userdata',putstr(int2str(find(co==others)),...
      text,offset+1,1));
	% return commands
  handles=userdat(offset+2,:);
end;

% END OF MUTEXC