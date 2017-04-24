<resource schema="spectro">
	<meta name="title">PDS spectral library</meta>
	<meta name="description" format="plain">
		This service provides VO access to the PDS spectral library, distributed by the PDS Geosciences node: 
		http://pds-geosciences.wustl.edu/mro/mro-m-crism-4-speclib-v1/mrocr_90xx/<br/>
		Reference:<br/> 
		Murchie et al (2007) Compact Reconnaissance Imaging Spectrometer for Mars (CRISM) on Mars Reconnaissance Orbiter (MRO). JGR Planets, 112:E05S03.
 </meta>
	<meta name="creationDate">2017-04-24T00:00:00</meta>
	<meta name="subject">spectroscopy</meta>
	<meta name="subject">minerals</meta>
	<meta name="creator.name">Stephane Erard</meta>
	<meta name="contact.name">Stephane Erard</meta>
	<meta name="contact.email">vo.paris@obspm.fr</meta>
	<meta name="contact.address">Observatoire de Paris PADC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
	<meta name="instrument">various</meta>
	<meta name="facility">RELAB + various</meta>
	<meta name="source">PDS, DATA_SET_ID=MRO-M-CRISM-4-SPECLIB-V1.0</meta>
	<meta name="contentLevel">3</meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
		<meta name="waveband">Infrared</meta>
		<meta name="waveband">Optical</meta>
		<meta name="Profile">none</meta>
	</meta>

<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true" adql="True">
		<mixin spatial_frame_type="body"
		optional_columns= "access_url access_format access_estsize access_md5 time_scale thumbnail_url species publisher bib_reference file_name" >//epntap2#table-2_0</mixin>

		<column name="producer_name" type="text"
			tablehead="producer_name"
			description="producer_name"
			ucd="meta.note;meta.main"
			verbLevel="2"/>

		<column name="producer_institute" type="text"
			tablehead="producer_institute"
			description="producer_institute"
			ucd="meta.note;meta.main"
			verbLevel="2"/>

		<column name="sample_classification" type="text"
			tablehead="sample_classification"
			description="Sample description"
			ucd="meta.note;phys.composition"
			verbLevel="1"/>

		<column name="grain_size_min" type="double precision"
			tablehead="grain_size_min" unit="um"
			description="grain_size_min"
			ucd="phys.size;stat.min"
			verbLevel="1"/>

		<column name="grain_size_max" type="double precision"
			tablehead="grain_size_max"  unit="um"
			description="grain_size_max"
			ucd="phys.size;stat.max"
			verbLevel="1"/>

		<column name="sample_desc" type="text"
			tablehead="sample_desc"
			description="sample_desc"
			ucd="meta.note"
			verbLevel="3"/>

		<column name="processing_desc" type="text"
			tablehead="processing_desc"
			description="processing_desc"
			ucd="meta.note"
			verbLevel="3"/>


		<column name="geometry_type" type="text"
			tablehead="geometry_type"
			description="geometry_type"
			ucd="meta.note"
			verbLevel="3"/>

		<column name="azimuth_min" type="double precision"
			tablehead="azimuth_min"  unit="deg"
			description="azimuth angle min value"
			ucd="pos.azimuthAng;stat.min"
			verbLevel="1"/>

		<column name="azimuth_max" type="double precision"
			tablehead="azimuth_max"  unit="deg"
			description="azimuth angle max value"
			ucd="pos.azimuthAng;stat.max"
			verbLevel="1"/>

		<column name="measurement_atmosphere" type="text"
			tablehead="measurement_atmosphere"
			description="measurement_atmosphere"
			ucd="meta.note;phys.pressure"
			verbLevel="1"/>

		<column name="pressure" type="double precision"
			tablehead="pressure"  unit="bar"
			description="pressure"
			ucd="phys.pressure"
			verbLevel="1"/>

		<column name="temperature" type="double precision"
			tablehead="temperature"  unit="K"
			description="temperature"
			ucd="phys.temp"
			verbLevel="1"/>

	</table>

