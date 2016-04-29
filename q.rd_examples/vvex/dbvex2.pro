Pro dbvex2, FILE

;+
; NAME:
;	dbvex2
;
; EFFECT:
; Reads Virtis VEx extended index from the archive, parse parameters, writes an SQL routine to write the database
; This is one step in the creation of an EPN-TAP service, can be used as a template for other PDS3 datasets
;
; EXAMPLE
;	dbvex, [FILE]
;
; KEYWORDS:
; FILE: name of output file - blocked to 'vex_db2.sql'
;
; USAGE:
; - Create database VVEx in pgAdmin
; - run this IDL procedure, then (in terminal):
;	cd /whatever/Virtis_VEx
;	sudo -s -u postgresql
;	psql  VVEX < vex_db2.sql
; - refresh VEx db in PgAdmin to see the new db
; - create views (dataset & epn_core) with routine vex_views.sql
;	psql VVEX < vex_views.sql  
; (- transform ascii data files in VOTable using catiksfiles.pro)
; - instal in gavo with file q.rd (hand written)
; - declare service in registry with file vopdc_obspm-lesia-epn-vex.xml (hand written)
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
;	dbiks.pro
;  Stephane Erard, nov 2013 (first SQL-writing routine, partly derived from catIKS)
;  SE, May 2014: corrections and modif in table and SQL routine => @Cor2014
;	dbvex.pro
;  SE, may 2015: adapted to Virtis VEx, in progress
;	dbvex2.pro
;  SE, april 2016: Complete mission from Virtis VEx archive (including VV), v2 + new param & thumbnails
; ------------------------------------------------------------------------------------


;dir = '/Volumes/Data3/VEx/archive_model_deliv1e/INDEX/'
; Flist = file_search(dir, '*.LBL')
;cd, dir
;Flist= '/Volumes/Data3/VEx/archive_model_deliv1e/INDEX/VIRTIS_INDEX.LBL'
; doesn't work
; il doit y avoir un truc pourri vers la fin du fichier

; Flist = file_search(dir, '*.LBL')


; this one is OK - a dummy mini file for testing ; no longer works
;dir = '/Data4/RSI/perso_IDL/MaPomme/VO-essais/VIRTIS_VEx'
;Flist= 'BID_INDEX.LBL'

; **** short for tries
dir = '/Data4/RSI/perso_IDL/MaPomme/VO-essais/VIRTIS_VEx/2013'
 Flist= 'BID3court_INDEX.LBL'


; Old file with only CAL versions - nominal mission only, Vis missing
;dir = '/Data4/RSI/perso_IDL/MaPomme/VO-essais/VIRTIS_VEx'
;Flist= 'BID2_INDEX.LBL'

; ** Complete file with only CAL versions - nominal mission only
;dir = '/Data4/RSI/perso_IDL/MaPomme/VO-essais/VIRTIS_VEx/2013'
;Flist= 'BID3_INDEX.LBL'
;Flist= ['BID3_INDEX.LBL','BID3_INDEX_1.LBL','BID3_INDEX_2.LBL','BID3_INDEX_3.LBL','BID3_INDEX_4.LBL']
; for complete mission: concatenate files first in shell, not in routine.

cd, dir, cur = dir0




fdima=Flist(0)
temp=v_readpds(fdima,/silent, lab)
Nf = (size(temp.index_table.column1))(1)			; nb of files described
Nparam = (size(temp.index_table.column_names))(1)	; nb of param in index

cd, dir0


; to list the field, beware of the offset:
;	for ii = 0, 41 do print, ii+1, '  ', temp.column_names(ii)

; 1) Select files of interest

; only preserve *.CAL
;toto= (strsplit(temp.index_table.(1), '.', /ext))  
;NomTot = (toto.ToArray())(*,1)
;indfich = where(Nomtot EQ 'CAL"', Nf) 

; très compliqué, il vaut mieux trier dans le shell et preparer un fichier

  
; Structure for granules
VExparam = replicate({id:1,Filename:'',Rootname:'',orbit:1L, time_start:'', time_end:'',target:'',targetType:'',target_distance_min:1.,target_distance_max:1.,s_c_point:'',RA:-999.,DECli:-999.,modeID:1L, lat_min:1.,lat_max:1.,lon_min:1.,lon_max:1., local_t_min:1.,local_t_max:1.,sp_min:1.,sp_max:1.,sp_step_min:1.,sp_step_max:1.,sp_res_min:1.,sp_res_max:1., exp_time:1., time_samp:1., Inst_Name:'',Inst_Host_name:'', ref:'NULL',a_url:'',a_format:'', a_Gurl:'',th_url:'NULL',th_url1:'NULL',th_Gurl:'NULL',sizeD:1L, sizeG:1L, s_region:'', creattime:''},Nf) 
  
