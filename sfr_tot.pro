FUNCTION SFR_TOT, lumir, lumirerr, lumfuv, lumfuverr
	Lsun = 3.839d33
	nsources = n_elements(lumir)
	lir = dblarr(nsources)
	lirerr = dblarr(nsources)
	lfuv = dblarr(nsources)
	lfuverr = dblarr(nsources)
	sfr = dblarr(nsources)
	sfrerr = dblarr(nsources)

	for i=0d,nsources-1 do begin
		if lumir[i] lt 0 OR finite(lumir[i], /nan) ne 0 then begin
			lir[i] = 0.0
			lirerr[i] = 0.0
		endif else begin
			lir[i] = Lsun*10^(lumir[i])
			lirerr[i] = Lsun*10^(lumirerr[i])
		endelse

		if lumfuv[i] lt 0 OR finite(lumfuv[i], /nan) ne 0 then begin
			lfuv[i] = 0.0
			lfuverr[i] = 0.0
		endif else begin
			lfuv[i] = Lsun*10^(lumfuv[i])
			lfuverr[i] = Lsun*10^(lumfuverr[i])
		endelse


		sfr[i] = 4.42d-44*(lfuv[i] + (0.88*lir[i]))
		sfrerr[i] = sqrt((lfuverr[i]*4.42d-44)^2 + (0.88*lirerr[i]*4.42d-44)^2)
	endfor

	return, [[sfr], [sfrerr]]
END