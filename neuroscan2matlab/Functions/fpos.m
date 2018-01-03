function fpos(fid,pos);
%FPOS Reposition file.
%	FPOS(FID,POS) Reposition the file, fid identification number, 
%	to position pos from beginning. If pos>size(file) adds zeros
%	to end, file must be opened for writing.
%
%SEE ALSO
%	Uses fseek.
%
%EXAMPLES
%	fpos(fid,100);

%	J.Virkkala 16-Jun-94
%	J.Virkkala  6-Mar-95 Part of ScanUtil.

if nargin~=2;help fpos;else
  fseek(fid,0,1);
  size=ftell(fid);
  if size<pos;fwrite(fid,zeros(1,pos-size),'int8');end;
  fseek(fid,pos,-1);
end;

% END OF FPOS