;stop



; 2) Get parameters from index file, build parameter structure

  ; faire Nf : nb de fichiers dans la struct
  ; ensuite c'est seulement
;  iksparam.filename =  temp.index_table.(1)   

VExparam.id = indgen(Nf)+1
;VExparam.Inst_name = replicate('"VIRTIS"', Nf)
VExparam.Inst_name = replicate('VIRTIS', Nf)
;VExparam.Inst_host_name = replicate('"Venus Express"', Nf)
VExparam.Inst_host_name = replicate('Venus-Express', Nf)

; parse filename
;VExparam.Filename = temp.index_table.(1)
;nomout = (strsplit(temp.index_table.(1), '/', /extr))(-1)
;nomout= (strmid(temp.index_table.(1), strlen(temp.index_table.(1))-15,14))
;nomout= (strmid(temp.index_table.(1), strsplit(temp.index_table.(1), '/')(-1),14))
toto= (strsplit(temp.index_table.(1), '/'))	; this is a list in IDL 8.2!
refslash = (toto.ToArray())(*,4)	; location of last /
nomF =strarr(Nf)
;for ii = 0, Nf-1 do  nomF(ii)= '"'+ (strmid(temp.index_table.((1))(ii), refslash(ii),14)) ; with quotes
for ii = 0, Nf-1 do  nomF(ii)=  (strmid(temp.index_table.((1))(ii), refslash(ii),13))	; no quotes
VExparam.Filename = nomF
for ii = 0, Nf-1 do VExparam(ii).Rootname = (strsplit(nomF(ii), '.', /extr))(0)
; M files:
Mfiles = where(strmid(VExparam.rootname,0, 2) NE 'VT', Nm)
MVfiles = where(strmid(VExparam.rootname,0, 2) EQ 'VV', Nmv)

VExparam.Orbit = temp.index_table.(8)
VExparam.time_start = strmid((temp.index_table.(6)),1,23)  
VExparam.time_end = strmid((temp.index_table.(7)),1,23)  
VExparam.creattime = strmid((temp.index_table.(42)),1,23)  

toto = (strsplit(strtrim(temp.index_table.(9)), '"', /extr))	; remove extra spaces on shorter strings!
bid =(toto.ToArray())(*,0)
VExparam.target = strupcase(strmid(bid,0,1))+strlowcase(strmid(bid,1))  ; @Cor2016: std spelling (if one word)

nomtot= replicate('planet', Nf)
indtarg = where(VExparam.Target EQ 'Star', c0)
If c0 NE 0 then NomTot(indtarg) = 'Star'
VExparam.targetType = nomtot


VExparam.target_distance_min = temp.index_table.(29)
VExparam.target_distance_max = temp.index_table.(29)
VExparam.lat_min = temp.index_table.(24)
VExparam.lat_max = temp.index_table.(23)
VExparam.lon_min = temp.index_table.(26)
VExparam.lon_max = temp.index_table.(25)
; VExparam.local_t = (temp.index_table.(28)+24.*(temp.index_table.(28) LT temp.index_table.(27)) + temp.index_table.(27))/2. mod 24.
; separate
VExparam.local_t_min = temp.index_table.(27)
VExparam.local_t_max = temp.index_table.(28)

VExparam.ref =replicate('ftp://psa.esac.esa.int/pub/mirror/VENUS-EXPRESS/VIRTIS/VEX-V-VIRTIS-2-3-V3.0/DOCUMENT/VIRTIS_EAICD.PDF',Nf)

; URL of PDS file
; adjust according to mission phase/orbit (from PSA ftp + data workshop)
indorb0 = where(VExparam.Orbit LE 521 and VExparam.Orbit GE 23, c0)
indorb1 = where(VExparam.Orbit LE 1132 and VExparam.Orbit GE 563, c1)
indorb2 = where(VExparam.Orbit LE 1575 and VExparam.Orbit GE 1139, c2)
indorb3 = where(VExparam.Orbit GE 1587, c3)

PSAurl = 'ftp://psa.esac.esa.int/pub/mirror/VENUS-EXPRESS/VIRTIS/'
ext0 = PSAurl+"VEX-V-VIRTIS-2-3-V3.0/"
ext1 = PSAurl+"VEX-V-VIRTIS-2-3-EXT1-V2.0/"
ext2 = PSAurl+"VEX-V-VIRTIS-2-3-EXT2-V2.0/"
ext3 = PSAurl+"VEX-V-VIRTIS-2-3-EXT3-V2.0/"
toto = (strsplit(temp.index_table.(1), '"', /extr))
NomTot = (toto.ToArray())(*,0)

