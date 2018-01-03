function [name,pat]=filename(fid);
%FILENAME Return name, path from file identification number.
%	[NAME,PAT]=FILENAME(FID) Return name, path. Extension is removed
%	from name.
%
%SEE ALSO
%	Findpath.
%
%EXAMPLES
%	f1=fopen('c:\autoexec.bat');
%	[n,p]=filename(f1)

%Mention source when using or modifying these Shareware tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  3-Feb-1999 Modified for PCWIN Matlab 5.2.

%JVIR, Jussi.Virkkala@occuphealth.fi

%JVIR, 10-Feb-1999 Filepath can contain . characters
%JVIR, 31-Jan-1999 Changes for Matlab 5.2, ~= by isempty

%	J.Virkkala 21-Feb-95 For scanevent, scanelec.
%	J.Virkkala  5-Mar-95 Part of ScanUtil.
%	J.Virkkala 24-May-95 Returning pat and using DIRS for uihelp.

global DIRS
%JVIR
if fid<0,
   errorr('hff not found','filename')
   return
end
name=fopen(fid);	% remove extra
a1=find(name==DIRS);
if isempty(a1),a1=0;end 
a2=find(name=='.');
%JVIR, filename can contain
a2=max(a2);
pat=name(1:a1(size(a1,2)));
name=[name(a1(size(a1,2))+1:a2(1)-1)];

%END OF FILENAME