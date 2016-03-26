;+
; NAME:
;	catiksfiles
;
; EFFECT:
;   Read IKS/Vega-1 spectra (PDS3) and convert to VOTables
;
; EXAMPLE:
;	catiksfiles
;
;
; EXTERNAL :
; 	Uses v_readpds library to read the PDS files + v_time to write ISO time
;
; PRECAUTIONS :
; 	Use unit = dateTime to introduce an ISO time string => xtype='dateTime' (XML std, not VOTable)
;
; HISTORY:
;  Stephane Erard, LESIA, oct 2013
;		VOtable conversion, adapted from a routine by Baptiste Cecconi.
;		-- Should complete PARAM handling
;  SE, 14/11/2013: fixed minor issues (some values & units in PARAMs)
;		+ now handles the unique data file with 3 columns 
;		+ fixed scaling factor according to Combes et al 1988
; --------------------------------------------------------------------------------------------------


Function writeVOtable, fdima
;+
; NAME:
;	writeVOtable
;
; EFFECT:
; Writes a VOTable from an IKS spectrum. Does not return a value
;
; CALL:
;	res = writeVOtable(file)
;
; ARGUMENT :
; FILE : name of original ascii file

 
metadata = {name:'IKS spectral data',$
            description:'Calibrated data of 1P/Halley from the spectral channel of IKS on Vega-1',$
            dateStart:'1986-03-06T00:00:00.000Z',$
            dateStop:'1986-03-06T23:59:99.999Z',$
            contact_name:"Stephane Erard",$
            create_date:'2013-10-07T10:09:00.00',$
            modify_date:' '}

metadata.modify_date = v_time()	; Virtis function, provides current UTC as an ISO string

dir= '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'tab = v_readpds(fdima, lab, /silent)	

; Structure for table  metadata
IKSparam = {Fname:'',obsid:'', time:'',target:'',distance:1.,InstN:'',Host:''} 

; grab metadata from header
;   lab=v_headpds(fdima,/silent)
fdima = FILE_BASENAME(fdima)	; remove dir 
nomps = (strsplit(fdima, '.', /extr))(0)+'.tab' ; replace any extension
nomout = (strsplit(fdima, '.', /extr))(0)+'.xml' ; replace any extension
IKSparam.Fname = nomps
bid = v_pdspar(lab, 'TARGET_NAME')
IKSparam.target = strlowcase(bid)
bid = v_pdspar(lab, 'OBSERVATION_TIME')
IKSparam.time = strlowcase(bid)
bid = v_pdspar(lab, 'TARGET_CENTER_DISTANCE')
IKSparam.distance = float(bid)
bid = v_pdspar(lab, 'OBSERVATION_ID')
IKSparam.obsid = strlowcase(bid)
IKSparam.InstN = 'iks'
IKSparam.Host = 'vega-1'
;	orginal files from SBNPDS
;IKSparam.url = 'http://pdssbn.astro.umd.edu/holdings/vega1-c-iks-3-rdr-halley-processed-v1.0/data/'+nomps
;IKSparam.format = 'ascii'
	; modified VOtable files at VO-Paris
;IKSparam(i).url = 'http://voparis-srv.obspm.fr/vo/planeto/iks/'+nomout
;IKSparam(i).format = 'votable'

; data proper
table = tab.table.column1Nfield = (size(tab.column_names, /dim))(0)	; nb of columnsfor j=2, Nfield do table = [[table],[tab.table.(j)]]table = transpose(table)
	; correct scaling factor from Combes et al
If nomps EQ 'iksfinal.tab' then table(1,*) = table(1,*)*1E-6 $
	else table(1,*) = table(1,*)*1E-7


; describe data columns
;Nfield = (size(table, /dim))(0)
Ndata = (size(table, /dim))(1)
field = replicate({name:'', ID:'', datatype:'', unit:'', ucd:''}, nfield)
field(0:1).name = ['wavelength','radiance']	; some files have only two columns
field(0:1).ID = ['wvl','rad']
field(0:1).datatype = ['double','double']
field(0:1).unit = ['um','W/cm**2/sr/um']
field(0:1).ucd = ['em.wl','phot.flux.density']
;field.fill = ['','']

If Nfield EQ 3 then begin	; if error bar provided
 field(2).name = 'error'
 field(2).ID = 'err'
 field(2).datatype = 'double'
 field(2).unit = 'W/cm**2/sr/um'
 field(2).ucd = 'stat.error;phot.flux.density'
endif


