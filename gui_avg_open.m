function [p] = gui_avg_open(p,command,parent)

% gui_avg_open - Load averaged ERP data into matlab workspace
% 
% Usage: [p] = gui_avg_open(p,[command],[parent])
% 
% p is a structure, generated by 'eeg_toolbox_defaults'
% command is either 'init' or 'load'
% parent is a handle to the gui that calls this gui, useful
% for updating the UserData field of the parent from this gui.
% The p structure is returned to the parent when the parent 
% handle is given.
% 

% $Revision: 1.7 $ $Date: 2004/04/16 18:49:10 $

% Licence:  GNU GPL, no express or implied warranties
% History:  01/2002, Darren.Weber_at_radiology.ucsf.edu
%           08/2002, Darren.Weber_at_radiology.ucsf.edu
%                    added EMSE avg handling
%                    added interpolation of zero point option
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~exist('p','var'),
 [p] = eeg_toolbox_defaults;
elseif isempty(p),
 [p] = eeg_toolbox_defaults;
end

if ~exist('command','var'),
  command = 'init';
elseif isempty(command),
  command = 'init';
end

command = lower(command);

switch command,
  case 'init',
    if exist('parent','var'),
      AVGOpen = INIT(p,parent);
    else
      AVGOpen = INIT(p,'');
    end
  otherwise,
    AVGOpen = get(gcbf,'Userdata');
    set(AVGOpen.gui,'Pointer','watch');
end


switch command,
  
  case 'plot',
    
    AVGOpen.p = avg_open(AVGOpen.p,AVGOpen.gui);
    
    plotfig = figure('Name',AVGOpen.p.volt.file,...
      'NumberTitle','off',...
      'UserData',AVGOpen.p);
    movegui(plotfig,'center');
    
    plot(AVGOpen.p.volt.timeArray,AVGOpen.p.volt.data); axis tight;
    eeg_plot_metric;
    
    if isequal(get(AVGOpen.handles.Bhold,'Value'),1),
      parent = AVGOpen.gui;
    else
      if isfield(AVGOpen,'parent'),
        parent = AVGOpen.parent.gui;
      else
        parent = [];
      end
    end
    
    if isempty(parent), [Xpoint,Ypoint] = eeg_crosshair('init',AVGOpen.p);
    else                [Xpoint,Ypoint] = eeg_crosshair('init',AVGOpen.p,parent);
    end
    
  case 'return',
    
    AVGOpen.p = avg_open(AVGOpen.p);
    
  case 'save',
    
    fprintf('\nGUI_AVG_OPEN: Save As not implemented yet.\n');
    
  case 'cancel',
    
    GUI.parent = AVGOpen.parent;
    gui_updateparent(GUI);
    close gcbf;
    
  otherwise,
    
end



switch command,
  case {'init','cancel'},
  otherwise,
    set(AVGOpen.gui,'Pointer','arrow');
    set(AVGOpen.gui,'Userdata',AVGOpen);
    if isequal(get(AVGOpen.handles.Bhold,'Value'),1),
     [p] = gui_updateparent(AVGOpen,0);
    else
     [p] = gui_updateparent(AVGOpen);
      close gcbf;
    end
end



return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [AVGOpen] = INIT(p,parent)
% GUI General Parameters

GUIwidth  = 500;
GUIheight = 120;

version = '$Revision: 1.7 $';
name = sprintf('AVG File Open [v %s]\n',version(11:15));

GUI = figure('Name',name,'Tag','AVG_OPEN',...
  'NumberTitle','off',...
  'MenuBar','none','Position',[1 1 GUIwidth GUIheight]);
movegui(GUI,'center');

Font.FontName   = 'Helvetica';
Font.FontUnits  = 'Pixels';
Font.FontSize   = 12;
Font.FontWeight = 'normal';
Font.FontAngle  = 'normal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Voltage Data Selection and Parameters

G.Title_data = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .75 .17 .2],...
  'String','Data Type:','HorizontalAlignment','left');

switch lower(p.volt.type),
  case 'ascii',   voltType = 1;
  case 'emse',    voltType = 2;
  case 'scan4x',  voltType = 3;
  case 'scan3x',  voltType = 4;
  case 'matlab',  voltType = 5;
  otherwise,      voltType = 1;
end
G.PvoltType = uicontrol('Tag','PvoltType','Parent',GUI,'Style','popupmenu',...
  'Units','Normalized',Font,  ...
  'Position',[.20 .75 .2 .2],...
  'String',{'ASCII' 'EMSE' 'Scan4x' 'Scan3x' 'Matlab'},'Value',voltType,...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'AVGOpen.p.volt.type = popupstr(AVGOpen.handles.PvoltType);',...
  'set(gcbf,''Userdata'',AVGOpen); clear AVGOpen;'));

% ERP Parameters
G.Bascii = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.45 .75 .2 .2],...
  'String','ERP Parameters','BusyAction','queue',...
  'BackgroundColor',[0.0 0.0 0.75],...
  'ForegroundColor',[1 1 1], 'HorizontalAlignment', 'center',...
  'Callback','tempgui = gui_eeg_ascii_parameters(gcbf); clear tempgui;');

% Interpolate Zero
G.BinterpZero = uicontrol('Parent',GUI,'Style','checkbox','Units','Normalized', Font, ...
  'Position',[.80 .75 .18 .2],'String','Interp 0','BusyAction','queue',...
  'TooltipString','Interpolate zero, mainly for ascii, scan3x, scan4x files.',...
  'Value',p.volt.interpZero,'HorizontalAlignment', 'center',...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'AVGOpen.p.volt.interpZero = get(AVGOpen.handles.BinterpZero,''Value''); ',...
  'set(gcbf,''Userdata'',AVGOpen); clear AVGOpen;'));

