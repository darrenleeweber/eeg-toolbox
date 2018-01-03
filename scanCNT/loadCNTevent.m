function f = eeg_loadCNTevent(fid)% eventTable = eeg_loadCNTevent(fid)%               %   fid         -  File identifier%%   eventTable  -  structure of event info%%   -- Note: Works only with Scan 4.1+ data files% Licence:  GNU GPL, no express or implied warranties% History:  2002, Sean.Fitzgibbon@flinders.edu.au%           06/2002, Darren.Weber@flinders.edu.au%                    adapted to eeg_toolbox%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fseek(fid,886,'bof');           eventPos = fread(fid,1,'long');
fseek(fid,eventPos,'bof');      f.type   = fread(fid,1,'uchar');
                                f.size   = fread(fid,1,'long');                                f.offset = fread(fid,1,'long');                                
fseek(fid,f.offset,'cof');
for i = 1:(f.size/19),    
    f.event(i).stimType   = fread(fid,1,'short');    
    f.event(i).keyBoard   = fread(fid,1,'char');    
    f.event(i).keyPad     = fread(fid,1,'bit4');    
    f.event(i).Accept     = fread(fid,1,'bit4');    
    f.event(i).offset     = fread(fid,1,'long');    
    f.event(i).type       = fread(fid,1,'short');    
    f.event(i).code       = fread(fid,1,'short');    
    f.event(i).latency    = fread(fid,1,'float');    
    f.event(i).epochEvent = fread(fid,1,'char');    
    f.event(i).accept     = fread(fid,1,'char');    
    f.event(i).accuracy   = fread(fid,1,'char');    
end