%load_multipt.m

filename = 'Example';
pts = 500;

file = fopen([filename '_ptbl_pt' num2str(0) '_r0.dat'],'r');
data1 = fscanf(file,'%f');
max1 = mean(data1(801:1000));
ldata = length(data1);
normavg1 = zeros(ldata,pts);
normavg1(:,m) = data1 ./ max1;
fclose(file);

%Process Bleach datapoints:
for m=2:pts
    file = fopen([filename '_ptbl_pt' num2str(m-1) '_r0.dat'],'r');
    data1 = fscanf(file,'%f');
    max1 = mean(data1(801:1000));
    normavg1(:,m) = data1 ./ max1;
    fclose(file);
end
avg1 = sum(normavg1,2) ./ pts;
clear data1 max1 normavg1
normavg2 = zeros(ldata,pts);
%Process Control Datapoints
for m=1:pts
    file = fopen([filename '_ptcon_pt' num2str(m-1) '_r0.dat'],'r');
    data2 = fscanf(file,'%f');
    max2 = mean(data2(801:1000));
    normavg2(:,m) = data2 ./ max2;
    fclose(file);
end

avg2 = sum(normavg2,2) ./ pts;
clear data2 max2 normavg2
save([filename '.mat'],'avg1','avg2');
