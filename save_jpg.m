function save_jpg(file,F, res)

% save_jpg - Save figure to JPG file
% 
% Usage: save_jpg(file,F,res)
% 
% 'file'    - the string filename
% 'F'       - a figure handle, when empty uses 'gcf'
% 'res'     - resolution, 600 dpi default
% 
% Outputs JPEG 90% quality (600 dpi)
% 

% $Revision: 1.1 $ $Date: 2004/04/16 18:49:11 $

% Licence:  GNU GPL, no implied or express warranties
% History:  02/2004, Darren.Weber_at_radiology.ucsf.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('F','var'),
    if isempty(F), F = gcf; end
else
    F = gcf;
end
if exist('file','var'),
    if isempty(file), error('no filename'); end
else
    error('no filename');
end
if exist('res','var'),
    if isempty(res), res = 600; end
else
    res = 600;
end



driver = '-djpeg90';
option1 = '-noui';
option2 = sprintf('-r%d',res);
%option3 = '-zbuffer';
fprintf('saving to:...%s\n',file);
print(F,driver,option1,option2,file);

return
