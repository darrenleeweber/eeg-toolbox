function s=str2mat(varargin)
%STR2MAT Form blank padded character matrix from strings.
%   S = STR2MAT(T1,T2,T3,..) forms the matrix S containing the text
%   strings T1,T2,T3,... as rows.  Automatically pads each string with
%   blanks in order to form a valid matrix.  Each text parameter, Ti,
%   can itself be a string matrix.  This allows the creation of
%   arbitarily large string matrices.  Empty strings are significant.
%
%   STR2MAT differs from STRVCAT in that empty strings produce blank rows
%   in the output.  In STRVCAT, empty strings are ignored.
%
%   See also STRVCAT.

%   Clay M. Thompson  3-20-91, 5-16-95
%   Copyright (c) 1984-96 by The MathWorks, Inc.
%   $Revision: 1.2 $  $Date: 2003/10/29 01:59:00 $

if nargin==0, s = ''; return, end

for i=nargin:-1:1
  [m,n] = size(varargin{i});
  nrows(i) = max(m,1);
  ncols(i) = n;
end

% Now form the string matrix.
% Determine the largest string size.
s=repmat(' ',sum(nrows),max(ncols));
Ct=1;
for i=1:nargin  
  if ncols(i)~=0,  
    s(Ct:Ct+nrows(i)-1,1:ncols(i))=varargin{i};
  end    
  Ct=Ct+nrows(i);  
end  
