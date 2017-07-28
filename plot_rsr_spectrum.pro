PRO plot_rsr_spectrum, specfile, f0, fg=fg, fwindow=fwindow, base_poly_ord=base_poly_ord, $
                       base_poly_num=base_poly_num, savefigs=savefigs, targetname=targetname

	loadct, 13, ncolors=255
	if(keyword_set(savefigs)) then set_plot, 'ps'
	filename=specfile

	if(not keyword_set(targetname)) then targetname=''
	FMT = 'F, F'
	readcol,filename,F=FMT,sfreq,svalue,/silent

	inan = where(finite(svalue, /nan))
	if n_elements(inan) gt 1 then svalue[inan] = 0.0

	; Trim the data to the frequency range of interest
	x = sfreq[where(sfreq ge fwindow[0] AND sfreq le fwindow[1])]
	ytrim = svalue[where(sfreq ge fwindow[0] AND sfreq le fwindow[1])]*1000.0    ; Put spectrum in mK
	x_raw = x
	y_raw = ytrim
	ndata = double(n_elements(ytrim))
	print, fg
	first_bestfit_gaussian=thegaussian(x_raw, fg)

	if(not keyword_set(base_poly_ord)) then base_poly_ord=4

	ysub = ytrim-first_bestfit_gaussian
	baseline = poly_smooth(ysub, ndata/10.0, degree=base_poly_ord)
	y = ytrim-baseline
	
	sig_1 = stdev(ytrim)
	sig_2 = stdev(y)

	!P.Multi = [0,1,2]
	if(keyword_set(savefigs)) then begin
		if(not keyword_set(baseplotname)) then baseplotname='baseline_RSR_plot.eps'
		device, filename=baseplotname, /encapsulated, /color
		plot, x, ytrim, xst=1, yst=1, psym=10, xr=fwindow, yr=[min(ytrim)-0.1, max(ytrim)+0.1], $
    xtitle='Frequency (GHz)', ytitle=textoidl('T_A^* (mK)'), charsize=1.3, charthick=1.3, $
    title='Spectrum + Baseline'
		
    plots, fwindow[0], 0
		plots, fwindow[1], 0, /continue, thick=2
		plots, f0, min(ytrim)-0.1
		plots, f0, max(ytrim)+0.1, /continue, color=254, linestyle=1
		oplot, x, baseline, color=254
		xyouts, fwindow[0]+0.1, max(ytrim)-0.1, strcompress('rms = '+string(format='(F8.3)',sig_1)+' mK')

		plot, x, y, xst=1, yst=1, psym=10, xr=fwindow, yr=[min(ytrim)-0.1, max(ytrim)+0.1], $
    xtitle='Frequency (GHz)', ytitle=textoidl('T_A^* (mK)'), charsize=1.3, charthick=1.3, $
    title='Baseline-Subtracted Spectrum'
		
    plots, fwindow[0], 0
		plots, fwindow[1], 0, /continue, thick=2
		plots, f0, min(ytrim)-0.1
		plots, f0, max(ytrim)+0.1, /continue, color=254, linestyle=1
		xyouts, fwindow[0]+0.1, max(ytrim)-0.1, strcompress('rms = '+string(format='(F8.3)',sig_2)+' mK')
		device, /close
	endif else begin
	if not(keyword_set(noplots)) then begin
		window, 6, retain=2
		plot, x, ytrim, xst=1, yst=1, psym=10, xr=fwindow, yr=[min(ytrim)-0.1, max(ytrim)+0.1], $
    xtitle='Frequency (GHz)', ytitle=textoidl('T_A^* (mK)'), charsize=1.3, charthick=1.3, $
    title='Spectrum + Baseline'
		
    plots, fwindow[0], 0
		plots, fwindow[1], 0, /continue, thick=2
		plots, f0, min(ytrim)-0.1
		plots, f0, max(ytrim)+0.1, /continue, color=254, linestyle=1
		oplot, x, baseline, color=254
		xyouts, fwindow[0]+0.1, max(ytrim)-0.1, strcompress('rms = '+string(format='(F8.3)',sig_1)+' mK')

		plot, x, y, xst=1, yst=1, psym=10, xr=fwindow, yr=[min(ytrim)-0.1, max(ytrim)+0.1], $
    xtitle='Frequency (GHz)', ytitle=textoidl('T_A^* (mK)'), charsize=1.3, charthick=1.3, $
    title='Baseline-Subtracted Spectrum'
		
    plots, fwindow[0], 0
		plots, fwindow[1], 0, /continue, thick=2
		plots, f0, min(ytrim)-0.1
		plots, f0, max(ytrim)+0.1, /continue, color=254, linestyle=1
		xyouts, fwindow[0]+0.1, max(ytrim)-0.1, strcompress('rms = '+string(format='(F8.3)',sig_2)+' mK')
	endif
	endelse
	!P.Multi = 0

	set_plot, 'ps'
	thefname = repstr(filename, '.txt', '.eps')

	!P.Multi = [0, 2, 1]

	device, filename=thefname, /encapsulated, /color, xsize=29, ysize=20
	plot, x, y*7.0, /nodata, xst=1, yst=1, psym=10, xr=fwindow, yr=[min(ytrim*7.0)-0.4, max(ytrim*7.0)+0.4], $
  xtitle='Frequency (GHz)', ytitle='Flux (mJy)', charsize=1.3, charthick=1.3, title=targetname, $
  position=[0.085, 0.085, 0.92, 0.92]
	
  oplot, x, y*7.0, psym=10, thick=2
	oplot, x, first_bestfit_gaussian*7.0, linestyle=1, thick=4, color=254
	plots, fwindow[0], 0
	plots, fwindow[1], 0, /continue, thick=2, color=70
	loadct, 4, ncolors=255
	plots, f0, min(ytrim*7.0)-0.4
	plots, f0, max(ytrim*7.0)+0.4, /continue, linestyle=2, color=115
	loadct, 13, ncolors=255

	plot, x, y*7.0, xst=1, yst=1, psym=10, xr=[f0-1.1, f0+1.1], yr=[min(ytrim*7.0)-0.4, max(ytrim*7.0)+0.4], $
  xtitle='Frequency (GHz)', ytitle='Flux (mJy)', charsize=0.9, charthick=1.0, position=[0.145, 0.63, 0.505, 0.87]
	oplot, x, first_bestfit_gaussian*7.0, linestyle=1, thick=4, color=254
	plots, f0-1.1, 0
	plots, f0+1.1, 0, /continue, thick=2, color=70
	loadct, 4, ncolors=255
	plots, f0, min(ytrim*7.0)-0.4
	plots, f0, max(ytrim*7.0)+0.4, /continue, linestyle=2, color=115
	loadct, 13, ncolors=255
	device, /close
	!P.Multi = 0

END
