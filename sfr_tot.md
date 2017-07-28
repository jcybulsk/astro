; A simple IDL function to calculate the star-formation rate (SFR) of a galaxy, 
; when given the infrared luminosity, UV luminosity (in the FUV band), or just 
; one of them individually. SFR is calculated following the formula in Equation 
; 9 of Murphy et al. (2011) - ApJ 737.
;
; Inputs: 
;      lumir - log10 of the total infrared luminosity
;   lumirerr - log10 of the uncertainty in the total infrared luminosity
;     lumfuv - log10 of the total FUV luminosity
;  lumfuverr - log10 of the uncertainty in the total FUV luminosity
; Output:
;  array containing the SFRs and uncertainties in the SFR for each input galaxy
