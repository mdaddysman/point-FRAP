%fit_to_distribution.m 
clearvars;
close all
tic
global Dvect Fdist wr wz time data weightvect pstau psdelta xpsc z
wr = 0.305; 
wz = 1.092; 
data_filename = 'Example';
start = 80; 

pointb_smallfile %or pointb

%Select data to be fit 
time = t2(start:end);
data = plot2(start:end);
weightvector(1:400) = ones(1,400);%400 points in 400 us
weightvector(401:2200) = 5*ones(1,1800);%200 points per 1000 us (500-1500,...,8500-9500)
weightvector(2201:2300) = 55*ones(1,100);%100 points per 5500 us (9500-15000)
weightvector(2301:2700) = 100*ones(1,400);%100 points per 10000 us (15000-25000,...,45000-55000)
weightvect = weightvector(start:end);

%First fit data to the subdiffusion model 
Fnotavg = mean(plot2(15:25));
Fnotmax = 1.1*Fnotavg; 
Fnotmin = 0.90*Fnotavg;

options = optimset('Display','iter','TolFun',10^-11,'TolX',10^-8,'FinDiffType','central');
xnot = [80 0.8 Fnotavg 1]; 
lb = [0 0 Fnotmin 0]; 
ub = [10000 1 Fnotmax 2];

[xAnom,resnormAnom,residualAnom]=lsqnonlin('ptFRAPpscweighted',xnot,lb,ub,options);
fitAnom=ptFRAPpsc(xAnom,time);
zAnom = z;

figure(11)
semilogx(time,data,'o',time,fitAnom)
title('Anomalous Diffusion Fit')
xlabel('time (us)')
ylabel('signal')

%Now take the subdiffusion data and plug it into the distribution fit 
F0 = xAnom(3);
Fpre = 1;
Finf = xAnom(4); 
delta = zAnom(1);
tau = zAnom(2); 

nmax=10; 
n = 0:nmax;
opt = optimset('Display','none'); 
B=lsqnonlin(@(x)sum(((-x).^n)./factorial(n)./(1+n).^(3/2).*(1+delta))-F0/Fpre,[1],[],[],opt);

Dvect = logspace(-8,-3,100);
l = length(time); 
s = time(1); 
tpsc = s:(l+s-1);
[Dmat,tmat] = meshgrid(Dvect,time);
[~,tpscmat] = meshgrid(Dvect,tpsc);
clear Dmat2 
Fdist = zeros(size(Dmat,1),size(Dmat,2));
for m=0:nmax
    Fdist = Fdist+(1+delta.*exp(-tpscmat./tau)).*((-B).^m)./factorial(m)./(1+m.*(1+16*Dmat.*(tmat.^1)./(1*wr^2)))./sqrt(1+m.*(1+16*Dmat.*(tmat.^1)./(1*wz^2)));
end

figure(12)
semilogx(time,Fdist)

%Random number initial guess
%x0 = rand(1,100); 

%Flat line initial guess
%x0 = 0.01*ones(1,100);

%log-normal initial guess
mu = log(10^-4); sig = 2;
x0 = 1./(Dvect.*sqrt(2*pi*sig^2)).*exp(-((log(Dvect)-mu).^2/2/sig^2));

%Normalize
xnotD1 = x0 ./ sum(x0); 
lb = zeros(1,100);
ub = ones(1,100); 


maxit=200;
options = optimset('Display','iter','MaxIter',maxit,'TolFun',10^-10,'TolX',10^-10,'FinDiffType','central');

%first fit
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD1,lb,ub,options);
[FdistFITmat,~] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2);  
xDist1=x; 
resnormDist1=resnorm; 
fitDist1=fit; 
residualDist1=residual;


%subtract baseline, smooth and fit again
y=x(1:100);
y2=nlfilter(y,[1,9],'median');
xnotD2(1:100)=y2;
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD2,lb,ub,options);
[FdistFITmat,~] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2); 
xDist2=x; 
resnormDist2=resnorm; 
fitDist2=fit; 
residualDist2=residual; 


%fit Gaussian to output and fit again
y=x(1:100);
y3=nlfilter(y,[1,5],'mean');
idx=1:length(y3);
over=find(y3>(max(y3)/2));
yy=lsqcurvefit('gauss',[max(y3) find(y3==max(y3)) over(end)-over(1)],idx,(y3-min(y3)));
y4=gauss(yy,idx);
xnotD4(1:100)=y4;
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD4,lb,ub,options);
[FdistFITmat,~] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2); 
xDist4=x; resnormDist4=resnorm; fitDist4=fit; residualDist4=residual;

options = optimset('Display','iter','MaxIter',maxit,'TolFun',10^-15,'TolX',10^-15,'FinDiffType','central');

%smooth again and fit again
y=x(1:100);
y2=nlfilter(y,[1,9],'median');
xnotD5(1:100)=y2;
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD5,lb,ub,options);
[FdistFITmat,~] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2);
xDist5=x; resnormDist5=resnorm; fitDist5=fit; residualDist5=residual;

