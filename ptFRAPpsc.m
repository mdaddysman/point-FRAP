%ptFRAPpsc.m
%functional form from corrected Feder, et al, article BiophysJ 100, 791;
%modified for 3D diffusion with additional denominator factor
function y=ptFRAPpsc(x,t)
global wr wz pstau psdelta xpsc z

G=x(1)*10^-6;
alpha=x(2);
Fpre=1;
F0=x(3);
Finf=x(4);

n=0:20; %seems to converge by 10 terms, so 20 should be plenty
[nmat,tmat]=meshgrid(n,t);
l = length(t); 
s = t(1); 
tpsc = s:(l+s-1);
[nmat2,tpscmat] = meshgrid(n,tpsc); 

opt = optimset('Display','off');
cont = 1:620; 
efit = @(a,t) a(1).*exp(-t./a(2)) + a(3);
curve = efit(xpsc,cont); 
fitcurve = F0 ./ curve; 
z = lsqcurvefit(efit,[psdelta pstau 0.8],cont,fitcurve,[],[],opt);

delta = z(1);
tau = z(2); 
if(tau > 2000)
    delta = 0;
end

R=(Finf-F0)/(Fpre-F0);
beta=lsqnonlin(@(x)sum(((-x).^n)./factorial(n)./(1+n).^(3/2).*(1+delta))-F0/Fpre,[1],[],[],opt);
 
%See Feder et al Biophys J 1996 70 2767 
%Brown et al Biophys J 1998 77 2837
%Schnell et al J. Biomed Optics 2008 13(6) 064037
l = length(t); 
tpsc = 1:l;
Fmat=(R+delta.*exp(-tpscmat./tau)).*((-beta).^nmat)./factorial(nmat)./(1+nmat.*(1+16*G.*(tmat.^alpha)./(alpha*wr^2)))./sqrt(1+nmat.*(1+16*G.*(tmat.^alpha)./(alpha*wz^2)));
F=Fpre*sum(Fmat,2)+(1-R)*F0;

y=F';