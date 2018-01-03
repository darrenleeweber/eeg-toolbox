function cont=crearefe(file,fcn,what)
%CREAREFE Create HTML reference text.
%	CONT=CREAREFE(FILE,FCN,WHAT) Create reference file from current 
%	Contents file. File is base for toolbox reference manual.
%
%	Use tabulator in creating m files, not spaces, except in Examples
%	part. Multiple paragraphs are only allowed in Description part.
%	Notice that there some forbidden characters for LaTex, some of
%	those are converted. Style file used is utildocu. If name.eps file
%	exist that is added by refeentf. Referred Latex definitions are
%	refesecb, refeseci, refesece, refeentb, fereenti, refeents, 
%	refeente, refeentv and refeentf.
%
%DIAGNOSTICS
%	If error encourted look that function's help is made in correct
%	format, using tabulator and correct headers. This file is going to
%	be obsolete.
%
%SEE ALSO
%	Uses creahtml, findstr, loadstr, savestr.
%
%EXAMPLES
%	h=crearefe('loadcnt',1)         % return parts
%	crearefe(h,2,'Purpose')
%	crearefe('Help\scanrefe.tex'); % create reference part

%	crearefe('Help\aumarefe.tex');
%	crearefe('Help\edsarefe.tex');

%Mention source when using or modifying these tools
%JVIR, Jussi.Virkkala@occuphealth.fi
%JVIR, 10-Feb-1999 Use creahtml.
%JVIR,  2-Feb-1999 Modified for PCWIN Matlab 5.2.

%       J.Virkkala  6-Mar-95 Part of ScanUtil.
%       J.Virkkala 21-May-95 More like regutool and Matlab documentation.

		% entry parts
EP=['Purpose    ';...
    'Synopsis   ';...
    'Description';...
    'Examples   ';...
    'Algorithm  ';...
    'Limitations';...
    'Diagnostics';...
    'See also   ';...
    'References '];

		% characters to be convert
CS1=['_         ';
     '%         ';
     '<         ';
     '>         ';
     '#         '];

CS2=['\_        ';
     '\%        ';    
     '$<$       ';
     '$>$       ';
     '\#        '];

CS3='\\';

global DIRS

%*** CREATING REFERENCE TEXT ***
if nargin==1,
% file=['datah' DIRS file];
  savestr(' ',file);
  cont=loadstr('Contents.m');
  gate=strfind(cont,'%           ');
  n=size(gate,1)-1;
  disp(' ');

%*** LIST OF FUNCTIONS GROUPED BY SUBJECT AREA ***
  fcns=[];
  disp('crearefe : Updating Gategories.');
  for i=1:n,    % n
    row=deblanks(cont(gate(i,1)+1,:));
    row=row(2:length(row)-1);
    disp(['         *' row]);
    savestr(' ',file,'a');
    savestr(['\refesecb{' row '}'],file,'a');
		% through files
    p=deblank(cont(gate(i,1)+1,:));
    if ~isempty(p),
      if p(length(p))=='*',p=[];end
    end
    for j=gate(i,1)+2:gate(i+1,1)-1,
      row=cont(j,:);
%     row=deblanks(row(2:length(row)-1));
%     ind=findstr(row,' ');
      fcnn=lower(deblanks(row(2:15)));
      disp(['         : ' fcnn]);
		% save gategories           
      if ~isempty(p),
	   fcns=putstr(fcnn,fcns);
      end;
