Pro dbiks2, FILE

;+
; NAME:
;	dbiks2
;
; EFFECT:
; Reads IKS spectra labels (spectro mode), writes a csv file for ingestion
; This is the main step in the creation of an EPN-TAP service using the mixin
;
; EXAMPLE
;	dbiks2, [FILE]
;
; KEYWORDS:
; FILE: name of index file, default is to use indexiks.csv 
;
; USAGE:
; - run this IDL procedure, then (in terminal):
; - write and run q.rd using EPN-TAP mixin and csv grammar
; - declare service in registry with file vopdc_obspm-lesia-epn-iks.xml (hand written)
;
; SPECIAL:
; 	use unit = dateTime to introduce an ISO time string => xtype='dateTime' (XML std, not VOTable)
;	SQL: 'float' stands for double; 'real' stands for simple precision
;	ascii 9 = HT, used as separator in an SQL data table (when input with COPY)
;
; Last steps (done):
;
; HISTORY:
;  Stephane Erard, dec 2017 from dbiks.pro 
;  adapted to produce a csv file with header

; ------------------------------------------------------------------------------------


;dir = '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data'
dir = '/Data4/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data'
Flist = file_search(dir, '*.lbl')

Nf = N_elements(Flist)

if N_params() NE 1 then FILE = 'indexiks.csv'


; 1) Write a better index file


; Structure pour les données/granules
IKSparam = replicate({id:1,Filename:'',Rootname:'',observation_id:1L, time_obs:'',target:'',distance:1.,Sdistance:1., Edistance:1.,sp_min:1.,sp_max:1.,sp_step_min:1.,sp_step_max:1.,sp_res_min:1.,sp_res_max:1., exp_time:1., phase_ang:1., Inst_Name:'',Inst_Host_name:'', ref:'NULL',a_url:'',a_format:'',o_url:'',o_format:'', s_region:''},Nf) 


For i =0, Nf-1 do begin
  fdima=Flist(i)
; grab metadata from header
;   lab=v_headpds(fdima,/silent)
   temp=v_readpds(fdima,/silent, lab)
fdima = FILE_BASENAME(fdima)	; remove dir 
nomps = (strsplit(fdima, '.', /extr))(0)+'.tab' ; replace any extension
nomout = (strsplit(fdima, '.', /extr))(0)+'.xml' ; replace any extension
IKSparam(i).Filename = nomps
IKSparam(i).Rootname = (strsplit(fdima, '.', /extr))(0)
bid = v_pdspar(lab, 'TARGET_NAME')
; IKSparam(i).target = strlowcase(bid)
IKSparam(i).target = strupcase(strmid(bid,0,1))+strlowcase(strmid(bid,1))  ; @Cor2014: std spelling (if one word)
bid = v_pdspar(lab, 'OBSERVATION_TIME')
IKSparam(i).time_obs = bid		; maintain upper case
bid = v_pdspar(lab, 'TARGET_CENTER_DISTANCE')
IKSparam(i).distance = float(bid)
	; fix reconstructed spectra, from Combes et al paper
If IKSparam(i).Filename EQ 'iksfig7.tab' then IKSparam(i).distance = 40000
If IKSparam(i).Filename EQ 'iksfinal.tab' then IKSparam(i).distance = 40000
 ; @Cor2014 : Sun and Earth distances, in au (cst) + FOV
IKSparam(i).Sdistance = 0.79
IKSparam(i).Edistance = 1.15

bid = v_pdspar(lab, 'OBSERVATION_ID')
IKSparam(i).observation_id = strlowcase(bid)
bid = (v_pdspar(lab, 'MINIMUM'))(0)     ; spectral range
IKSparam(i).sp_min = float(bid)
bid = (v_pdspar(lab, 'MAXIMUM'))(0)
IKSparam(i).sp_max = float(bid)
bid = (temp.table.column1)- shift(temp.table.column1, 1)
IKSparam(i).sp_step_min = min((bid)(1:*))
IKSparam(i).sp_step_max = max((bid)(1:*))
	; actual spectral resolution, from Combes et al paper
IKSparam(i).sp_res_min = 2.6/41.	; in micron
IKSparam(i).sp_res_max = 4.8/70.
	; exposure time, from Combes et al paper
IKSparam(i).exp_time = 18.
If IKSparam(i).Filename EQ 'iksfinal.tab' then begin ; long wvl spectrum
	IKSparam(i).exp_time = 36.
	IKSparam(i).sp_res_min = 6.3/41.	; in micron
	IKSparam(i).sp_res_max = 11.3/66.
	 ; @Cor2014: added ref for published spectra
	IKSparam(i).ref = 'http://cdsads.u-strasbg.fr/abs/1988Icar...76..404C'
endif
;IKSparam(i).phase_ang = 100.	; ***** @Corr2015, very rough approximation *****

; result for 101 individual spectra, from phaseiks.pro (interpolated from image timings) 
; last 2 writen manually (composite spectra)
; array_list, phaseiks, for='(F5.1)'
IKSparam.phase_ang = [102.5,102.5,102.4,102.4,102.4,102.4,102.4,102.4,102.4,102.4,102.4,$
          102.4,102.4,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,102.3,$
          102.3,102.2,102.2,102.2,102.2,102.2,102.2,102.2,102.2,102.2,$
          102.2,102.2,102.2,102.2,102.2,102.2,102.2,102.2,102.2,102.2,$
          102.2,102.1,101.8,101.5,101.1,100.8,100.5,100.1, 99.7, 99.2, 100.,100.]



If IKSparam(i).Filename EQ 'iksfig7.tab' then IKSparam(i).ref = 'http://cdsads.u-strasbg.fr/abs/1988Icar...76..404C'
IKSparam(i).Inst_Name = 'IKS'	; @Cor2014: case insensitive, better write it upper case
IKSparam(i).inst_Host_name = 'Vega 1'	; @Cor2014: no space allowed in string
	; original ascii file url, at SBN PDS 
;IKSparam(i).url = 'http://pdssbn.astro.umd.edu/holdings/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'+nomps
;IKSparam(i).format = 'ascii'
	; modified VOtable files at VO-Paris
IKSparam(i).a_url = 'http://voparis-srv.obspm.fr/vo/planeto/iks/'+nomout
IKSparam(i).a_format = 'application/x-votable+xml'
; @Cor2014: added link to native file 
IKSparam(i).o_url = 'http://pdssbn.astro.umd.edu/holdings/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'+nomps
IKSparam(i).o_format = 'text/plain'

endfor
IKSparam.id = indgen(Nf)+1

write_csv, FILE, IKSparam, header= strlowcase((tag_names(IKSparam)))

End
