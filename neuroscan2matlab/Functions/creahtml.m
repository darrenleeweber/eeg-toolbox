function cont=creahtml(file,fcn,what)
%creahtml Create reference text.
%	CONT=CREAHTML(FILE,FCN,WHAT) Create reference file from current 
%	Contents file. File is base for toolbox reference manual. An description
%	line is added in the beginning of file.
%
%	Use tabulator in creating m files, not spaces, except in Examples
%	part. Multiple paragraphs are only allowed in Description part. If 
%	name.jpg file exist that is added.
%
%DIAGNOSTICS
%	If error encourted look that function's help is made in correct
%  format, using tabulator and correct headers. For WWW remove
%  ..\Functions\ and transfer m files into Help directory.
%
%SEE ALSO
%	Uses findstr, loadstr, savestr, crearefe.
%
%EXAMPLES
%	h=creahtml('loadcnt',1)         % return parts
%	creahtml(h,2,'Purpose')
%	creahtml('Help\scanrefe.html'); % create reference part

%	creahtml('datah\aumarefe.tex');
%	creahtml('datah\edsarefe.tex');

%Mention source when using or modifying these tools

%JVIR,1999-Apr-8  
%JVIR,25-Feb-1999 Added description line.
%JVIR,Jussi.Virkkala@occuphealth.fi

%JVIR,10-Feb-1999 Upper case for WWW presentation.
%JVIR, 2-Feb-1999 Changed from creahtml 
%JVIR, 2-Feb-1999 Modified for PCWIN Matlab 5.2.

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

CS2=['_         ';
     '%         ';    
     '<         ';
     '>         ';
     '#         '];

CS3='\\';

global DIRS

%*** CREATING REFERENCE TEXT ***
if nargin==1,
% file=['datah' DIRS file];
  savestr(' ',file);
  cont=loadstr('Contents.m');
  gate=strfind(cont,'%           ');
%JVIR, First rows as header
  savestr(['<A NAME=top>(this file is automatically created by <A HREF=#creahtml>creahtml.m</A> based on file contents.m)'],file,'a');
  for i=1:gate(1,1)-1,
       row=deblanks(cont(i,:));
       row=row(2:length(row)-1);
       savestr(['<P><B>' row '</B>'],file,'a');
  end
  n=size(gate,1)-1;
  disp(' ');

%*** LIST OF FUNCTIONS GROUPED BY SUBJECT AREA ***
  fcns=[];
  disp('creahtml : Updating Gategories.');
  for i=1:n,    % n
    row=deblanks(cont(gate(i,1)+1,:));
    row=row(2:length(row)-1);
    disp(['         *' row]);
    savestr(' ',file,'a');
%JVIR,   
    savestr(['<P><B>' row '</B><UL>'],file,'a');
		%through files
    p=deblank(cont(gate(i,1)+1,:));
    if ~isempty(p),
      if p(length(p))=='*',p=[];end
    end
    for j=gate(i,1)+2:gate(i+1,1)-1,
      row=cont(j,:);
      fcnn=lower(deblanks(row(2:15)));
      disp(['         : ' fcnn]);
		%save gategories           
      if ~isempty(p),
	   fcns=putstr(fcnn,fcns);
      end;
      row=deblanks(row(18:length(row)));
      row=[upper(row(1)) row(2:length(row))];
      savestr(['<LI><A HREF=#' fcnn '><B>' fcnn '</B> ' row '</A>'],file,'a');
		%create list of all functions
    end   
    savestr('</UL>',file,'a');
  end;

%*** REFERENCE ENTRIES EN ALPHABETICAL ORDER ***
  fcns=sortstr(fcns);
  savestr(' ',file,'a');
  disp('creahtml : Updating Functions.');
  for i=1:size(fcns,1),
    row=deblanks(fcns(i,:));
    disp(['         : ' row]);
    savestr(' ',file,'a');
%JVIR, A NAME
    savestr(['</UL><A NAME=' row '></A><B>' row '</B><UL>'],file,'a');
		% go through entry parts
    hlp=creahtml(row,1);
    for i=1:size(EP,1)
      prt=deblank(EP(i,:));
      str=creahtml(hlp,2,prt);
      if ~isempty(str)
        if i==1,str=[str '.'];end
        if i==2,
   	  savestr(['<LI><B>' deblank(prt) '</B>:'],file,'a');
        else
   	  savestr(['<LI><B>' deblank(prt) '</B>:'],file,'a');
     end
	if i==4,
  	 	%savestr('}',file,'a');
	   str=str2mat('<UL><PRE>',str,'</PRE></UL>');
  	  savestr(str,file,'a');
   else
   	%JVIR,1999-Apr-8, added -1    
	for j=1:size(str,1)-1;
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
     str(size(str,1),size(str,2)+1)=' ';
  	  savestr(str,file,'a');
	end
      end;
    end    
      %if there exist an figure
      if exist([row '.jpg'])~=0,         	
          savestr(['(<A HREF=' row '.jpg>'  row '.jpg</A>)'],file,'a');
       end
    savestr(['(<A HREF=..\Functions\' upper(row) '.M>' row '.m</A>)'],file,'a');
    savestr(['(<A HREF=#top>top</A>)'],file,'a');
 end

 cont=file;
else

%*** RETURNING FUNCTION HELP ***
  if fcn==1,
     file=deblanks(file);
     f=fopen([file '.m'],'r');
     cont=[]; 
     row=fgetl(f);
%JVIR,detrend earlier
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
			if size(cont,2)>2,
	      	 cont=cont(:,3:size(cont,2));
   		end
     	end
   end           
  end
end

%END OF CREAHTML