%lower(
      row=deblanks(row(18:length(row)));
      row=[upper(row(1)) row(2:length(row))];
%     row=crearefe(crearefe(fcnn,1),2,'Purpose');
      savestr(['\refeseci{' fcnn '}{' row '}'],file,'a');
		% create list of all functions
    end   
    savestr('\refesece',file,'a');
  end;

%*** REFERENCE ENTRIES EN ALPHABETICAL ORDER ***
  fcns=sortstr(fcns);
  savestr(' ',file,'a');
  disp('crearefe : Updating Functions.');
  for i=1:size(fcns,1),
    row=deblanks(fcns(i,:));
    disp(['         : ' row]);
    savestr(' ',file,'a');
    savestr(['\refeentb{' row '}'],file,'a');
		% go through entry parts
    hlp=crearefe(row,1);
    for i=1:size(EP,1)
      prt=deblank(EP(i,:));
      str=crearefe(hlp,2,prt);
      if ~isempty(str)
        if i==1,str=[str '.'];end
        if i==2,
   	  savestr(['\refeents{' deblank(prt) ':}{'],file,'a');
        else
   	  savestr(['\refeenti{' deblank(prt) ':}{'],file,'a');
	end
	if i==4,
  	  savestr('}',file,'a');
	  str=str2mat('\refeentv','\begin{verbatim}',str,'\end{verbatim}');
  	  savestr(str,file,'a');
	else
		% convert forbidden characters
%         if size(str,1)>1,
%           str=str(1:size(str,1)-1,:);
%         end
	  for j=1:size(str,1);
            str(j,:)=strrep(str(j,:),setstr(9),' ');
            if isempty(deblanks(str(j,:))),
              str=putstr(CS3,str,j,1);
            else
  	       for k=1:size(CS1,1),
  	        str=putstr(strrep(str(j,:),deblank(CS1(k,:)),...
		  deblank(CS2(k,:))),str,j,1);
               end;
 	    end;
	  end;
          str(size(str,1),size(str,2)+1)='}';
  	  savestr(str,file,'a');
	end
      end;
    end
    savestr('\refeente',file,'a');
		% if there exist an figure
    if exist([row '.eps'])~=0,
      savestr(['\refeentf{' row '}'],file,'a');
    end 
  end
 cont=file;
else

%*** RETURNING FUNCTION HELP ***
  if fcn==1,
     file=deblanks(file);
     f=fopen([file '.m'],'r');
     cont=[]; 
     row=fgetl(f);
%JVIR, detrend earlier
     while ~isempty(deblank(row))&feof(f)==0,
       cont=putstr(row,cont);
       row=fgetl(f);
     end
     fclose(f);
%*** RETURNING PART OF FUNCTION FROM HELP ***
   elseif fcn==2,
		% purpose of function
     if strcmp(what,'Purpose')
	row=deblanks(file(2,:));
	i=findstr(row,' ');
	cont=row(i(1)+1:length(row)-1);
		% synopsis of function
     elseif strcmp(what,'Synopsis')
	row=file(3,:);
	row=deblanks(row(2:length(row)));
	i=findstr(row,' ');
	if isempty(i),i=length(row)+1;end
	cont=lower(row(2:i(1)-1));
		% description of function
     elseif strcmp(what,'Description')
	row=file(3,:);
	row=deblanks(row(2:length(row)));
	i=findstr(row,' ');
	if isempty(i),i=length(row)+1;end
	cont=['  ' row(i(1)+1:length(row))];
	i=4;
	row=deblanks(file(i,:));
	 while strcmp(row,'%DIAGNOSTIC')==0&strcmp(row,'%DIAGNOSTICS')==0&...
	     strcmp(row,'%REFERENCES')==0&strcmp(row,'%SEE ALSO')==0&...
	     strcmp(row,'%EXAMPLES')==0&i<size(file,1),
	   cont=putstr(row,cont);
	   i=i+1;
	   row=deblanks(file(i,:));
	 end;
	if size(cont,2)>2,
	  cont=cont(:,3:size(cont,2));
	end
		% examples, algorithm, diagnostic, see also, references
     else
       file=putstr('%    ',file);
       cont=[];
       f=upper(deblanks(['%' what]));
       i=strfind(file,f);
       if ~isempty(i),
	 i=i(1)+1;
	 row=file(i,:);
	 while strcmp(deblanks(row),'%')==0,
	   cont=putstr(row,cont);
	   i=i+1;
	   row=file(i,:);
	 end;
       end;
       if size(cont,2)>2,
	       cont=cont(:,3:size(cont,2));
       end
     end
   end           
  end
end

%END OF CREAREFE