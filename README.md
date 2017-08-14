# Point FRAP Fitting
The **Point FRAP Fitting** program is a collection of Matlab scripts to analyze and fit diffraction limited point FRAP data. The analysis takes raw FRAP outputs in the form of voltages which are normalized, averaged, and saved. The saved FRAP curves are fit to a FRAP model to extract the diffusion parameters as measured by FRAP. 

#### Reference
- For full details on the FRAP model and procedure see [Revisiting point FRAP to quantitatively characterize anomalous diffusion in live cells](https://doi.org/10.1021/jp310348s). 
- For an example application and the use of the distribution model see [RNA polymerase II subunits exhibit a broad distribution of macromolecular assembly states in the interchromatin space of cell nuclei](https://doi.org/10.1021/jp4082933).

## Files in the repository
- `loadandfit_2model.m` The main script. Runs all of the scripts below. 
- `pointb.m` or `pointb_smallfile.m` Processes the FRAP data and place the voltages on the proper time axis. Choosing the correct file depends on the input data. 
- `FRAPfitweightedpsc_2model.m` Fits the FRAP data to a FRAP model. It is dependant on the functions below.  
    - `meanvals2.m`
    - `ptFRAP.m`
    - `ptFRAPpsc.m`
    - `ptFRAPpscweighted.m`
    - `ptFRAPweighted.m`
- `savetable_2model.m` Saves the best fit parameters to a text file for importing into Excel for further analysis. 
- `Example.mat` Example data set for running the program. 

## Running the software
The `loadandfit_2model.m` script contains the variables to be configured to run the FRAP fitting analysis. The `data_filename` is set to the .mat file that contains the FRAP data. 

```matlab
data_filename = 'Example';
```

The `start` variable is set to the number of data points (or microseconds) after the bleach that the fit begins. This is usually set to a value between 20 to 80. The early time data is subject to ringing in the preamplifer due to the bleaching intensity. For more details see Figure S2 in [this reference.](https://doi.org/10.1021/jp310348s)

```matlab
start=20;
```




## License
This software is made available under the [MIT License](LICENSE). 