; Creating DOM document
xDoc = OBJ_NEW('IDLffXMLDOMDocument')

; VOTABLE element
xVotable = xDoc->createElement('VOTABLE')
xvotable->setAttribute,'version','1.2'
xvotable->setAttribute,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance'
xvotable->setAttribute,'xmlns','http://www.ivoa.net/xml/VOTable/v1.2'
xvotable->setAttribute,'xsi:schemaLocation','http://www.ivoa.net/xml/VOTable/v1.2 http://www.ivoa.net/xml/VOTable/VOTable-1.2.xsd'
void = xDoc->AppendChild(xVotable)

; VOTABLE/RESOURCE element
xResource = xdoc->createElement('RESOURCE')
xResource->setAttribute,'name',metadata.name
void = xVotable->AppendChild(xResource)

; VOTABLE/RESOURCE/TABLE element 
xTable = xDoc->createElement('TABLE')
void = xResource->appendChild(xTable)

; -- champ CDATA: ascii characters used as is, no interpretation
; -- This should appear before the table (but OK in TOPCAT)
; VOTABLE/RESOURCE/TABLE/DESCRIPTION element 
xdescription = xDoc->createElement('DESCRIPTION')
void = xTable->appendChild(xDescription)
xDescData = xdoc->createCDATASection(metadata.description)
void = xDescription->appendChild(xDescData)

; -- absent from DaCHS output
; VOTABLE/RESOURCE/TABLE/GROUP[Time Range] element  
;xGroupTimeRange = xDoc->createElement('GROUP')
;xGroupTimeRange->setAttribute,'name','Time Range'
;xGroupTimeRange->setAttribute,'utype','spase:Catalog/TimeSpan'
;void = xTable->appendChild(xGroupTimeRange)

; VOTABLE/RESOURCE/TABLE/GROUP[Time Range]/PARAM[Start Time] element 
;xParamStartTime = xDoc->createElement('PARAM');
;xParamStartTime->setAttribute,'name','Catalog Start Time'
;xParamStartTime->setAttribute,'arraysize','*'
;xParamStartTime->setAttribute,'datatype','char'
;xParamStartTime->setAttribute,'xtype','dateTime'
;xParamStartTime->setAttribute,'ucd','time.start'
;xParamStartTime->setAttribute,'utype','spase:Catalog/TimeSpan/StartDate'
;xParamStartTime->setAttribute,'value',metadata.dateStart
;void = xGroupTimeRange->appendChild(xParamStartTime)

; VOTABLE/RESOURCE/TABLE/GROUP[Time Range]/PARAM[Stop Time] element 
;xParamStopTime = xDoc->createElement('PARAM');
;xParamStopTime->setAttribute,'name','Catalog Stop Time'
;xParamStopTime->setAttribute,'arraysize','*'
;xParamStopTime->setAttribute,'datatype','char'
;xParamStopTime->setAttribute,'xtype','dateTime'
;xParamStopTime->setAttribute,'ucd','time.stop'
;xParamStopTime->setAttribute,'utype','spase:Catalog/TimeSpan/StopDate'
;xParamStopTime->setAttribute,'value',metadata.dateStop
;void = xGroupTimeRange->appendChild(xParamStopTime)


; VOTABLE/RESOURCE/TABLE/GROUP[Contact]/PARAM[Name] element 
;xparamContactName = xDoc->createElement('PARAM');
;xparamContactName->setAttribute,'arraysize','*'
;xparamContactName->setAttribute,'datatype','char'
;xparamContactName->setAttribute,'name','Name'
;xparamContactName->setAttribute,'utype','spase:Person/PersonName'
;xparamContactName->setAttribute,'value',metadata.contact_name
;void = xGroupContact->appendChild(xparamContactName)
  


