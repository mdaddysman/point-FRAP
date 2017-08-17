%distfit_weighted.m
function y=distfit_weighted(x)

global Dvect time data weightvect Fdist

amp = x; 

%dummy1 = ones(1,size(Fdist,1));
[ampmat,dummy] = meshgrid(amp,time);
[Dmat,dummy] = meshgrid(Dvect,time);
Fresult = sum(ampmat.*Fdist,2); 

y=(Fresult'-data)./time.*weightvect;    