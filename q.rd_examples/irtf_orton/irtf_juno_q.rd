<?xml version="1.0" encoding="UTF-8" ?>

<resource schema="irtf_juno">
	<meta name="title">NASA IRTF NIR Jupiter Observations</meta>
	<meta name="creationDate">2016-04-25T12:42:00Z</meta>
	<meta name="description" format="plain">
		NASA IRTF NIR Jupiter Observations in suport of the NASA/JUNO mission.
	</meta>
        <meta name="facility">NASA IRTF</meta>
	<meta name="copyright" format="raw">
		<![CDATA[
		This database is not public. The data should not be used.
		]]>
	</meta>
	<meta name="creator.name">Baptiste Cecconi</meta>
	<meta name="subject">Jupiter</meta>
	<meta name="subject">Atmosphere</meta>
	<meta name="subject">Aurora</meta>
	<meta name="referenceURL">http://irtfweb.ifa.hawaii.edu/~spex/</meta>
	<meta name="facility">Mauna Kea Observatory, IRTF NASA Telescope</meta>
	<meta name="instrument">SpeX GuideDog (SGD)</meta>
	<meta name="coverage.waveband">Infrared</meta>

	<procDef type="apply" id="setInstrConfig">
		
		<!-- This <procDef> defines the variables with instrument configuration setup -->
		
		<code>
			vars["instrument_host_name"] = '#'.join(['568','Mauna Kea Observatory'])
			vars["instrument_name"] = '#'.join([vars["TELESCOP"]])
			vars["detector"] = '#'.join([vars["INSTRUME"],'GuideDog','sgd'])
			filter_lookup = {"H+CH4_s":1.58, "FeII+Open":1.64, "H+CH4_l":1.65, "H2+Open":2.12, "Bry+Open":2.16, "contK+Short3":2.26, 
				"3.417+Open":3.417, "Lp+Open":3.8, "5.1+Long4":5.1}

			### see Table 7, Page 15; http://irtfweb.ifa.hawaii.edu/~spex/SpeX_manual_20mar15.pdf
			gflt_lookup = {"Bry":'2.166 μm 1.5%', "H2":'2.122 μm v=1-0 s(1)', "FeII":'1.644 μm 1.5%', "contK":'2.26 μm 1.5%', 
				"H":'1.487-1.783 um', "Lp":'3.424-4.124 um'}

			### see Table 11, Page 41; http://irtfweb.ifa.hawaii.edu/~spex/SpeX_manual_20mar15.pdf 
			osf_lookup = {"Open":'Open', "Short3":'1.92-2.52 um', "Long4":'4.40-6.00 um', "CH4_s":'1.58 um 6%', "CH4_l":'1.69 um 6%'}

			vars["wavelength"] = filter_lookup['+'.join([vars["GFLT"],vars["OSF"]])]
			vars["filter_dir"] = "{:.02f}".format(vars["wavelength"])
			vars["opt_element"] = " / ".join([":".join(["Slit",vars["SLIT"]]),":".join(["GuideFilter",vars["GFLT"]]),
				":".join(["OrderSortedFilter",vars["OSF"]])])
		</code>
		
	</procDef>

