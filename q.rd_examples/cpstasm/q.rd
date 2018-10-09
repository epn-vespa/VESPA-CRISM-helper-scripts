<resource schema="cpstasm">
	<meta name="creationDate">2018-04-19T07:33:10Z</meta>

	<meta name="title">CLUSTER STAFF-SA Spectral Matrix Data (CPSTASM)</meta>
	<meta name="description" format="rst">
		This service publishes spectral matrix data from the Earth magnetosphere
		obtained by the CLUSTER satellites.  The data contains the upper
		triangle for the 5x5 correlation matrix of the three magnetic and 
		two electric components of the electromagnetic field in 27 frequency
		bands in the SR2 reference frame.  For more information, refer
		to http://caa.estec.ea.int/documents/UG/CAA_EST_UG_STA_v35.pdf.
	</meta>
	<meta name="subject">Magnetosphere</meta>
	<meta name="subject">Earth</meta>
	<meta name="subject">planet</meta>

	<meta name="creator">Pisa, D.</meta>
	<meta name="instrument">STAFF-SA</meta>
	<meta name="facility">CLUSTER</meta>

	<meta name="source">2003RaSc...38.1010S</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

	<!-- Waveband is of Radio, Millimeter, 
			Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated -->
	<meta name="coverage.waveband">Radio</meta>

	<table id="epn_core" onDisk="True" adql="True">
		<publish sets="local,ivo_managed"/>
		 <mixin
			spatial_frame_type="cartesian"
			optional_columns="access_url access_format access_estsize 
				file_name target_region
				bib_reference publisher 
				time_scale"
			>//epntap2#table-2_0</mixin>
		<mixin>//epntap2#localfile-2_0</mixin>
	</table>

	<data id="import">
		<sources pattern="data/20??/C?/*.cdf"/>

		<cdfHeaderGrammar autoAtomize="True">
			<rowfilter procDef="//products#define">
				<bind name="table">'\schema.epn_core'</bind>
			</rowfilter>
		</cdfHeaderGrammar>

		<make table="epn_core">
			<rowmaker idmaps="*">
				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind key="c1min">None</bind>
					<bind key="c1max">None</bind>
					<bind key="c2min">None</bind>
					<bind key="c2max">None</bind>
					<bind key="c3min">None</bind>
					<bind key="c3max">None</bind>

					<bind key="creation_date">datetime.datetime.utcfromtimestamp(
							os.path.getctime(@parser_.sourceToken))</bind>
					<bind key="dataproduct_type">'ds'</bind>
					<bind key="granule_gid">'original_data'</bind>
					<bind key="granule_uid">\srcstem</bind>
					<bind key="instrument_host_name">'CLUSTER'</bind>
					<bind key="instrument_name">'STAFF-SA'</bind>
					<bind key="measurement_type">'phys.polarization.coherency;em.radio'</bind>
					<bind key="modification_date">datetime.datetime.utcfromtimestamp(
						os.path.getmtime(@parser_.sourceToken))</bind>
					<bind key="processing_level">4</bind>
					<bind key="obs_id">\srcstem</bind>
					<bind key="service_title">'CP_STA_SM'</bind>
					<bind key="spectral_range_max">8</bind>
					<bind key="spectral_range_min">4000</bind>
					<bind key="spectral_resolution_max">740</bind>
					<bind key="spectral_resolution_min">2.2</bind>
					<bind key="spectral_sampling_step_max">740</bind>
					<bind key="spectral_sampling_step_min">2.2</bind>
					<bind key="target_class">'planet'</bind>
					<bind key="target_name">'Earth'</bind>
					<bind key="target_region">'Magnetosphere'</bind>
					<bind key="time_exp_max">@MIN_TIME_RESOLUTION</bind>
					<bind key="time_exp_min">@MAX_TIME_RESOLUTION</bind>
					<bind key="time_max">dateTimeToJdn(@FILE_TIME_SPAN[1])</bind>
					<bind key="time_min">dateTimeToJdn(@FILE_TIME_SPAN[0])</bind>
					<bind key="time_sampling_step_max">@MIN_TIME_RESOLUTION</bind>
					<bind key="time_sampling_step_min">@MAX_TIME_RESOLUTION</bind>
					<bind key="time_scale">'UTC'</bind>
				</apply>

				<apply procDef="//epntap2#populate-localfile-2_0"/>
			</rowmaker>
		</make>
	</data>				



	<regSuite title="STAFF-SA2 regression">
		<regTest title="STAFF-SA2 EPN-TAP serves some data">
			<url parSet="TAP" QUERY="SELECT * from cpstasm.epn_core
					WHERE granule_uid='C1_CP_STA_SM__20050101_000000_20050102_000000_V150121'"
				>/tap/sync</url>
			<code>
				recs = self.getVOTableRows()
				self.assertEqual(len(recs), 1)
				self.assertTrue(
					isinstance(recs[0]["modification_date"],
					datetime.datetime), "Modification date no datetime?")
				self.assertAlmostEqual(
					recs[0]["time_min"],
					2453371.5)
			</code>
		</regTest>
	</regSuite>
</resource>
