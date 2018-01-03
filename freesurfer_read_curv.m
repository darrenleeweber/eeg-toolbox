function [curv, fnum] = freesurfer_read_curv(fname)

% freesurfer_read_curv - FreeSurfer I/O function to read a curvature file
%
% [curv, fnum] = freesurfer_read_curv(fname)
% 
% reads a binary curvature file into a vector
%
% After reading an associated surface, with freesurfer_read_surf, try:
% patch('vertices',vert,'faces',face,...
%       'facecolor','interp','edgecolor','none',...
%       'FaceVertexCData',curv); light
% 
% See also freesurfer_write_curv, freesurfer_read_surf, freesurfer_read_wfile


% open it as a big-endian file
fid = fopen(fname, 'rb', 'b') ;
if (fid < 0),
    str = sprintf('could not open curvature file %s.', fname) ;
    error(str) ;
end

vnum = freesurfer_fread3(fid);
NEW_VERSION_MAGIC_NUMBER = 16777215;
if (vnum == NEW_VERSION_MAGIC_NUMBER),
    fprintf('...reading new version (float)\n');
    vnum = fread(fid, 1, 'int32') ;
    fnum = fread(fid, 1, 'int32') ;
    vals_per_vertex = fread(fid, 1, 'int32') ;
    curv = fread(fid, vnum, 'float') ; 
else
    fprintf('...reading old version (int16)\n');
    fnum = freesurfer_fread3(fid) ;
    curv = fread(fid, vnum, 'int16') ./ 100 ; 
end

fclose(fid) ;

return
