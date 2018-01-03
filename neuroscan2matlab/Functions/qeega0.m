function [o1,o2,o3,o4,o5,o6,o7,o8,o9,o10]=qeega0(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
%QEEGA0 Quantitative EEG analysis, version a.             
%	QEEGA Following Rx or QEEGAx depending if you use macro
%	or converted m files:                                   
%                                                         
%	0) This help screen.							                             
%	1) Ask file name, show data for selection.				          
%	2) Show selected raw data, calculate FFT.		             
%	3) Show FFT and derived parameters.			                  
%	4) Create axes.						                                   
%	5) Derive parameters. 					                             
%       6) Create, analyze test signal.                   
%                                                         
%DIAGNOSTICS                                              
%	Used global variabels are HDL, HDLS, A, P, P2, A2, PA, PAA.
%                                                         
%EXAMPLES                                                 
%	qeega1('testec.cnt');                                   
%  qeega1
%	evalstr(R1,'testec.cnt');                               
%	evalstr(R6);                                            

%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR,  4-Feb-1999 

qeega1

%qeega0                                               
