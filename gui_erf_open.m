function [p] = gui_erf_open(p,command,parent)

% gui_erf_open - Load averaged ERF data into matlab workspace
% 
% Usage: [p] = gui_erf_open(p,[command],[parent])
% 
% p is a structure, generated by 'eeg_toolbox_defaults'
% command is either 'init' or 'load'
% parent is a handle to the gui that calls this gui, useful
% for updating the UserData field of the parent from this gui.
% The p structure is returned to the parent when the parent 
% handle is given.
% 

% $Revision: 1.2 $ $Date: 2004/04/16 18:49:10 $

% Licence:  GNU GPL, no express or implied warranties
% History:  02/2004, Darren.Weber_at_radiology.ucsf.edu
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
      ERFOpen = INIT(p,parent);
    else
      ERFOpen = INIT(p,'');
    end
  otherwise,
    ERFOpen = get(gcbf,'Userdata');
    set(ERFOpen.gui,'Pointer','watch');
end


switch command,
  
  case 'plot',
    
    ERFOpen.p = erf_open(ERFOpen.p,ERFOpen.gui);
    
    plotfig = figure('Name',ERFOpen.p.erf.file,...
      'NumberTitle','off',...
      'UserData',ERFOpen.p);
    movegui(plotfig,'center');
    
    plot(ERFOpen.p.erf.timeArray,ERFOpen.p.erf.data); axis tight;
    eeg_plot_metric;
    
    if isequal(get(ERFOpen.handles.Bhold,'Value'),1),
      parent = ERFOpen.gui;
    else
      if isfield(ERFOpen,'parent'),
        parent = ERFOpen.parent.gui;
      else
        parent = [];
      end
    end
    
    if isempty(parent), [Xpoint,Ypoint] = eeg_crosshair('init',ERFOpen.p);
    else                [Xpoint,Ypoint] = eeg_crosshair('init',ERFOpen.p,parent);
    end
    
  case 'return',
    
    ERFOpen.p = erf_open(ERFOpen.p);
    
  case 'save',
    
    fprintf('\nGUI_ERF_OPEN: Save As not implemented yet.\n');
    
  case 'cancel',
    
    GUI.parent = ERFOpen.parent;
    gui_updateparent(GUI);
    close gcbf;
    
  otherwise,
    
end



switch command,
  case {'init','cancel'},
  otherwise,
    set(ERFOpen.gui,'Pointer','arrow');
    set(ERFOpen.gui,'Userdata',ERFOpen);
    if isequal(get(ERFOpen.handles.Bhold,'Value'),1),
     [p] = gui_updateparent(ERFOpen,0);
    else
     [p] = gui_updateparent(ERFOpen);
      close gcbf;
    end
end



return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ERFOpen] = INIT(p,parent)
% GUI General Parameters

GUIwidth  = 500;
GUIheight = 120;

version = '$Revision: 1.2 $';
name = sprintf('ERF File Open [v %s]\n',version(11:15));

GUI = figure('Name',name,'Tag','ERF_OPEN',...
  'NumberTitle','off',...
  'MenuBar','none','Position',[1 1 GUIwidth GUIheight]);
movegui(GUI,'center');

Font.FontName   = 'Helvetica';
Font.FontUnits  = 'Pixels';
Font.FontSize   = 12;
Font.FontWeight = 'normal';
Font.FontAngle  = 'normal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Potential Field Data Selection and Parameters

G.Title_data = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .75 .17 .2],...
  'String','Data Type:','HorizontalAlignment','left');

switch lower(p.erf.type),
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
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'ERFOpen.p.erf.type = popupstr(ERFOpen.handles.PvoltType);',...
  'set(gcbf,''Userdata'',ERFOpen); clear ERFOpen;'));

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
  'Value',p.erf.interpZero,'HorizontalAlignment', 'center',...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'ERFOpen.p.erf.interpZero = get(ERFOpen.handles.BinterpZero,''Value''); ',...
  'set(gcbf,''Userdata'',ERFOpen); clear ERFOpen;'));

G.Title_path = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .50 .17 .2],...
  'String','Path','HorizontalAlignment','left');
G.EvoltPath = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .50 .58 .2], 'String',p.erf.path,...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'ERFOpen.p.erf.path = get(ERFOpen.handles.EvoltPath,''String'');',...
  'set(gcbf,''Userdata'',ERFOpen); clear ERFOpen;'));

G.Title_file = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .25 .17 .2],...
  'String','File','HorizontalAlignment','left');
G.EvoltFile = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .25 .58 .2], 'String',p.erf.file,...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'ERFOpen.p.erf.file = get(ERFOpen.handles.EvoltFile,''String'');',...
  'set(gcbf,''Userdata'',ERFOpen); clear ERFOpen;'));