; this actually works!
If c0 NE 0 then NomTot(indorb0) = ext0+NomTot(indorb0)
If c1 NE 0 then NomTot(indorb1) = ext1+NomTot(indorb1)
If c2 NE 0 then NomTot(indorb2) = ext2+NomTot(indorb2)
If c3 NE 0 then NomTot(indorb3) = ext3+NomTot(indorb3)
VExparam.a_url = nomtot
;VExparam.a_url = 'ftp://psa.esac.esa.int/pub/mirror/VENUS-EXPRESS/VIRTIS/'+ext+temp.index_table.(1)

; geometry
tata= VExparam.a_url
; process in sequence
for ii = 0, Nf-1 do tata(ii) = STRJOIN(STRSPLIT(tata(ii), "CALIBRATED", /ext, /reg), "GEOMETRY") 
for ii = 0, Nf-1 do tata(ii) = STRSPLIT(tata(ii), ".CAL", /ext, /reg)+ ".GEO" ; strjoin doesn't work at end of string
VExparam.a_Gurl = tata

; thumbnails
tata =strarr(Nf)
tata(Mfiles)= (VExparam.a_url)(Mfiles)
; process in sequence
for ii = 0, Nm-1 do tata(Mfiles(ii)) = STRJOIN(STRSPLIT(tata(Mfiles(ii)), "DATA", /ext, /reg), "BROWSE") 
; 		beware of initial // here:
for ii = 0, Nm-1 do tata(Mfiles(ii)) = 'ftp://'+STRJOIN((STRSPLIT(tata(Mfiles(ii)), "/", /ext))(1:-4),'/')+'/'+(VExparam.rootname)(Mfiles(ii)) ; +'_C.JPG'
;tata(Hfiles) = ''	; no thumbnail for H
VExparam.th_url = tata
for ii = 0, Nm-1 do tata(Mfiles(ii)) = '_C.JPG'
for ii = 0, Nmv-1 do tata(MVfiles(ii)) = '_A.JPG'
VExparam.th_url1 = tata
for ii = 0, Nm-1 do tata(Mfiles(ii)) = '_H.JPG'
for ii = 0, Nmv-1 do tata(MVfiles(ii)) = '_D.JPG'
VExparam.th_Gurl = tata

VExparam.a_format = 'PDS3'



toto = (strsplit(strtrim(temp.index_table.(30)), '"', /extr))	; remove extra spaces on shorter strings!
VExparam.s_c_point  =(toto.ToArray())(*,0)	

indtarg = where(VExparam.s_c_point EQ 'INERT', c0)
If c0 NE 0 then begin
 VExparam(indtarg).RA = (temp.index_table.(22))(indtarg)
 VExparam(indtarg).DECli = (temp.index_table.(23))(indtarg)
endif

VExparam.modeID  = temp.index_table.(17)

VExparam.sizeD = temp.index_table.(10)*temp.index_table.(11)*temp.index_table.(12) * 4 / 1024
VExparam.sizeG = 41*temp.index_table.(11)*temp.index_table.(12) * 4	/ 1024
VExparam(Mfiles).sizeG = 33*(temp.index_table.(11)*temp.index_table.(12))(Mfiles) * 4 / 1024	; M geom files

; Sp resolution, now accounts for M binning mode

channel = strmid(nomf,1,1) 
indI = where(channel EQ 'I', cI)
indV = where(channel EQ 'V', cV)
lam= v_lamh(wid=wid) ; VEx

bid = replicate(min(lam),Nf)	; defaut to H
if cI NE 0 then bid(indI) = 1.025
if cV NE 0 then bid(indV) = 0.288147
VEXparam.sp_min = float(bid)
bid = replicate(max(lam),Nf)	; defaut to H
if cI NE 0 then bid(indI) = 5.116
if cV NE 0 then bid(indV) = 1.11470
VEXparam.sp_max = float(bid)

; binned spectral mode occurs only with I
bid1 = (lam)- shift(lam, -1)
bid  = replicate(min(bid1(0+432*7:430+432*7)), Nf)
if cI NE 0 then bid(indI) = 0.00949705 *432. / (temp.index_table.(10))(indI)
if cV NE 0 then bid(indV) = 0.002  
VEXparam.sp_step_min = float(bid)
bid = replicate(max(bid1(0:430)), Nf)
if cI NE 0 then bid(indI) = 0.00949705 *432. / (temp.index_table.(10))(indI)
if cV NE 0 then bid(indV) = 0.002
VEXparam.sp_step_max = float(bid)

	; actual spectral resolution, from ??
