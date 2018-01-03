function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=scantut2(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%SCANTUT2 Save text for tutorial document.
%	SCANTUT2

global R3 R4 R5 R6 R7 R7 R8 R9 DIRS

savestr(R7,['datah' DIRS 'headt.tex']);
savestr(R8,['datah' DIRS 'elect.tex']);
savestr(R9,['datah' DIRS 'event.tex']);

bv='\begin{verbatim}';
ev='\end{verbatim}';
savestr(str2mat(bv,R3,ev),['datah' DIRS 'headv.tex']);
savestr(str2mat(bv,R4,ev),['datah' DIRS 'evenv.tex']);
savestr(str2mat(bv,R5,ev),['datah' DIRS 'loadv.tex']);
	% remove first row away
savestr(str2mat(bv,R6(2:size(R6,1)-1,:),ev),['datah' DIRS 'analv.tex']);
global x y la ot
[x,y,la,el,ca,ot]=loadcnt('testec.cnt',[],1,1000);	
scantut6
setobj('keep')
print datah\anal2 -deps
close
setobj('keep')
print datah\anal1 -deps

