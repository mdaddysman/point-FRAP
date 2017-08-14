%savetable_2model.m
fid = fopen([data_filename '_table.tsv'],'w');

tau2 = (x2bmat(1,2)*wr^2/(6*x2bmat(1,1)*10^-6))^(1/x2bmat(1,2));
deff2 = wr^2 / (6*tau2*10^-6);

tau2err = (x2bmat(1,2)*wr^2/((x2bmat(1,1)+x2bmat(2,1))*6*10^-6))^(1/x2bmat(1,2));
deff2err = (wr^2 / (6*tau2err*10^-6)) - deff2 ;

tau4 = (x4mat(1,2)*wr^2/(6*x4mat(1,1)*10^-6))^(1/x4mat(1,2));
deff4 = wr^2 / (6*tau4*10^-6);

tau4err = (x4mat(1,2)*wr^2/((x4mat(1,1)+x4mat(2,1))*6*10^-6))^(1/x4mat(1,2));
deff4err = (wr^2 / (6*tau4err*10^-6)) - deff4 ;


fprintf(fid,'Data : %s\n',data_filename);

fprintf(fid,'Normal\t D\t Alpha\t F t=0\t F t=inf\t Delta\t Tau\n');
fprintf(fid,'Values\t %f\t %f\t %f\t %f\t %f\t %f\n',x1bmat(1,1),x1bmat(1,2),x1bmat(1,3),x1bmat(1,4),z1b(1),z1b(2));
fprintf(fid,'95%% CI\t %f\t %f\t %f\t %f\t %f\t %f\n',x1bmat(2,1),x1bmat(2,2),x1bmat(2,3),x1bmat(2,4),0,0);
fprintf(fid,'RN\t %f\t BIC\t %f\t BIC%%\t %f\n',x1bmat(3,1),BICF(1),BICPercent(1));

fprintf(fid,'Anomalous\t Gamma\t Alpha\t Deff\t F t=0\t F t=inf\t Delta\t Tau\n');
fprintf(fid,'Values\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n',x2bmat(1,1),x2bmat(1,2),deff2,x2bmat(1,3),x2bmat(1,4),z2b(1),z2b(2));
fprintf(fid,'95%% CI\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n',x2bmat(2,1),x2bmat(2,2),deff2err,x2bmat(2,3),x2bmat(2,4),0,0);
fprintf(fid,'RN\t %f\t BIC\t %f\t BIC%%\t %f\n',x2bmat(3,1),BICF(2),BICPercent(2));

fprintf(fid,'Normal\t D\t Alpha\t F t=0\t F t=inf\n');
fprintf(fid,'Values\t %f\t %f\t %f\t %f\n',x3mat(1,1),x3mat(1,2),x3mat(1,3),x3mat(1,4));
fprintf(fid,'95%% CI\t %f\t %f\t %f\t %f\n',x3mat(2,1),x3mat(2,2),x3mat(2,3),x3mat(2,4));
fprintf(fid,'RN\t %f\n',x3mat(3,1));

fprintf(fid,'Anomalous\t Gamma\t Alpha\t Deff\t F t=0\t F t=inf\n');
fprintf(fid,'Values\t %f\t %f\t %f\t %f\t %f\n',x4mat(1,1),x4mat(1,2),deff4,x4mat(1,3),x4mat(1,4));
fprintf(fid,'95%% CI\t %f\t %f\t %f\t %f\t %f\n',x4mat(2,1),x4mat(2,2),deff4err,x4mat(2,3),x4mat(2,4));
fprintf(fid,'RN\t %f\n',x4mat(3,1));

fprintf(fid,'Start:\t %f\t Low F0:\t %f\t High F0:\t %f\t Tau:\t %f\n',start,Fnotmin,Fnot,pstau);
fclose(fid);