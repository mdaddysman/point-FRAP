# Point FRAP Fitting
The **Point FRAP Fitting** program is a collection of Matlab scripts to analyze and fit diffraction limited point FRAP data. The analysis takes raw FRAP outputs in the form of voltages which are normalized, averaged, and saved. The saved FRAP curves are fit to a FRAP model to extract the diffusion parameters as measured by FRAP. 

#### Reference
For full details on the FRAP model and procedure see [Revisiting Point FRAP to Quantitatively Characterize Anomalous Diffusion in Live Cells](https://doi.org/10.1021/jp310348s). 

## Files in the repository
- `loadandfit_2model.m` 
- `pointb.m` or `pointb_smallfile.m`
- `FRAPfitweightedpsc_2model.m`
    - `meanvals2.m`
    - `ptFRAP.m`
    - `ptFRAPpsc.m`
    - `ptFRAPpscweighted.m`
    - `ptFRAPweighted.m`
- `savetable_2model.m`

## License
This software is made available under the [MIT License](LICENSE). 
