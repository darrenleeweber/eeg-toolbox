function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=scantut1(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%SCANTUT1 Create pages R7, R8, R9.            
%	SCANTUT1                                    
%                                             
                                              
global R7 R8 R9                               
showwait('loading all header var - %1.0f');   
[v,t]=scanhead([]);                           
t=[blanks(size(t,1))' t];                     
R7=tiestr(str2mat('\tt{','} & ',' \\'),v,t);
showwait([]);                                 
                                              
showwait('loading all electrode var - %1.0f');
[v,t]=scanelec([]);                           
t=[blanks(size(t,1))' t];                     
R8=tiestr(str2mat('\tt{','} & ',' \\'),v,t);
showwait([]);                                 
                                              
showwait('loading all event var - %1.0f');    
[v,t]=scaneven([],[]);                        
t=[blanks(size(t,1))' t];                     
R9=tiestr(str2mat('\tt{','} & ',' \\'),v,t);
showwait([]);                                 
