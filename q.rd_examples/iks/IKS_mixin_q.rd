<resource schema="iks">
  <meta name="title">IKS</meta>
  <meta name="description" format="plain">
Measurements of comet Halley in the spectral channel of IKS on board the Vega-1 spacecraft. Data are retrieved from the PDS Small Bodies Node data set (2011 reformatted version) and updated. The data set consists in 101 tables providing the radiance spectrum of comet Halley from various distances, plus two composite spectra. For details and further references, see: Combes M. et al., 1988, The 2.5-12 micron Spectrum of Comet Halley from the IKS-VEGA Experiment, Icarus, 76, 404-436 [1988Icar...76..404C]  </meta>
  <meta name="creationDate">2018-04-30T19:42:00Z</meta>
  <meta name="subject">comet</meta>
  <meta name="subject">spectroscopy</meta>
  <meta name="subject">infrared</meta>
  <meta name="subject">1P Halley</meta>
	<meta name="creator.name">Stephane Erard</meta>
	<meta name="contact.name">Stephane Erard</meta>
	<meta name="contact.email">vo.paris@obspm.fr</meta>
	<meta name="contact.address">Observatoire de Paris PADC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
	<meta name="instrument">IKS</meta>
	<meta name="facility">Vega-1</meta>
  <meta name="source">1988Icar...76..404C</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="utype">ivo://vopdc.obspm/std/EpnCore#schema-2.0</meta>

	<meta name="coverage">
		<meta name="waveband">Infrared</meta>
		<meta name="Profile">none</meta>
	</meta>

<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true" adql="True">
		<mixin spatial_frame_type="body"
		optional_columns= "access_url access_format access_estsize access_md5 alt_target_name time_scale thumbnail_url publisher bib_reference file_name" >//epntap2#table-2_0</mixin>


    	<column name="acquisition_id" type="text" 
			tablehead="Acquisition_id"
      		description="Extra: ID of the data file in the original archive"
      		ucd="meta.id" 
			verbLevel="2"/>

	    <column name="target_distance_min"  type="double precision"
			tablehead="Target_distance_min"  unit="km"
      		description="Extra: Spacecraft-target distance in km"
     	 	ucd="pos.distance;stat.min" 
			verbLevel="2"/>

	    <column name="target_distance_max"  type="double precision"
			tablehead="Target_distance_max"  unit="km"
      		description="Extra: Spacecraft-target distance in km"
     	 	ucd="pos.distance;stat.max" 
			verbLevel="2"/>

	    <column name="sun_distance_min"  type="double precision"
			tablehead="Sun_distance_min"  unit="au"
      		description="Extra: min target heliocentric distance in au"
     	 	ucd="pos.distance;stat.min" 
			verbLevel="2"/>

	    <column name="sun_distance_max"  type="double precision"
			tablehead="Sun_distance_max"  unit="au"
      		description="Extra: max target heliocentric distance in au"
     	 	ucd="pos.distance;stat.max" 
			verbLevel="2"/>

	    <column name="earth_distance_min"  type="double precision"
			tablehead="Earth_distance_min"  unit="au"
      		description="Extra: min target Earth distance in au"
     	 	ucd="pos.distance;stat.min" 
			verbLevel="2"/>

	    <column name="earth_distance_max"  type="double precision"
			tablehead="Earth_distance_max"  unit="au"
      		description="Extra: max target Earth distance in au"
     	 	ucd="pos.distance;stat.max" 
			verbLevel="2"/>

	</table>

<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/indexiks.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>

			<rowfilter name="addExtraProducts">
				<!-- Duplicate input granules to provide 2 alternative versions -->
				<code>
						# VOtable version 
						@granule_uid = @rootname+"C"
						@granule_gid = "corrected"
						@access_format = "application/x-votable+xml"
						@access_estsize = "19"
						@access_url = @a_url
						@file_name = @rootname+".xml"
						@thumbnail_url = @a_url+".png"
						@creation_date="2013-11-17T10:41:00.00"
						@modification_date="2016-04-28T15:43:00.00"
						@release_date="2013-11-17T10:41:00.00"
						yield row.copy()

						# native version
						@granule_uid = @rootname+"A"
						@granule_gid = "archived"
						@access_format = "text/plain"
						@access_estsize = "4"
						@access_url = @o_url
						@file_name = @rootname+".tab"
						@thumbnail_url = ""
						@creation_date="1993-11-10T07:54:00.00"
						@modification_date="1993-11-10T07:54:00.00"
						@release_date="1993-11-10T07:54:00.00"
						yield row
				</code>
			</rowfilter>
		</csvGrammar>

		<make table="epn_core">
			<rowmaker idmaps="*">

				<var key="acquisition_id" source="observation_id" />
				<var key="target_distance_min" source="distance" />
				<var key="target_distance_max" source="distance" />
				<var key="sun_distance_min" source="sdistance" />
				<var key="sun_distance_max" source="sdistance" />
				<var key="earth_distance_min" source="edistance" />
				<var key="earth_distance_max" source="edistance" />
				<var key="alt_target_name" source="target" />
				<var key="bib_reference" source="ref" /> 
				<var key="publisher">"LESIA" </var>  


		<!--		<var key="access_format" source="access_format" /> *** Something weird with this one, TBC -->

				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind key="granule_gid">@granule_gid</bind>
					<bind key="granule_uid">@granule_uid</bind>
					<bind key="obs_id">@rootname</bind>
					<bind key="target_name">"1P"</bind>
					<bind key="target_class">"comet"</bind>
					<bind key="dataproduct_type">"sp"</bind>
					<bind key="processing_level">3</bind>
					<bind key="measurement_type">"phot.radiance;em.wl"</bind>
					<bind key="instrument_host_name">@inst_host_name</bind>
					<bind key="instrument_name">@inst_name</bind>
					<bind key="service_title">"iks"</bind>

					<bind key="spectral_resolution_min">2.99792458E14 *(float(@sp_res_max)+float(@sp_res_min))/ 2 / float(@sp_max)**2</bind>
					<bind key="spectral_resolution_max">2.99792458E14 *(float(@sp_res_max)+float(@sp_res_min))/ 2 / float(@sp_min)**2</bind>
					<bind key="spectral_sampling_step_min">2.99792458E14 *(float(@sp_step_min)+float(@sp_step_max))/ 2 / float(@sp_max)**2</bind>
					<bind key="spectral_sampling_step_max">2.99792458E14 *(float(@sp_step_min)+float(@sp_step_max))/ 2 / float(@sp_min)**2</bind>
					<bind key="spectral_range_min">2.99792458E14 /float(@sp_max)</bind>
					<bind key="spectral_range_max">2.99792458E14 /float(@sp_min)</bind>

					<bind key="phase_min">@phase_ang</bind>
					<bind key="phase_max">@phase_ang</bind>
								
					<bind key="time_exp_min">@exp_time</bind>
					<bind key="time_exp_max">@exp_time</bind>
					<bind key="time_min">dateTimeToJdn(parseISODT(@time_obs))</bind>
					<bind key="time_max">dateTimeToJdn(parseISODT(@time_obs))</bind>
					<bind key="creation_date">@creation_date</bind>
					<bind key="modification_date">@modification_date</bind>
					<bind key="release_date">@release_date</bind>

					<bind key="time_scale">"UTC"</bind>   <!-- *** Something weird with these, TBC in next mixin -->
		<!--			<bind key="access_format">@access_format</bind> -->

				</apply>
			</rowmaker>
		</make>
	</data>
</resource>
