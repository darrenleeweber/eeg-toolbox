function str=uicval(ind,hdl,what,evl);
%UICVAL Return string which return object's property.
%	STR=UICVAL(IND,HDL,WHAT,EVL) Return string "ind=get(hdl,what);". For 
%	uicontrol use. If hdl is string then "=get(ind,hdl);". Default what 
%	is 'value'. With evl given eval(...) is added to string.
%
%SEE ALSO 
%	Uses o2s. See also uicput.
%
%EXAMPLES
%	hdl=uicput('p12p/p12p');v1=1;v2=1; % create 2 popupmenus
%	set(hdl,'string',['1';'2';'3';'4';'5']);
%	for i=1:2                          % return v1 and v2
%	set(hdl(i),'callback',['v' uicval(i,hdl(i)) '[v1 v2]']);end

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%	J.Virkkala  3-Aug-94
%	J.Virkkala 12-Jan-95 Added use of h2s to eliminate errors.
%	J.Virkkala  5-Mar-95 Part of ScanUtil.

	% is what not given
if nargin==1;hdl=0;end
if nargin<3;what='value';end;
	% creating string
if nargin==1|isstr(hdl)|~isstr(what);
	% with two parameters and last string
  if isstr(hdl);what=hdl;end;
	% evaluate
  if nargin==3;
     str=['=eval(get(' o2s(ind) ',''' what '''));'];
  else
     str=['=get(' o2s(ind) ',''' what ''');'];
  end;
else
	% with 3 or 4 parameters and ind
  if nargin==4;
    str=[int2str(ind) '=eval(get(' o2s(hdl) ',''' what '''));'];
  else
    str=[int2str(ind) '=get(' o2s(hdl) ',''' what ''');'];
  end;
end;

%END OF UICVAL