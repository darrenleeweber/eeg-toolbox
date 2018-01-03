function [cnt] = eeg_view_cnt(filename,command,parent)

% EEG_VIEW_CNT: Plot scan CNT data
% 
% eeg_view_cnt(filename,command,parent)
% 
%   filename    -   a string filename
%   command     -   a string, 'init', 'hslider', 'vslider'
%   parent      -   optional, for GUI parent
% 
% Note: Works only with Scan 4.1+ data files
% 

% Licence:  GNU GPL, no express or implied warranties
% History:  2002, Sean.Fitzgibbon@flinders.edu.au
%           06/2002, Darren.Weber@flinders.edu.au
%                    adapted to eeg_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('filename','var'),
    msg = sprintf('EEG_VIEW_CNT: No input filename\n');
    error(msg);
end
if ~exist('command','var'), command = 'init'; end


switch command,

case 'init',
    
    % Load first 2000 points of CNT file
    cnt = eeg_load_scan4_cnt(filename,'all',[1 2000]);
    
    if exist('parent','var'),
        VIEWCNT = INIT(cnt,parent);
    else
        VIEWCNT = INIT(cnt);
    end
    
case 'hslider',
    
case 'vslider',
    
otherwise
    close gcbf;
end


return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [VIEWCNT] = INIT(cnt,parent),
    
    % GUI General Parameters
    
    GUIwidth  = 150;
    GUIheight =  40;
    
    GUI = figure('Name','CNT View','Tag','CNTVIEW',...
                 'NumberTitle','off',...
                 'units','characters',...
                 'MenuBar','none','Position',[1 1 GUIwidth GUIheight]);
    movegui(GUI,'center');
    
    VIEWCNT.gui = GUI;
    
    VIEWCNT.axes = axes('Parent',GUI,'YDir','reverse');
    
    Font.FontName   = 'Helvetica';
    Font.FontUnits  = 'Pixels';
    Font.FontSize   = 12;
    Font.FontWeight = 'normal';
    Font.FontAngle  = 'normal';
    
    % ---- Display Parameters
    
    data.dispSeconds =  1; % seconds per screen
    data.chanPage =  4; % channels displayed per page (not used yet)
    
    % ---- Control Parameters
    
    data.points = size(cnt.volt,1);
    data.nChan  = size(cnt.volt,2);
    data.cnt    = cnt;
    
    data.dispNPoints = data.dispSeconds * data.cnt.srate;
    data.dispSPoint = 1;
    data.dispEPoint = data.dispSPoint - 1 + data.dispNPoints;
    
    if (data.points < data.dispEPoint),
        data.dispEPoint = data.points;
    end
    
    stime = (data.dispSPoint / cnt.srate) * 1000;
    etime = (data.dispEPoint / cnt.srate) * 1000;
    data.tstep = (1/cnt.srate) * 1000;
    
    data.time = [stime:data.tstep:etime]';
    
    set(VIEWCNT.axes,'XLim',[data.time(1) data.time(end)]);
    
    % Baseline data on first 100 msec
    data.base = data.dispSPoint:data.dispSPoint + cnt.srate * .1;
    data.dispmean = mean(data.cnt.volt(data.base,:));
    mean = repmat(data.dispmean,data.dispNPoints,1);
    volt = data.cnt.volt(data.dispSPoint:data.dispEPoint,:);
    volt = volt - mean;
    
    plot(data.time,volt);
    
    eeg_plot_metric;    
    
    %dataSD   = std(data);
    %dataVar  = var(data);
    %dataMean = repmat(dataMean,points,1);
    %dataVar  = repmat(dataVar ,points,1);
    %data = (data - dataMean) ./ dataVar;
    %increment = [1:nChan];
    %data = data + repmat(increment,points,1);
    if isfield(cnt,'labels'),
        data.labels = cnt.labels;
    else
        data.labels = [];
    end
    if (length(data.labels) ~= data.nChan),
        data.labels = [];
    end
    %set(VIEWCNT.axes,'YTick',increment,'YTickLabel',labels);
    
    axpos = get(VIEWCNT.axes,'position');
    
    tpos = [ axpos(1,1)-.12 .01 .12        .05];
    spos = [ axpos(1,1)     .01 axpos(1,3) .05];
    
    
    data.totalmsec = (cnt.srate/1000) * cnt.numSamples;
    hbuttonstep = .01; % move 1% of datafile
    hsliderstep = .05; % move 5% of datafile
    horizSliderStep = [ hbuttonstep hsliderstep ];
    
    G.Tslider = uicontrol(GUI,'style','text','units','normalized',Font,...
        'Position',tpos,...
        'TooltipString','% of CNT file',...
        'String',sprintf('%6.2f sec',1/cnt.srate),...
        'HorizontalAlignment', 'center');
    G.Slider = uicontrol(GUI,'style','slider','units','normalized',Font,...
        'Position',spos,...
        'sliderstep',horizSliderStep, ...
        'min',1,'max',cnt.numSamples,'value',1,...
        'Callback',strcat('VIEWCNT = get(gcbf,''userdata'');',...
            'slider = get(VIEWCNT.handles.Slider,''Value''); ',...
            'sec = slider/VIEWCNT.data.cnt.srate; ',...
            'set(VIEWCNT.handles.Tslider,''String'',sprintf(''%6.2f sec'',sec)); ',...
            'point = round(slider); ',...
            'if (point > VIEWCNT.data.dispEPoint), ',...
            '   range(1) = VIEWCNT.data.dispEPoint; ',...
            '   range(2) = VIEWCNT.data.dispEPoint + VIEWCNT.data.dispNPoints; ',...
            '   if (range(2) > VIEWCNT.data.cnt.numSamples), ',...
            '       range(2) = VIEWCNT.data.cnt.numSamples; ',...
            '   end; ',...
            '   fprintf(''display out of range\n''); ',...
            'end; ',...
            'clear slider sec point range VIEWCNT;'));
    
    G.seconds = uicontrol(GUI,'style','edit','units','normalized',Font,...
        'Position',[.92 .7 .075 .05],...
        'TooltipString','Display Seconds',...
        'String',sprintf('%3.1f',data.dispSeconds), ...
        'min',1,'max',data.points/cnt.srate,...
        'Callback',strcat('VIEWCNT = get(gcbf,''userdata'');',...
            'seconds = get(VIEWCNT.handles.seconds,''String'');',...
            'seconds = str2num(seconds);',...
            'if (seconds <= 0), seconds = 0.1; end;',...
            'if (seconds > VIEWCNT.data.points / VIEWCNT.data.cnt.srate ),',...
            '   totalseconds = VIEWCNT.data.cnt.numSamples / VIEWCNT.data.cnt.srate; ',...
            '   if(seconds > totalseconds ),',...
            '      seconds = totalseconds; ',...
            '      filename = VIEWCNT.data.cnt.filename; ',...
            '      VIEWCNT.data.cnt = eeg_load_scan41_cnt(filename,''all'',''all''); ',...
            '      clear filename; ',...
            '   else, ',...
            '      seconds = VIEWCNT.data.points / VIEWCNT.data.cnt.srate;',...
            '   end; ',...
            'end;',...
            'VIEWCNT.data.dispSeconds = seconds; ',...
            'VIEWCNT.data.dispNPoints = VIEWCNT.data.dispSeconds * VIEWCNT.data.cnt.srate; ',...
            'VIEWCNT.data.dispEPoint = VIEWCNT.data.dispSPoint - 1 + VIEWCNT.data.dispNPoints; ',...
            'stime = (VIEWCNT.data.dispSPoint/VIEWCNT.data.cnt.srate) * 1000; ',...
            'etime = (VIEWCNT.data.dispEPoint/VIEWCNT.data.cnt.srate) * 1000; ',...
            'VIEWCNT.data.time = [stime:VIEWCNT.data.tstep:etime]''; ',...
            'set(VIEWCNT.axes,''XLim'',[VIEWCNT.data.time(1) VIEWCNT.data.time(end)]); ',...
            'VIEWCNT.data.dispmean = mean(VIEWCNT.data.cnt.volt(VIEWCNT.data.base,:)); ',...
            'repmean = repmat(VIEWCNT.data.dispmean,VIEWCNT.data.dispNPoints,1); ',...
            'volt = VIEWCNT.data.cnt.volt(VIEWCNT.data.dispSPoint:VIEWCNT.data.dispEPoint,:); ',...
            'volt = volt - repmean; ',...
            'plot(VIEWCNT.data.time,volt); ',...
            'eeg_plot_metric; ',...
            'set(VIEWCNT.gui,''userdata'',VIEWCNT); ',...
            'clear seconds totalseconds stime etime repmean volt VIEWCNT;'));
    
    % Baseline data interface
    G.baseline = uicontrol(GUI,'style','edit','units','normalized',Font,...
        'Position',[.92 .8 .075 .05],...
        'TooltipString','Baseline Milliseconds',...
        'String',100,...
        'min',1,'max',(data.dispNPoints/data.cnt.srate)*1000,...
        'Callback',strcat('VIEWCNT = get(gcbf,''userdata'');',...
            'base = get(VIEWCNT.handles.baseline,''String'');',...
            'base = round(str2num(base));',...
            'if (base < 1), base = 1; end;',...
            'maxbase = (VIEWCNT.data.dispNPoints/VIEWCNT.data.cnt.srate)*1000;',...
            'if (base > maxbase), base = maxbase; end;',...
            'if (base ~= 0),',...
            '  base = base / 1000;',...
            '  endbase = round(VIEWCNT.data.dispSPoint - 1 + VIEWCNT.data.cnt.srate * base); ',...
            '  if (endbase <= VIEWCNT.data.dispSPoint), endbase = VIEWCNT.data.dispSPoint + 1; end; ',...
            '  VIEWCNT.data.base = VIEWCNT.data.dispSPoint:endbase;',...
            '  VIEWCNT.data.dispmean = mean(VIEWCNT.data.cnt.volt(VIEWCNT.data.base,:));',...
            '  repmean = repmat(VIEWCNT.data.dispmean,VIEWCNT.data.dispNPoints,1);',...
            '  volt = VIEWCNT.data.cnt.volt(VIEWCNT.data.dispSPoint:VIEWCNT.data.dispEPoint,:);',...
            '  volt = volt - repmean;',...
            '  plot(VIEWCNT.data.time,volt);',...
            'else, ',...
            '  volt = VIEWCNT.data.cnt.volt(VIEWCNT.data.dispSPoint:VIEWCNT.data.dispEPoint,:);',...
            '  plot(VIEWCNT.data.time,volt,''k-'');',...
            'end; ',...
            'eeg_plot_metric; ',...
            'set(VIEWCNT.gui,''userdata'',VIEWCNT);',...
            'clear base maxbase endbase repmean volt VIEWCNT;'));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Font.FontWeight = 'bold';
    
    G.exit = uicontrol(GUI,'style','pushbutton','units','normalized',Font,...
        'Position',[.925 .01 .07 .05],...
        'TooltipString','Close',...
        'String','EXIT',...
        'BackgroundColor',[0.75 0.0 0.0],...
        'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
        'Callback','close gcbf;');
    
    VIEWCNT.data = data;
    VIEWCNT.handles = G;
    set(VIEWCNT.gui,'userdata',VIEWCNT);
    
    
return
