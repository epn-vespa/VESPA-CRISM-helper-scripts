Pro dbiks, FILE

;+
; NAME:
;	dbiks
;
; EFFECT:
; Reads IKS spectra labels (spectro mode), writes a real index  + an SQL routine writing the database
; This is one step in the creation of an EPN-TAP service
;
; EXAMPLE
;	dbiks, [FILE]
;
; KEYWORDS:
; FILE: name of index file, default is to use indexdb.txt 
;		also writes a file 'iks_db.sql'
;
; USAGE:
; - Create database IKS in pgAdmin
; - run this IDL procedure, then (in terminal):
;	cd /whatever/IKS
;	sudo -s -u postgresql
;	psql  IKS < iks_db.sql
; - refresh IKS db in PgAdmin to see the new db
; - create views (dataset & epn_core) with routine iks_views.sql
; - transform ascii data files in VOTable using catiksfiles.pro
; - instal in gavo with file q.rd (hand written)
; - declare service in registry with file vopdc_obspm-lesia-epn-iks.xml (hand written)
;
; SPECIAL:
; 	use unit = dateTime to introduce an ISO time string => xtype='dateTime' (XML std, not VOTable)
;	SQL: 'float' stands for double; 'real' stands for simple precision
;	ascii 9 = HT, used as separator in an SQL data table (when input with COPY)
;
; Last steps (done):
;  √ - fix final url/names for files (votable at VOParis) 
;  √ - compute/add spectral sampling step + spectral resolution
;
; HISTORY:
;  Stephane Erard, nov 2013 (first SQL-writing routine, partly derived from catIKS)
;  SE, May 2014: corrections and modif in table and SQL routine => @Cor2014
;  SE, Nov 2015: Recovered phase angle added + passed all floats to double precision => @Cor2015
;  SE, Feb 2016: Added rootname param for v2
;				 Does not compute target time, because only date is provided (diff is very small) 
; ------------------------------------------------------------------------------------


;dir = '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data'
dir = '/Data4/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data'
Flist = file_search(dir, '*.lbl')

Nf = N_elements(Flist)

if N_params() NE 1 then FILE = 'indexdb.txt'


; 1) Write a better index file


; Structure pour les données/granules
IKSparam = replicate({id:1,Filename:'',Rootname:'',observation_id:1L, time_obs:'',target:'',distance:1.,Sdistance:1., Edistance:1.,sp_min:1.,sp_max:1.,sp_step_min:1.,sp_step_max:1.,sp_res_min:1.,sp_res_max:1., exp_time:1., phase_ang:1., Inst_Name:'',Inst_Host_name:'', ref:'NULL',a_url:'',a_format:'',o_url:'',o_format:''},Nf) 


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
IKSparam(i).a_format = 'votable'
; @Cor2014: added link to native file 
IKSparam(i).o_url = 'http://pdssbn.astro.umd.edu/holdings/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'+nomps
IKSparam(i).o_format = 'ascii'

endfor
IKSparam.id = indgen(Nf)+1

write_csv, FILE, IKSparam



; 2) Write an SQL procedure
; (Adapted from massedb.sql, EPN-TEP tutorial)


Nschema= "iks"
Ntable = "data_table"

File= 'iks_db.sql'
openw, LUN, /get_lun, FILE 

cstsql= $
['-- SQL procedure to define the IKS service datatable  ',$
'-- Stephane Erard, LESIA/PADC, '+systime() +' (written by IDL routine dbiks.pro)',$
'-- Can be used as a template for other light services ',$
' ',$
'-- With no DaCHS, database "IKS", must be created first;       ',$
' ',$
'-- Name: '+ Nschema+'; Type: SCHEMA; Schema: '+ Nschema+'; Owner: postgres',$
'',$
'DROP SCHEMA IF EXISTS '+Nschema+' cascade;',$
'-- line above to be commented for tests only',$
'CREATE SCHEMA '+Nschema+';',$
'SET search_path = public, pg_catalog;',$
'',$
"SET default_tablespace = '';",$
'',$
'SET default_with_oids = false;',$
'',$
'-- Name: '+Ntable+'; Type: TABLE; Schema: '+Nschema+'; Owner: postgres; Tablespace: ',$
'',$
'CREATE TABLE '+Nschema+'.'+Ntable+' (',$	; must follow IKSparam structure fields
'    id integer NOT NULL,',$
'    filename 		character varying(12),',$
'    rootname 		character varying(8),',$
'    observation_id character varying(6),',$
'    time_obs 		character varying(23),',$
'    target 		character varying(6),',$
'    distance 		float,',$	; means double-precision in SQL
'    Sdistance 		float,',$		;	@Cor2014: added new fields
'    Edistance 		float,',$
'    sp_min 		float,',$
'    sp_max 		float,',$
'    sp_step_min 	float,',$
'    sp_step_max 	float,',$
'    sp_res_min 	float,',$
'    sp_res_max 	float,',$
'    exp_time 		float,',$
'    phase_ang 		float,',$		;	@Cor2015: added new fields
'    inst_name 		character varying(3),',$
'    inst_host_name character varying(6),',$
'    ref 			character varying(60),',$	;	@Cor2014: added new fields
'    a_url 			character varying(94),',$
'    a_format 		character varying(7),',$
'    o_url 			character varying(94),',$	;	@Cor2014: added new fields
'    o_format 		character varying(5)',$
');']
printf, Lun, ' '
; -- the lines after CREATE TABLE could be derived from iksparam structure definition + SQL type…


