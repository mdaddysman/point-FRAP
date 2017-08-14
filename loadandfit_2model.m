tic
clearvars;
close all
global wr wz 
data_filename = 'Example';
start=20;
wr=0.325; %1/e^2 radius in um 0.305 (10/4/12) (old: 0.293 or 0.274)
wz=0.974; %1/e^2 radius in um 1.092 (10/4/12) (old: 0.951 or 0.790)
x0=[80 1 1];  %initial guess [D (or G) alpha F t=inf]  
              %the inital guess for F t=0 is supplied by the script
calci = 1;  % Is the 95% confidence interval calculated? (1 = Yes; 0 = No)
            % Not calculating the 95% CI speeds up the fitting 
pointb_smallfile
FRAPfitweightedpsc_2model
savetable_2model
toc