bid = replicate(min(wid(0+432*7:431+432*7)), Nf)
if cI NE 0 then bid(indI) = 0.0121839 *432. / (temp.index_table.(10))(indI)
if cV NE 0 then bid(indV) = 0.00191775
VEXparam.sp_res_min = float(bid)
bid = replicate(max(wid(07:431)), Nf)
if cI NE 0 then bid(indI) = 0.0121839 *432. / (temp.index_table.(10))(indI)
if cV NE 0 then bid(indV) = 0.00191775
VEXparam.sp_res_max = float(bid)


indHobs = where(channel EQ 'H' or channel EQ 'S' or channel EQ 'T' and temp.index_table.(15) NE -1)
bid = temp.index_table.(15)		; individual exp time 
bid(indHobs) = bid(indHobs) /1000.	; int time in ms for H
VExparam.exp_time = bid  * temp.index_table.(13)	; x summed frames

VExparam.time_samp = temp.index_table.(16)

VExparam.s_region = "Polygon 153.311 2.548 165.374 2.594 177.980 1.985 189.941 0.806 193.336 -10.169 196.416 -38.171 203.565 -53.349 180.079 -58.780 154.473 -57.614 133.818 -50.372 143.051 -35.946 149.022 -8.905"


; 3) Write an SQL procedure
; (Adapted from massedb.sql, EPN-TEP tutorial)


Nschema= "vvex"
Ntable = "data_table"

File= 'vex_db2.sql'
openw, LUN, /get_lun, FILE 

cstsql= $
['-- SQL procedure to define the draft VVEx service datatable  ',$
'-- Stephane Erard, LESIA/PADC, '+systime() +' (written by IDL routine dbvex2.pro)',$
'-- Can be used as a template for other light services ',$
' ',$
'-- With no DaCHS, database "VVEX", must be created first;       ',$
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
'CREATE TABLE '+Nschema+'.'+Ntable+' (',$	; must follow VEXparam structure fields
'    id integer NOT NULL,',$
'    filename 			character varying(13),',$
'    rootname 			character varying(10),',$	; @Cor2016: ajout
'    orbit 				character varying(6),',$
'    time_start			character varying(23),',$
'    time_end			character varying(23),',$
'    target				character varying(8),',$
'    targetType			character varying(8),',$	; @Cor2016: ajout
'    target_distance_min	float,',$
'    target_distance_max	float,',$				; @Cor2016: ajout
'    s_c_point			character varying(11),',$	; @Cor2016: ajout
'    RA					float,',$	; @Cor2016: ajout
'    DECli				float,',$	; @Cor2016: ajout
'    modeID				character varying(6),',$	; @Cor2016: ajout
'    lat_min 			float,',$
'    lat_max 			float,',$
'    lon_min 			float,',$
'    lon_max 			float,',$
'    local_t_min 		float,',$
'    local_t_max 		float,',$
'    sp_min				float,',$	; means double-precision in SQL
'    sp_max				float,',$
'    sp_step_min 		float,',$
'    sp_step_max 		float,',$
'    sp_res_min			float,',$
'    sp_res_max			float,',$
'    exp_time 			float,',$
'    time_samp 			float,',$		; @Cor2016: ajout
'    inst_name 			character varying(6),',$
'    inst_host_name		character varying(13),',$
'    ref 				character varying(110),',$	
'    a_url 				character varying(130),',$
'    a_format 			character varying(7),',$
'    a_Gurl				character varying(130),',$   	; @Cor2016: ajout
'    th_url				character varying(130),',$   	; @Cor2016: ajout
'    th_url1			character varying(130),',$   	; @Cor2016: ajout
'    th_Gurl			character varying(130),',$   	; @Cor2016: ajout
'    SizeD 				integer,',$   	; @Cor2016: ajout
'    SizeG 				integer,',$   	; @Cor2016: ajout
'    s_region 			character varying(210),',$		; @Cor2016: ajout, try
'    creattime 			character varying(23)',$		; @Cor2016: ajout
');']
printf, Lun, ' '
; -- the lines after CREATE TABLE could be derived from vexparam structure definition + SQL type…


for ii = 0, N_elements(cstsql)-1 do $
 printf, Lun, cstsql(ii)
printf, Lun, ' '


;dir= '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'

columns = strlowcase(tag_names(VEXparam))
Nfield = N_tags(vexparam)
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
		 printf, lun, strtrim((VEXparam.(jj))(ii),2),string(9B), format = '(A,1A, $)'	; ascii 9 = HT, required as separator
		 printf, lun, strtrim((VEXparam.(jj))(ii),2), format = '(A)'	; last item
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
;'GRANT ALL PRIVILEGES ON SCHEMA public TO gavo WITH GRANT OPTION; ',$
;'GRANT ALL PRIVILEGES ON SCHEMA public TO gavoadmin WITH GRANT OPTION; ',$
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

stop
End