for ii = 0, N_elements(cstsql)-1 do $
 printf, Lun, cstsql(ii)
printf, Lun, ' '


;dir= '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'
dir= '/Data4/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'

columns = strlowcase(tag_names(IKSparam))
Nfield = N_tags(iksparam)
;		sql = "INSERT INTO "+Nschema+'.'+Ntable+" ("
;		sql = sql + strjoin(columns[indf], ", ") 
;		sql = sql +  ") VALUES "
;printf, Lun, sql
;for ii=0, Nf-1 do begin
;		sql = '(' 
; for jj=0, Nfield-2 do begin
;		sql = sql + string((IKSparam.(jj))(ii))+ ", "
; endfor
;		sql = sql + string((IKSparam.(jj))(ii))+ ") " 
;printf, Lun, sql
;endfor
;printf, Lun, ''
; ça va pas : faut mettre des quotes sur les string, et virer les espaces en trop

; alt (similaire à la version de Pierre)
indf = indgen(Nfield)
		sql = "COPY "+Nschema+'.'+Ntable+" ("
		sql = sql + strjoin(columns[indf], ", ") 
		sql = sql +  ") FROM stdin;"
printf, Lun, sql
for ii=0, Nf-1 do begin
 for jj=0, Nfield-2 do $
		 printf, lun, strtrim((IKSparam.(jj))(ii),2),string(9B), format = '(A,1A, $)'	; ascii 9 = HT, required as separator
		 printf, lun, strtrim((IKSparam.(jj))(ii),2), format = '(A)'	; last item
endfor
printf, Lun, '\.'	; terminates data entry, must be there

printf, Lun, ' '



cstsql= $
['ALTER TABLE ONLY '+Nschema+'.'+Ntable , $
'        ADD CONSTRAINT '+Ntable+'_pkey PRIMARY KEY (id);']

printf, Lun, cstsql
printf, Lun, ''


cstsql= $
['-- Set access/ownership of schema and table',$
' ',$
'REVOKE ALL ON SCHEMA "' + Nschema+'" FROM PUBLIC;',$
' ',$
'REVOKE ALL ON SCHEMA "' + Nschema+'" FROM postgres;',$
' ',$
'GRANT ALL ON SCHEMA "'+Nschema+'" TO postgres;',$
' ',$
'GRANT ALL PRIVILEGES ON SCHEMA '+Nschema+' TO gavo WITH GRANT OPTION; ',$
'GRANT ALL PRIVILEGES ON SCHEMA '+Nschema+' TO gavoadmin WITH GRANT OPTION; ',$
'GRANT ALL PRIVILEGES ON '+Nschema+'.'+Ntable+' TO gavo WITH GRANT OPTION; ',$
'GRANT ALL PRIVILEGES ON '+Nschema+'.'+Ntable+' TO gavoadmin WITH GRANT OPTION; ']
;'GRANT ALL PRIVILEGES ON '+Nschema+'.dataset TO gavo WITH GRANT OPTION; ',$
;'GRANT ALL PRIVILEGES ON '+Nschema+'.dataset TO gavoadmin WITH GRANT OPTION; ',$
;'GRANT ALL PRIVILEGES ON '+Nschema+'.epn_core TO gavo WITH GRANT OPTION; ',$
;'GRANT ALL PRIVILEGES ON '+Nschema+'.epn_core TO gavoadmin WITH GRANT OPTION; ']
printf, Lun, cstsql
printf, Lun, ' '




close, Lun
free_lun, Lun
End
