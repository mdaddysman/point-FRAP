%FRAPfitweightedpsc_2model.m
global time data weightvect lowpt pstime z

time=t2;
data=plot2;


Fnotavg = mean(data(15:25));
Fnotmax = 1.1*Fnotavg; 
Fnotmin = 0.90*Fnotavg; 
Fnot = Fnotavg;

delmin = -1; %delmin = 1.2*del; 
delmax = 0; %delmax = 0.8*del;

av=1;
timemat=reshape(t2(start:end),av,((length(time)-start+1)/av));
time=mean(timemat,1);
datamat=reshape(plot2(start:end),av,((length(data)-start+1)/av));
data=mean(datamat,1);
meant = meanvals2(t2);
meand = meanvals2(plot2); 
n = size(timemat,2);
n1 = 20; 
lowpt = 0; %0.9*mean(data(20:60)); 

%del = 0.09; %0.0525
fulltime = time; %start:10:50200; 

weightvector(1:400) = ones(1,400);%400 points in 400 us
weightvector(401:2200) = 5*ones(1,1800);%200 points per 1000 us (500-1500,...,8500-9500)
weightvector(2201:2300) = 55*ones(1,100);%100 points per 5500 us (9500-15000)
weightvector(2301:2700) = 100*ones(1,400);%100 points per 10000 us (15000-25000,...,45000-55000)

weightvect = reshape(weightvector(start:end),av,((length(weightvector)-start+1)/av));

options = optimset('Display','iter','TolFun',10^-11,'TolX',10^-8,'FinDiffType','central');
ci = zeros(4,2); 
xnot(1:2) = x0(1:2); xnot(3) = Fnot; xnot(4) = x0(3); 
%model 1 diffusion and immoble frac 
lb = [0 0.9999 Fnotmin 0]; 
ub = [10000 1 Fnotmax 2];

[x,resnorm,residual,~,~,~,jacobian]=lsqnonlin('ptFRAPpscweighted',xnot,lb,ub,options);
if(calci == 1)
    ci = nlparci(x,residual,jacobian);
end
plusminus=((ci(:,2)-ci(:,1))/2)'; %calculates +/- value from confidence intervals
fit=ptFRAPpsc(x,fulltime);
x1b=x; resnorm1b=resnorm; plusminus1b=plusminus; fit1b=fit; residual1b=residual; z1b = z;

%model 2 - full anomlous diff and immob frac 
lb = [0 0 Fnotmin 0]; 
ub = [10000 1 Fnotmax 2];

[x,resnorm,residual,~,~,~,jacobian]=lsqnonlin('ptFRAPpscweighted',xnot,lb,ub,options);
if(calci == 1)
    ci = nlparci(x,residual,jacobian);
end 
plusminus=((ci(:,2)-ci(:,1))/2)'; %calculates +/- value from confidence intervals
fit=ptFRAPpsc(x,fulltime);
x2b=x; resnorm2b=resnorm; plusminus2b=plusminus; fit2b=fit; residual2b=residual; z2b = z;

%model 3 diffusion and immoble frac w/o PSC
lb = [0 0.9999 Fnotmin 0]; 
ub = [10000 1 Fnotmax 2];

[x,resnorm,residual,~,~,~,jacobian]=lsqnonlin('ptFRAPweighted',xnot,lb,ub,options);
if(calci == 1)
    ci = nlparci(x,residual,jacobian);
end
plusminus=((ci(:,2)-ci(:,1))/2)'; %calculates +/- value from confidence intervals
fit=ptFRAP(x,fulltime);
x3=x; resnorm3=resnorm; plusminus3=plusminus; fit3=fit; residual3=residual;

%model 4 - full anomlous diff and immob frac w/o PSC
lb = [0 0 Fnotmin 0]; 
ub = [10000 1 Fnotmax 2];

