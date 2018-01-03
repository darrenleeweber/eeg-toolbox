function [l] = freesurfer_read_label(sname, lname)
% l = freesurfer_read_label(<sname>, lname)
%
% reads the label file 'lname' from the subject 'sname' 
% in the subject's label directory into the vector l, where
% l will be nvertices-by-5 and each column means:
% (1) vertex number, (2-4) xyz at each vertex, (5) stat
%
% The Label file format (ascii):
% 
% The first line is a comment (may have subject name).
% The second line has the number of points in the label.
% Subsequent lines have 5 columns:
% 
% 1. Vertex number (0-based !)
% 2-4. RAS of the vertex
% 5. Statistic (which can be ignored)
% 
% see also, freesurfer_label2annotation, freesurfer_read_surf
%


l = [];

if(nargin ~= 2)
  fprintf('l = read_label(<sname>, lname)\n');
  return;
end

if(~isempty(sname))
  sdir = getenv('SUBJECTS_DIR');
  fname = sprintf('%s/%s/label/%s.label', sdir, sname, lname);
else
  fname = lname;
end

% open it as an ascii file
fid = fopen(fname, 'r');
if(fid == -1)
  fprintf('ERROR: could not open %s\n',fname);
  return;
end

fgets(fid);
if(fid == -1)
  fprintf('ERROR: could not open %s\n',fname);
  return;
end

line = fgets(fid);
nv = sscanf(line, '%d');
l = fscanf(fid, '%d %f %f %f %f\n');
l = reshape(l, 5, nv);
l = l';

fclose(fid);

return