<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/spectrodb.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>
		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="granule_uid" source="product_id" />
				<var key="granule_gid">"TBC"</var>
				<var key="obs_id">"TBC"</var>

				<var key="dataproduct_type">"sp"</var>
				<var key="measurement_type">"phys.reff"</var>

				<var key="target_name" source="specimen_name" />
				<var key="target_class">"sample"</var>

				<var key="spectral_range_min" source="minimum_sampling_parameter" />
				<var key="spectral_range_max" source="maximum_sampling_parameter" />
				<var key="spectral_sampling_step_min" source="min_sampling_interval" />
				<var key="spectral_sampling_step_max" source="max_sampling_interval" />
				<var key="spectral_resolution_min" source="measurement_min_resolution" />
				<var key="spectral_resolution_max" source="measurement_max_resolution" />

				<var key="spatial_frame_type">"body"</var>

				<var key="incidence_min" source="incidence_angle" />
				<var key="incidence_max" source="incidence_angle" />
				<var key="emergence_min" source="emission_angle" />
				<var key="emergence_max" source="emission_angle" />
				<var key="phase_min" source="phase_angle" />
				<var key="phase_max" source="phase_angle" />

				<var key="azimuth_min" source="azimuth" />
				<var key="azimuth_max" source="azimuth" />

				<var key="instrument_host_name" source="instrument_host_name" />
				<var key="instrument_name" source="instrument_id" />


				<var key="service_title">"spectro" </var>
				<var key="creation_date" source="product_creation_time" />
				<var key="modification_date" source="product_creation_time" />
				<var key="release_date" source="product_creation_time" />
				<var key="bib_reference" source="reference_key_id"/>
				<var key="access_estsize" source="filesize" />
				<var key="access_md5" source="access_md5" />
				<var key="publisher">"LESIA" </var>

				<var key="producer_name" source="producer_full_name" />
				<var key="producer_institute" source="producer_institution_name" />


				<var key="grain_size_min" source="specimen_min_particle_size" />
				<var key="grain_size_max" source="specimen_max_particle_size" />

				<var key="geometry_type" source="measurement_geometry_type" />

				<var key="sample_desc" source="specimen_desc" />
				<var key="processing_desc" source="note" />
				<var key="measurement_atmosphere" source="measurement_atmosphere_desc" />
				<var key="temperature" source="measurement_temperature" />
				<var key="pressure" source="measurement_pressure" />

				<var key="sample_classification" source="specimen_class_name" />

				<var key="file_name" source="filename" />
				<var key="access_url">"http://pds-geosciences.wustl.edu/mro/mro-m-crism-4-speclib-v1/mrocr_90xx/"+@cfilename</var>


				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>

					<bind key="processing_level">3</bind>

					<bind name="dataproduct_type">@dataproduct_type</bind>
					<bind name="measurement_type">@measurement_type</bind>

					<bind name="target_name">@target_name</bind>
					<bind name="target_class">@target_class</bind>

					<bind name="time_min">@time_min</bind>
					<bind name="time_max">@time_max</bind>

					<bind name="spectral_range_min">@spectral_range_min</bind>
					<bind name="spectral_range_max">@spectral_range_max</bind>
					<bind name="spectral_sampling_step_min">@spectral_sampling_step_min</bind>
					<bind name="spectral_sampling_step_max">@spectral_sampling_step_max</bind>

					<bind name="spectral_resolution_min">@spectral_resolution_min</bind>
					<bind name="spectral_resolution_max">@spectral_resolution_max</bind>


					<bind key="time_min">dateTimeToJdn(parseISODT(@start_time))</bind>
					<bind key="time_max">dateTimeToJdn(parseISODT(@start_time))</bind>


					<bind name="incidence_min">@incidence_min</bind>
					<bind name="incidence_max">@incidence_max</bind>
					<bind name="emergence_min">@emergence_min</bind>
					<bind name="emergence_max">@emergence_max</bind>
					<bind name="phase_min">@phase_min</bind>
					<bind name="phase_max">@phase_max</bind>

					<bind name="instrument_host_name">@instrument_host_name</bind>
					<bind name="instrument_name">@instrument_name</bind>

					<bind name="access_format">"application/x-pds"</bind>





					<bind name="service_title">@service_title</bind>
					<bind name="creation_date">@creation_date</bind>
					<bind name="modification_date">@modification_date</bind>
					<bind name="release_date">@release_date</bind>
					<bind key="time_scale">"UTC"</bind>

				</apply>
			</rowmaker>
		</make>
	</data>
</resource>