; Should loop on PARAM, like for fields
; adds common metadata (Obs #)
xparamObsID = xDoc->createElement('PARAM');
xparamObsID->setAttribute,'arraysize','*'
xparamObsID->setAttribute,'datatype','char'
xparamObsID->setAttribute,'name','observation_id'
xparamObsID->setAttribute,'utype',''
xparamObsID->setAttribute,'ucd','meta.id;class'
xparamObsID->setAttribute,'value',strtrim(IKSparam.obsid,2)
void = xtable->appendChild(xparamObsID)
; adds common metadata (distance)
xparamDist = xDoc->createElement('PARAM');
xparamDist->setAttribute,'datatype','float'
xparamDist->setAttribute,'name','distance'
xparamDist->setAttribute,'utype',''
xparamDist->setAttribute,'ucd','pos.distance'
xparamDist->setAttribute,'unit','km'
xparamDist->setAttribute,'value',strtrim(string(IKSparam.distance),2)
void = xtable->appendChild(xparamDist)


; VOTABLE/RESOURCE/TABLE/PARAM[CreateDate] element 
xparamCreateDate = xDoc->createElement('PARAM');
xparamCreateDate->setAttribute,'arraysize','*'
xparamCreateDate->setAttribute,'datatype','char'
xparamCreateDate->setAttribute,'xtype','dateTime'
xparamCreateDate->setAttribute,'name','CreateDate'
xparamCreateDate->setAttribute,'ucd','time.creation'
xparamCreateDate->setAttribute,'value',metadata.create_date
void = xtable->appendChild(xparamCreateDate)

; VOTABLE/RESOURCE/TABLE/PARAM[ModifyDate] element 
xparamModifyDate = xDoc->createElement('PARAM')
xparamModifyDate->setAttribute,'arraysize','*'
xparamModifyDate->setAttribute,'datatype','char'
xparamModifyDate->setAttribute,'xtype','dateTime'
xparamModifyDate->setAttribute,'name','ModifyDate'
xparamModifyDate->setAttribute,'value',metadata.modify_date;
void = xtable->appendChild(xparamModifyDate);


; VOTABLE/RESOURCE/TABLE/FIELD elements 
xfield = OBJARR(nfield)
xvalues = OBJARR(nfield)
for i=0,nfield-1 do begin
  xfield(i) = xDoc->createElement('FIELD')
  xfield(i)->setAttribute,'ID',field(i).ID
  xfield(i)->setAttribute,'name',field(i).name
  if (field(i).unit EQ "dateTime") then begin	; -- if ISO encoding
    xfield(i)->setAttribute,'arraysize','*'
    xfield(i)->setAttribute,'datatype','char'
    xfield(i)->setAttribute,'xtype','dateTime'
    xfield(i)->setAttribute,'ucd','time.epoch'
  endif else if (field(i).datatype EQ "char") then begin
    xfield(i)->setAttribute,'arraysize','*'
    xfield(i)->setAttribute,'datatype','char'
    xfield(i)->setAttribute,'unit',field(i).unit
    xfield(i)->setAttribute,'ucd',field(i).ucd
;    xfield(i)->setAttribute,'utype',field(i).utype
  endif else begin
    xfield(i)->setAttribute,'datatype',field(i).datatype
    xfield(i)->setAttribute,'unit',field(i).unit
    xfield(i)->setAttribute,'ucd',field(i).ucd
;    xfield(i)->setAttribute,'utype',field(i).utype
  endelse

; -- absent from DaCHS output
;  xvalues(i) = xDoc->createElement('VALUES')
;  xvalues(i)->setAttribute,'null',field(i).fill
;  void = xfield(i)->appendChild(xvalues(i))

  void = xTable->appendChild(xfield(i))
endfor
  
; VOTABLE/RESOURCE/TABLE/DATA element 
xData = xDoc->createElement('DATA');
void = xTable->appendChild(xdata)

; VOTABLE/RESOURCE/TABLE/TABLEDATA element 
xtabledata = xdoc->createElement('TABLEDATA');
void = xdata->appendChild(xtabledata);

xtr = objarr(ndata)
xtd = objarr(ndata,nfield)
xlinedata = objarr(ndata,nfield)

; data area
for j=0l,ndata-1l do begin

  xtr(j) = xdoc->createElement('TR')
  for i=0,nfield-1 do xtd(j,i) = xdoc->createElement('TD')
  for i=0,nfield-1 do xlinedata(j,i) = xdoc->createTextNode(strtrim(string(table(i,j)),2))
  for i=0,nfield-1 do void = xtd(j,i)->appendChild(xlinedata(j,i))
  for i=0,nfield-1 do void = xtr(j)->appendChild(xtd(j,i))
  void = xtabledata->appendChild(xtr(j))
  
endfor

; Writing XML file
xDoc->save, filename=nomout, /pretty


return, 0
END


Pro catiksfiles

dir = '/Volumes/Data3/Comets/vega1-c-iks-3-rdr-halley-processed-v1.0/data'
Flist = file_search(dir, '*.lbl')

Nf = N_elements(Flist)


For i =0, Nf-1 do begin
;For i =0, 1 do begin	; for test
  fdima=Flist(i)
  res = writeVOtable(fdima)
endfor

END
