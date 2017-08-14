%pointb_smallfile.m
global pstime psdata pstau psdelta xpsc

data = open([data_filename '.mat']);
avg1 = data.avg1;
avg2 = data.avg2;
clear data

xbound1 = [-200 10300];
xbound2 = [-200 50000];
ybound = [0.4 1.1];

plot1i = avg1(801:1000);
plot1renorm = avg2(801:1000);

plot1 = plot1i ./ plot1renorm;
plot1ble = plot1i;
plot1con = plot1renorm;

%Now process the postbleach data

avgpost(1:2700) = avg1(1021:3720);

avgpost2(1:2700) = avg2(1021:3720);

plot2 = avgpost ./ avgpost2;
plot2ble = avgpost;
plot2con = avgpost2;


%t1 is just 200 microseconds before the bleach
t1=-200:-1;

t2(1:400) = 1:400;
t2(401:600) = 1001:1200;
t2(601:800) = 2001:2200;
t2(801:1000) = 3001:3200;
t2(1001:1200) = 4001:4200;
t2(1201:1400) = 5001:5200;
t2(1401:1600) = 6001:6200;
t2(1601:1800) = 7001:7200;
t2(1801:2000) = 8001:8200;
t2(2001:2200) = 9001:9200;
t2(2201:2300) = 10001:10100;
t2(2301:2400) = 20001:20100;
t2(2401:2500) = 30001:30100;
t2(2501:2600) = 40001:40100;
t2(2601:2700) = 50001:50100;

%now make the photoswitching plot
pstime = 1:620; %620 us of photoswitching data (200 "prebleach" 20 "bleach" 400 "postbleach") 
%take the control data
pscon = avg2(801:1420) ./ max(avg2(801:1420)); 
%create the flat bleach plot
psble = mean(plot2(25:35))*ones(1,620);
%now make the photoswitching plot
psplot = psble ./ pscon'; 
psdata = psplot; 
pscon2 = pscon';

x0psc = [0.1 400 0.8]; 
efit = @(a,t) a(1).*exp(-t./a(2)) + a(3);
xpsc = lsqcurvefit(efit,x0psc,pstime,pscon2);
fitps = efit(xpsc,pstime); 
pstau = xpsc(2);
psdelta = -xpsc(1); 


figure(1)
subplot(3,1,1);
plot(t1',plot1,'o',t2',plot2,'o')
xlim(xbound1)
ylim(ybound)
title('Corrected Curve')
subplot(3,1,2);
plot(t1',plot1ble,'o',t2', plot2ble,'o')
xlim(xbound1)
ylim(ybound)
title('Bleach')
subplot(3,1,3);
plot(t1',plot1con,'o',t2', plot2con,'o')
xlim(xbound1)
ylim(ybound)
title('Control')
xlabel('time (us)')

figure(2)
subplot(3,1,1);
plot(t1',plot1,'o',t2',plot2,'o')
xlim(xbound2)
ylim(ybound)
title('Corrected Curve')
subplot(3,1,2);
plot(t1',plot1ble,'o',t2', plot2ble,'o')
xlim(xbound2)
ylim(ybound)
title('Bleach')
subplot(3,1,3);
plot(t1',plot1con,'o',t2', plot2con,'o')
xlim(xbound2)
ylim(ybound)
title('Control')
xlabel('time (us)')


figure(3)
semilogx(t2',plot2,'o')
ylim([-0.5 1.5])

figure(4)
plot(t2',plot2,'o')
ylim(ybound)
xlim([0 300])
set(gca,'XTick',0:10:300);
labels = {'0','','','','','50','','','','','100','','','','','150','','','','','200','','','','','250','','','','','300'};
set(gca,'XTickLabels',labels);


