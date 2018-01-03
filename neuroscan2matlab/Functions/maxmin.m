%maxmin.m
%Looks for minima and maxima needs global shat varible
%
%DIAGNOSTICS
%SEE ALSO
%EXAMPLES

%Tarmo Kärki 1998 TYKS/KNF KY/SOV.FYS
shat=Shat2;
[iEPsize,iEPcount]=size(shat);
EPminmax=zeros(iEPcount,15);
EPtime=zeros(iEPcount,15);
EPmima=zeros(iEPcount,15);
for iix=1:iEPcount
   ifind=0
   for iiy=2:iEPsize-1
      if (shat(iiy-1,iix)>shat(iiy,iix)& shat(iiy+1,iix)>shat(iiy,iix))|(shat(iiy-1,iix)<shat(iiy,iix)& shat(iiy+1,iix)<shat(iiy,iix))& (ifind<15)
         ifind=ifind+1
         EPminmax(iix,ifind)=shat(iiy,iix);
         EPtime(iix,ifind)=(iiy-1)*1/str2num(adrate);
         if (shat(iiy-1,iix)>shat(iiy,iix)& shat(iiy+1,iix)>shat(iiy,iix)) EPmima(iix,ifind)=-1; end
			if (shat(iiy-1,iix)<shat(iiy,iix)& shat(iiy+1,iix)<shat(iiy,iix))	EPmima(iix,ifind)=1; end		
		end
   end
end
P300=zeros(iEPcount,2);
for iix1=1:iEPcount
	treshold=-9999;
	for iiy1=1:15
		if (EPmima(iix1,iiy1)==1) & (EPtime(iix1,iiy1)>0.250) & (EPtime(iix1,iiy1)<0.400) & (EPminmax(iix1,iiy1)>treshold)
		treshold=EPminmax(iix1,iiy1);
		P300(iix1,1)=EPtime(iix1,iiy1)
		P300(iix1,2)=EPminmax(iix1,iiy1);
		end
	end	
end
N100=zeros(iEPcount,2);
for iix1=1:iEPcount
	treshold=9999;
	for iiy1=1:15
		if (EPmima(iix1,iiy1)==-1) & (EPtime(iix1,iiy1)>0.050) & (EPtime(iix1,iiy1)<0.150) & (EPminmax(iix1,iiy1)<treshold)
		treshold=EPminmax(iix1,iiy1);
		N100(iix1,1)=EPtime(iix1,iiy1)
		N100(iix1,2)=EPminmax(iix1,iiy1);
		end
	end	
end