Font.FontWeight = 'bold';

% BROWSE: Look for the data
browsecommand = strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'cd(ERFOpen.p.erf.path);',...
  '[file, path] = uigetfile(',...
  '{''*.ds'', ''CTF dataset, averaged erf (*.ds)'';', ...
  '''*.dat;*.asc;*.txt'', ''ASCII Data Files (*.dat,*.asc,*.txt)'';', ...
  ' ''*.avg'', ''EMSE Average (*.avg)'';', ...
  ' ''*.mat'', ''MATLAB Data Files (*.mat)'';', ...
  ' ''*.*'',   ''All Files (*.*)''},', ...
  '''Select ERF File'');',...
  'if ~isequal(path,0), ERFOpen.p.erf.path = path; end;',...
  'if ~isequal(file,0), ERFOpen.p.erf.file = file; end;',...
  'set(ERFOpen.handles.EvoltPath,''String'',ERFOpen.p.erf.path);',...
  'set(ERFOpen.handles.EvoltFile,''String'',ERFOpen.p.erf.file);',...
  'if ~isempty(findstr(file,''.dat'')) | ~isempty(findstr(file,''.txt'')) | ~isempty(findstr(file,''.asc'')), ',...
  '  set(ERFOpen.handles.PvoltType,''Value'',1); ',...
  '  ERFOpen.p.erf.type = popupstr(ERFOpen.handles.PvoltType);',...
  'elseif ~isempty(findstr(file,''.erf'')), ',...
  '  set(ERFOpen.handles.PvoltType,''Value'',3); ',...
  '  ERFOpen.p.erf.type = popupstr(ERFOpen.handles.PvoltType);',...
  'else, ',...
  '  set(ERFOpen.handles.PvoltType,''Value'',5); ',...
  '  ERFOpen.p.erf.type = popupstr(ERFOpen.handles.PvoltType);',...
  'end;',...
  'set(gcbf,''Userdata'',ERFOpen); clear ERFOpen file path;');
G.BvoltFile = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized',Font, ...
  'Position',[.01 .01 .17 .2], 'String','BROWSE',...
  'BackgroundColor',[0.8 0.8 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback', browsecommand );

% PLOT: Load & plot the data!
G.Bplot = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.20 .01 .18 .2],...
  'String','PLOT','BusyAction','queue',...
  'TooltipString','Plot the ERF data and return p struct.',...
  'BackgroundColor',[0.0 0.5 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'p = gui_erf_open(ERFOpen.p,''plot'');',...
  'clear ERFOpen;'));

% Save As
G.Bsave = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.40 .01 .18 .2],'HorizontalAlignment', 'center',...
  'String','SAVE AS','TooltipString','ERF File Conversion Tool (not implemented yet)',...
  'BusyAction','queue',...
  'Visible','on',...
  'BackgroundColor',[0.0 0.0 0.75],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'p = gui_erf_open(ERFOpen.p,''save'');',...
  'clear ERFOpen;'));

% Quit, return file parameters
G.Breturn = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.60 .01 .18 .2],...
  'String','RETURN','BusyAction','queue',...
  'TooltipString','Return p struct to workspace and parent GUI.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'p = gui_erf_open(ERFOpen.p,''return'');',...
  'clear ERFOpen;'));

% Cancel
G.Bcancel = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.80 .01 .18 .2],...
  'String','CANCEL','BusyAction','queue',...
  'TooltipString','Close, do not return parameters.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('ERFOpen = get(gcbf,''Userdata'');',...
  'p = gui_erf_open(ERFOpen.p,''cancel'');',...
  'clear ERFOpen;'));

% Help
G.Bhelp = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.80 .25 .18 .2],'String','Help','BusyAction','queue',...
  'BackgroundColor',[1 1 0],...
  'ForegroundColor',[0 0 0], 'HorizontalAlignment', 'center',...
  'Callback','doc erf_open;');

G.Bhold = uicontrol('Parent',GUI,'Style','checkbox','Units','Normalized', Font, ...
  'Position',[.80 .50 .18 .2],'String','Hold GUI','BusyAction','queue',...
  'TooltipString','ERF File Load GUI remains open after ''Plot'' or ''Return'' commands.',...
  'Value',p.hold,'HorizontalAlignment', 'center');


% Store userdata
if exist('parent','var'), ERFOpen.parent.gui = parent; end
ERFOpen.gui = GUI;          
ERFOpen.handles = G;
ERFOpen.p = p;
set(GUI,'Userdata',ERFOpen);
set(GUI,'HandleVisibility','callback');

return
