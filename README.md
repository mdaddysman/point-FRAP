# Point FRAP Fitting
The **Point FRAP Fitting** program analyzes and fits diffraction limited point FRAP data. The analysis takes raw FRAP outputs in the form of voltages which are normalized, averaged, and saved. The saved FRAP curves are fit to a FRAP model to extract the diffusion parameters measured by FRAP. 

#### Reference
For full details on the FRAP model and procedure see [this paper](https://doi.org/10.1021/jp310348s) 

Raw FRAP outputs in the form of voltages are collected over several different points.  These output files are normalized and averaged using the load_multipt_autoselect.m routine.  This routine takes a number of different zones (z-slices) and averages the points in each z-slice into one data set that it saves as filename.mat.  The data are normalized to the prebleach data as part of the processing.