%one more time - fit a broad Gaussian to output and fit again
y=x(1:100);
y3=nlfilter(y,[1,5],'mean');
idx=1:length(y3);
over=find(y3>(max(y3)/2));
yy=lsqcurvefit('gauss',[max(y3) find(y3==max(y3)) over(end)-over(1)],idx,(y3-min(y3)));
yy2=yy;
yy2(3)=1.5*yy(3);
y4=gauss(yy2,idx);
y5=(y4-y4(1)).*((y4-y4(1))>0);
xnotD6(1:100)=y5;
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD6,lb,ub,options);
[FdistFITmat,~] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2);
xDist6=x; resnormDist6=resnorm; fitDist6=fit; residualDist6=residual;

%smooth again and fit again
y=x(1:100);
y2=nlfilter(y,[1,9],'median');
xnotD7(1:100)=y2;
[x,resnorm,residual]=lsqnonlin('distfit_weighted',xnotD7,lb,ub,options);
[FdistFITmat,tmat] = meshgrid(x,time);
fit = sum(FdistFITmat.*Fdist,2);
xDist7=x; resnormDist7=resnorm; fitDist7=fit; residualDist7=residual;


figure(21)
subplot(2,3,1)
semilogx(Dvect.*10^6,xDist1(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm1: ' num2str(resnormDist1)])
xlim([0.01 1000])
subplot(2,3,4)
semilogx(Dvect.*10^6,xDist2(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm2: ' num2str(resnormDist2)])
xlim([0.01 1000])
subplot(2,3,2)
semilogx(Dvect.*10^6,xDist4(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm4: ' num2str(resnormDist4)])
xlim([0.01 1000])
subplot(2,3,5)
semilogx(Dvect.*10^6,xDist5(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm5: ' num2str(resnormDist5)])
xlim([0.01 1000])
subplot(2,3,3)
semilogx(Dvect.*10^6,xDist6(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm6: ' num2str(resnormDist6)])
xlim([0.01 1000])
subplot(2,3,6)
semilogx(Dvect.*10^6,xDist7(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm7: ' num2str(resnormDist7)])
xlim([0.01 1000])

figure(20)
subplot(2,3,1)
semilogx(Dvect.*10^6,xnotD1(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm1: ' num2str(resnormDist1)])
xlim([0.01 1000])
subplot(2,3,4)
semilogx(Dvect.*10^6,xnotD2(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm2: ' num2str(resnormDist2)])
xlim([0.01 1000])
subplot(2,3,2)
semilogx(Dvect.*10^6,xnotD4(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm4: ' num2str(resnormDist4)])
xlim([0.01 1000])
subplot(2,3,5)
semilogx(Dvect.*10^6,xnotD5(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm5: ' num2str(resnormDist5)])
xlim([0.01 1000])
subplot(2,3,3)
semilogx(Dvect.*10^6,xnotD6(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm6: ' num2str(resnormDist6)])
xlim([0.01 1000])
subplot(2,3,6)
semilogx(Dvect.*10^6,xnotD7(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Guess Amp')
title(['Resnorm7: ' num2str(resnormDist7)])
xlim([0.01 1000])

figure(22) 
subplot(2,3,1)
semilogx(time,data,'o',time,fitDist1)
xlabel('time / us')
ylabel('intensity')
title('Fit 1')
xlim([1 100000])
subplot(2,3,4)
semilogx(time,data,'o',time,fitDist2)
xlabel('time / us')
ylabel('intensity')
title('Fit 2')
xlim([1 100000])
subplot(2,3,2)
semilogx(time,data,'o',time,fitDist4)
xlabel('time / us')
ylabel('intensity')
title('Fit 4')
xlim([1 100000])
subplot(2,3,5)
semilogx(time,data,'o',time,fitDist5)
xlabel('time / us')
ylabel('intensity')
title('Fit 5')
xlim([1 100000])
subplot(2,3,3)
semilogx(time,data,'o',time,fitDist6)
xlabel('time / us')
ylabel('intensity')
title('Fit 6')
xlim([1 100000])
subplot(2,3,6)
semilogx(time,data,'o',time,fitDist7)
xlabel('time / us')
ylabel('intensity')
title('Fit 7')
xlim([1 100000])

figure(24)
subplot(2,3,1)
plot(Dvect.*10^6,xDist1(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm1: ' num2str(resnormDist1)])
xlim([1 100])
subplot(2,3,4)
plot(Dvect.*10^6,xDist2(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm2: ' num2str(resnormDist2)])
xlim([1 100])
subplot(2,3,2)
plot(Dvect.*10^6,xDist4(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm4: ' num2str(resnormDist4)])
xlim([1 100])
subplot(2,3,5)
plot(Dvect.*10^6,xDist5(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm5: ' num2str(resnormDist5)])
xlim([1 100])
subplot(2,3,3)
plot(Dvect.*10^6,xDist6(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm6: ' num2str(resnormDist6)])
xlim([1 100])
subplot(2,3,6)
plot(Dvect.*10^6,xDist7(1:100))
xlabel('Diffusion Coeff (um2/s)')
ylabel('Amp')
title(['Resnorm7: ' num2str(resnormDist7)])
xlim([1 100])


toc