[x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin('ptFRAPweighted',xnot,lb,ub,options);
if(calci == 1)
    ci = nlparci(x,residual,jacobian);
end 
plusminus=((ci(:,2)-ci(:,1))/2)'; %calculates +/- value from confidence intervals
fit=ptFRAP(x,fulltime);
x4=x; resnorm4=resnorm; plusminus4=plusminus; fit4=fit; residual4=residual;

 
%find BIC 
rn = [resnorm1b resnorm2b]; 
K = [4 5];

BIC = (n*log(rn/n)) + log(n).*K;

BICF = BIC - min(BIC);
BICPercent = exp(-0.5*BICF) / sum(exp(-0.5*BICF));

%Find center resnorm

mresnorm1b = 0;

mresnorm2b = 0;
wv(1:6) = 1;
wv(7:15) = 5; 
wv(16) = 55;
wv(17:20) = 100; 
for m=1:20
    index = find(time > meant(m));
    
    mresnorm1b = mresnorm1b + (fit1b(index(1)) - meand(m))^2*wv(m)/meant(m);
   
    mresnorm2b = mresnorm2b + (fit2b(index(1)) - meand(m))^2*wv(m)/meant(m);
end
mrn = [mresnorm1b mresnorm2b]; 

mBIC = (n1*log(mrn/n1)) + log(n1).*K;
mBICF = mBIC - min(mBIC);
mBICPercent = exp(-0.5*mBICF) / sum(exp(-0.5*mBICF));


res1b = meanvals2([zeros(1,start-1) residual1b]);
res2b = meanvals2([zeros(1,start-1) residual2b]);
res3 = meanvals2([zeros(1,start-1) residual3]);
res4 = meanvals2([zeros(1,start-1) residual4]);

figure(10)
plot(pstime,pscon,'o',pstime,fitps)
xlim([0 620])
legend('Data','Fit','Location','SouthEast')
title('Photoswitching Correction')  
ylabel('normalized intensity')
xlabel('time (\mus)')

figure(12)
subplot(3,1,[1 2])
semilogx(time,data,'o',fulltime,fit1b,fulltime,fit2b,meant,meand,'x')
xlim([start 50000])
legend('Data','Normal Diffusion','Anomalous Diffusion','Location','SouthEast')
title('Photoswitching Correction')
ylabel('normalized intensity')
xlabel('time (\mus)')
subplot(3,1,3)
semilogx(time,zeros(1,length(time)),meant,res1b,'x',meant,res2b,'x','MarkerSize',10)
xlim([start 50000])

figure(13)
subplot(3,1,[1 2])
semilogx(time,data,'o',fulltime,fit3,fulltime,fit4,meant,meand,'x')
xlim([start 50000])
legend('Data','Normal Diffusion','Anomalous Diffusion','Location','SouthEast')
title('No Photoswitching Correction')
ylabel('normalized intensity')
xlabel('time (\mus)')
subplot(3,1,3)
semilogx(time,zeros(1,length(time)),meant,res3,'x',meant,res4,'x','MarkerSize',10)
xlim([start 50000])


figure(14)
subplot(2,1,1)
semilogx(time,residual1b,'.',time,zeros(1,length(time)),meant,res1b,'x','MarkerSize',10)
xlim([start 50000])
subplot(2,1,2)
semilogx(time,residual2b,'.',time,zeros(1,length(time)),meant,res2b,'x','MarkerSize',10)
xlim([start 50000])


x1bmat=[x1b;plusminus1b;100000*resnorm1b*ones(1,4)];
x2bmat=[x2b;plusminus2b;100000*resnorm2b*ones(1,4)];
x3mat=[x3;plusminus3;100000*resnorm3*ones(1,4)];
x4mat=[x4;plusminus4;100000*resnorm4*ones(1,4)];


Bounds = [Fnotmin Fnot delmin delmax];

saveas(12,[data_filename '_combo_psc.fig']);
saveas(13,[data_filename '_combo_nopsc.fig']);
saveas(14,[data_filename '_resdual.fig']);