<!--
##
## "zeep" python package must be installed: 
## $ pip install zeep
##
-->
	<procDef type="apply" id="miriadeEphemph">
		
		<!-- input parameters to be set with <bind> elements in <apply> element -->
		
		<setup>
			<par key="ignoreUnknowns" description="Return Nones for unknown
				objects?  (if false, ValidationErrors will be raised)">True</par>
			<par key="logUnknowns" description="Write unresolved object names
				to the info log">False</par>
			<par key="target_name" late="True" 
				description="The observed target name (Default is Jupiter).">'p:jupiter'</par>
			<par key="observer" late="True"
				description="The observer name (Default is Mauna Kea Observatory, for IRTF).">'@568'</par>
			<par key="obs_time" late="True"
				description="Observation date time."/>
			
			<!-- any piece of python code to be run before the main procedure, like importing modules -->
			
			<code>
				import zeep
			</code>
			
		</setup>
		
		<code>
			## This is the beginning of the core python code, indentation matters as in python.
			
			# Initializing some parameters
			slat, slon, olat, olon = None, None, None, None
			np_pos, phase, rap, hemis1, hemis2 = None, None, None, None, None
			
			try:
				# Initialize SOAP client using zeep module
				client = zeep.Client('http://vo.imcce.fr/webservices/miriade/miriade.wsdl')

				# Setting up request parameters (as defined on service description page)
				# NB: Here we will use the ephemph webservice.
				request = {'name': target_name, 'type':'', 'epoch':obs_time.isoformat(), 'nbd':1, 'step':'', 'tscale':'', 'so':1, 
					'observer':observer, 'mime':'text', 'view':'none', 'rv':0, 'anim':0, 'print':1, 'visu':'', 
					'output':'--iso,--coord:eq', 'get':''}

				# Retrieving response from webservice
				response = client.service.ephemph(request)

				# Each line of the output text is separated by ';' characters, 
				# and the data line is the first line not starting with '#'
				# The next command split lines and retrieves the first data line
				for line in (item for item in response['result'].split(';') if item[0] != '#'): break

				# splitting results columns
				data = line.split()
				
				olon = float(data[3])  # Sub-Observer Longitude in Jovian System III (Sub-Earth Point)
				olat = float(data[4])  # Sub-Observer Latitude in Jovian System III (Sub-Earth Point)
				slon = float(data[7])  # Sub-Solar Longitude in Jovian System III
				slat = float(data[8])  # Sub-Solar Latitude in Jovian System III
				np_pos = float(data[9])  # Angle between planetary North pole and celestial North Pole
				phase = float(data[11])  # Phase angle
				rap = float(data[12])  # Apparent radius of target
				
				# in case of APIS extension, we need to tell what is the primary hemisphere (best viewed)
				if olat >= 0:
					hemis1 = 'north'
					hemis2 = 'south'
				else: 
					hemis1 = 'south'
					hemis2 = 'north'

			except KeyError:
				if logUnknowns:
					base.ui.notifyInfo("Identifier did not resolve: %s"%identifier)
				if not ignoreUnknowns:
					raise base.Error("resolveObject could not resolve object"
						" %s."%identifier)
			
			# Preparing output: whatever you put into the vars dictionary can be used outside the procedure.
			# E.g.: vars["subsolar_longitude"] is defined here, and can be used as @subsolar_longitude outside
			vars["subsolar_longitude"] = slon
			vars["subsolar_latitude"] = slat
			vars["subobserver_longitude"] = olon
			vars["subobserver_latitude"] = olat
			vars["np_pos"] = np_pos
			vars["phase"] = phase
			vars["rap"] = rap
			vars["hemis1"] = hemis1
			vars["hemis2"] = hemis2

        </code>
		
	</procDef>

	<table id="epn_core" onDisk="true" adql="True" primary="granule_uid">

		<!-- EPNcore mixin with optional columns -->

		<mixin spatial_frame_type="body" optional_columns="access_url access_format access_estsize time_scale file_name
				thumbnail_url publisher bib_reference target_region">//epntap2#table-2_0</mixin>

		<!-- Extra EPNcore keywords -->

		<column name="ra" ucd="pos.eq.ra" unit="deg" description="RA" type="text"/>
		<column name="dec" ucd="pos.eq.dec" unit="deg" description="Dec" type="text"/>
		<column name="subobserver_latitude" ucd="pos.bodyrc.lat" description="Latitude of Sub-Observer point" unit="deg"/>
		<column name="subsolar_latitude" ucd="pos.bodyrc.lat" description="Latitude of Sub-Solar point" unit="deg"/>
		<column name="subobserver_longitude" ucd="pos.bodyrc.lon" description="Longitude of Sub-Observer point" unit="deg"/>
		<column name="subsolar_longitude" ucd="pos.bodyrc.lon" description="Longitude of Sub-Solar point" unit="deg"/>
		<column name="target_distance_min" ucd="pos.distance;stat.min" description="" unit="km"/>
		<column name="target_distance_max" ucd="pos.distance;stat.max" description="" unit="km"/>
		<column name="sun_distance_min" ucd="pos.distance;stat.min" description="" unit="au"/>
		<column name="sun_distance_max" ucd="pos.distance;stat.max" description="" unit="au"/>

		<!-- APIS Extension -->

		<column name="obsmode" ucd="meta.code;instr.setup" description="Observation mode" type="text"/>
		<column name="detector" ucd="meta.id;instr" description="Detector name" type="text"/>
		<column name="opt_elem" ucd="meta.id;instr" description="Optical element" type="text"/>
		<column name="filter" ucd="meta.id" description="Imaging filter" type="text"/>
		<column name="orientat" ucd="pos.posAngle;instr" description="Position angle of image y axis" unit="deg"/>
		<column name="unit" ucd="meta.unit" description="Physical unit of data" type="text"/>
		<column name="propid" ucd="meta.id" description="Proposal ID" type="text"/>
		<column name="proppi" ucd="meta.pi" description="Last name of Principal Investigator" type="text"/>
		<column name="proptit" ucd="meta.title" description="Title of Proposal" type="text"/>
		<column name="platesc" ucd="" description="Spatial resolution per pixel or platescale" unit="arcsec/pixel"/>
		<column name="campaign" ucd="meta.id" description="Name of Observation Campaign" type="text"/>
		<column name="rap" ucd="pos.angDistance" description="Apparent radius of target" unit="arcsec"/>
		<column name="np_pos" ucd="pos.posAngle" description="North pole position angle with respect to celestial north pole" unit="deg"/>
		<column name="hemis1" ucd="meta.code" description="primary observed hemisphere" type="text"/>
		<column name="hemis2" ucd="meta.code" description="secondary observed hemisphere" type="text"/>  

		<!-- Local columns -->

 		<column name="accref" ucd="meta.file;meta.ref" description="Internal access ref" type="text"/>
		<column name="wavelength" ucd="em.wl" description="Central wavelength" unit="um"/>

	</table>

	<data id="import" updating="True">
		<sources pattern="data/*.fit" recurse="True">
			<ignoreSources fromdb="select accref from irtf_orton.epn_core;"/>
		</sources>

		<fitsProdGrammar/>

		<make table="epn_core">

			<rowmaker idmaps="*">

				<var key="obs_id">@IRAFNAME.replace('.fits','')</var>
				<var key="file_name">os.path.basename(@parser_.sourceToken)</var>
				<var key="file_url">'http://junoirtf.space.swri.edu/irtf_archive/'</var>
				<var key="file_size">os.path.getsize(@parser_.sourceToken)</var>
				<var key="file_mtime">datetime.datetime.fromtimestamp(os.path.getmtime(@parser_.sourceToken))</var>

				<apply procDef="setInstrConfig"/>

				<apply procDef="miriadeEphemph">
					<bind key="target_name">'p:jupiter'</bind>
					<bind key="observer">'@568'</bind>
					<bind key="obs_time">parseISODT('T'.join([@DATE_OBS,@TIME_OBS]))</bind>
				</apply>

				<apply procDef="//epntap2#populate-2_0">
				        <!-- All mandatory parameters must be here -->

				        <bind key="granule_uid">'{}-fits'.format(@obs_id)</bind>
				        <bind key="granule_gid">'FITS calibrated data'</bind>
        				<bind key="obs_id">@obs_id</bind>

					<bind key="target_name">@OBJECT</bind>
					<bind key="target_class">'planet'</bind>
					<bind key="target_region">'Atmosphere'</bind>

				        <bind key="instrument_host_name">@instrument_host_name</bind>
				        <bind key="instrument_name">@instrument_name</bind>

				        <bind key="dataproduct_type">'im'</bind>
					<bind key="processing_level">2</bind>
					<bind key="measurement_type">'phot.count'</bind>

					<bind key="time_min">dateTimeToJdn(parseISODT('T'.join([@DATE_OBS,@TIME_OBS])))</bind>
					<bind key="time_max">dateTimeToJdn(parseISODT('T'.join([@DATE_OBS,@TIME_OBS])))</bind>
					<bind key="time_exp_min">@ITIME</bind>
					<bind key="time_exp_max">@ELAPTIME</bind>
        				<bind key="time_scale">'UTC'</bind>

					<bind key="spectral_range_min">2.99792458E8/@wavelength*1e6</bind>
					<bind key="spectral_range_max">2.99792458E8/@wavelength*1e6</bind>

					<bind key="c1min">(@LCMIII+270) % 360</bind>
					<bind key="c1max">(@LCMIII+90) % 360</bind>
					<bind key="c2min">-90</bind>
					<bind key="c2max">90</bind>

					<bind key="phase_min">@phase</bind>
					<bind key="phase_max">@phase</bind>

  					<bind key="creation_date">@file_mtime</bind>
					<bind key="modification_date">@file_mtime</bind>
					<bind key="release_date">@file_mtime</bind>
					<bind key="service_title">'\schema'</bind>
        			</apply>
				
				<!-- Optional EPNcore parameters -->

				<map key="file_name">@file_name</map>
				<map key="access_url">'{}{}/{}'.format(@file_url,@filter_dir,@file_name)</map>
				<map key="thumbnail_url">'{}{}/{}'.format(@file_url,@filter_dir,@file_name).replace('.fit','.jpg')</map>
      				<map key="access_format">'image/fits'</map>
				<map key="access_estsize">@file_size/1024</map>
				
				<map key="ra">hmsToDeg(@TCS_RA,":")</map>
				<map key="dec">dmsToDeg(@TCS_DEC,":")</map>
				<map key="subobserver_latitude">@subobserver_latitude</map>
				<map key="subsolar_latitude">@subsolar_latitude</map>
				<map key="subobserver_longitude">@subobserver_longitude</map>
				<map key="subsolar_longitude">@subsolar_longitude</map>
				<map key="target_distance_min">@DISTOBJ*149597870.7</map>
				<map key="target_distance_max">@DISTOBJ*149597870.7</map>
				<map key="sun_distance_min">@HDIST</map>
				<map key="sun_distance_max">@HDIST</map>

				<!-- APIS Extension -->

				<map key="obsmode">None</map>
				<map key="detector">@detector</map>
				<map key="opt_elem">@opt_element</map>
				<map key="filter">@GFLT</map>
				<map key="orientat">@POSANGLE</map>
				<map key="unit">'ADU'</map>
				<map key="propid">@PROG_ID</map>
				<map key="proppi">'Glenn Orton'</map>
				<map key="proptit">''</map>
				<map key="platesc">@PLATE_SC</map>
				<map key="campaign">'Juno IRTF Ground support 2016'</map>
				<map key="rap">@rap</map>
				<map key="np_pos">@np_pos</map>
				<map key="hemis1">@hemis1</map>
				<map key="hemis2">@hemis2</map>

				<!-- Local columns -->

				<map key="accref">\inputRelativePath</map>
				<map key="wavelength">@wavelength</map>

			</rowmaker>

		</make>
	</data>

</resource>