G.Title_path = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .50 .17 .2],...
  'String','Path','HorizontalAlignment','left');
G.EvoltPath = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .50 .58 .2], 'String',p.volt.path,...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'AVGOpen.p.volt.path = get(AVGOpen.handles.EvoltPath,''String'');',...
  'set(gcbf,''Userdata'',AVGOpen); clear AVGOpen;'));

G.Title_file = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .25 .17 .2],...
  'String','File','HorizontalAlignment','left');
G.EvoltFile = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .25 .58 .2], 'String',p.volt.file,...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'AVGOpen.p.volt.file = get(AVGOpen.handles.EvoltFile,''String'');',...
  'set(gcbf,''Userdata'',AVGOpen); clear AVGOpen;'));

Font.FontWeight = 'bold';

% BROWSE: Look for the data
browsecommand = strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'cd(AVGOpen.p.volt.path);',...
  '[file, path] = uigetfile(',...
  '{''*.dat;*.asc;*.txt'', ''ASCII Data Files (*.dat,*.asc,*.txt)'';', ...
  ' ''*.avg'', ''NeuroScan Average (*.avg)'';', ...
  ' ''*.avg'', ''EMSE Average (*.avg)'';', ...
  ' ''*.mat'', ''MATLAB Data Files (*.mat)'';', ...
  ' ''*.*'',   ''All Files (*.*)''},', ...
  '''Select ERP File'');',...
  'if ~isequal(path,0), AVGOpen.p.volt.path = path; end;',...
  'if ~isequal(file,0), AVGOpen.p.volt.file = file; end;',...
  'set(AVGOpen.handles.EvoltPath,''String'',AVGOpen.p.volt.path);',...
  'set(AVGOpen.handles.EvoltFile,''String'',AVGOpen.p.volt.file);',...
  'if ~isempty(findstr(file,''.dat'')) | ~isempty(findstr(file,''.txt'')) | ~isempty(findstr(file,''.asc'')), ',...
  '  set(AVGOpen.handles.PvoltType,''Value'',1); ',...
  '  AVGOpen.p.volt.type = popupstr(AVGOpen.handles.PvoltType);',...
  'elseif ~isempty(findstr(file,''.avg'')), ',...
  '  set(AVGOpen.handles.PvoltType,''Value'',3); ',...
  '  AVGOpen.p.volt.type = popupstr(AVGOpen.handles.PvoltType);',...
  'else, ',...
  '  set(AVGOpen.handles.PvoltType,''Value'',5); ',...
  '  AVGOpen.p.volt.type = popupstr(AVGOpen.handles.PvoltType);',...
  'end;',...
  'set(gcbf,''Userdata'',AVGOpen); clear AVGOpen file path;');
G.BvoltFile = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized',Font, ...
  'Position',[.01 .01 .17 .2], 'String','BROWSE',...
  'BackgroundColor',[0.8 0.8 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback', browsecommand );

% PLOT: Load & plot the data!
G.Bplot = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.20 .01 .18 .2],...
  'String','PLOT','BusyAction','queue',...
  'TooltipString','Plot the AVG data and return p struct.',...
  'BackgroundColor',[0.0 0.5 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'p = gui_avg_open(AVGOpen.p,''plot'');',...
  'clear AVGOpen;'));

% Save As
G.Bsave = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.40 .01 .18 .2],'HorizontalAlignment', 'center',...
  'String','SAVE AS','TooltipString','AVG File Conversion Tool (not implemented yet)',...
  'BusyAction','queue',...
  'Visible','on',...
  'BackgroundColor',[0.0 0.0 0.75],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'p = gui_avg_open(AVGOpen.p,''save'');',...
  'clear AVGOpen;'));

% Quit, return file parameters
G.Breturn = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.60 .01 .18 .2],...
  'String','RETURN','BusyAction','queue',...
  'TooltipString','Return p struct to workspace and parent GUI.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'p = gui_avg_open(AVGOpen.p,''return'');',...
  'clear AVGOpen;'));

% Cancel
G.Bcancel = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.80 .01 .18 .2],...
  'String','CANCEL','BusyAction','queue',...
  'TooltipString','Close, do not return parameters.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('AVGOpen = get(gcbf,''Userdata'');',...
  'p = gui_avg_open(AVGOpen.p,''cancel'');',...
  'clear AVGOpen;'));

% Help
G.Bhelp = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.80 .25 .18 .2],'String','Help','BusyAction','queue',...
  'BackgroundColor',[1 1 0],...
  'ForegroundColor',[0 0 0], 'HorizontalAlignment', 'center',...
  'Callback','doc avg_open;');

G.Bhold = uicontrol('Parent',GUI,'Style','checkbox','Units','Normalized', Font, ...
  'Position',[.80 .50 .18 .2],'String','Hold GUI','BusyAction','queue',...
  'TooltipString','AVG File Load GUI remains open after ''Plot'' or ''Return'' commands.',...
  'Value',p.hold,'HorizontalAlignment', 'center');


% Store userdata
if exist('parent','var'), AVGOpen.parent.gui = parent; end
AVGOpen.gui = GUI;          
AVGOpen.handles = G;
AVGOpen.p = p;
set(GUI,'Userdata',AVGOpen);
set(GUI,'HandleVisibility','callback');

return
