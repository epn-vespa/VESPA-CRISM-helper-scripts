<resource schema="sbnaf">
	<meta name="title">Small Bodies Near and Far</meta>
	<meta name="description" format="plain">
blabla </meta>
<meta name="copyright">
    We kindly request the authors of any communications and
    publications using these data to let us know about them,
    include minimal citation to the reference and
    acknowledgements as presented below.
    <br/><br/>
    Acknowledgement:<br/>
    Courtesy:  mention SBNAF programme ++
    <br/><br/>
    Reference:<br/>
    biblio reference
</meta>
	<meta name="creationDate">2019-10-18T00:00:00</meta>
	<meta name="subject">asteroids</meta>
	<meta name="subject">Solar system astronomy</meta>
	<meta name="creator.name">Róbert Szakáts</meta>
	<meta name="contact.email">tobe@completed.fr</meta>
	<meta name="contact.address"></meta>
	<meta name="referenceURL">https://ird.konkoly.hu</meta>
	<meta name="instrument">IRAS</meta>
	<meta name="facility">IRAS</meta>
	<meta name="source">various</meta>
	<meta name="contentLevel">General</meta>
	<meta name="contentLevel">University</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
		<meta name="waveband">Infrared</meta>
	</meta>

<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true" adql="True" primary="granule_uid">
		<mixin spatial_frame_type="celestial"
		optional_columns= "time_scale publisher bib_reference filter alt_target_name" >//epntap2#table-2_0</mixin>


    		<column name="obsmode" type="text" ucd="meta.code;instr.setup" 
    		description="Observing mode"/>

    		<column name="ra" ucd="pos.eq.ra;meta.main"  type="double precision" unit="deg"
    		description="Right ascension"/>
    		<column name="dec"  unit="deg" ucd="pos.eq.dec;meta.main"  type="double precision"
    		description="Declination"/>

            <!--   Uses mJy for consistency with tnosarecool service; can be changed [both unit and coef 1000 below] -->
			<column name="flux"  type="double precision" ucd="phot.flux.density" unit="mJy"
        	description="In-band photometric flux density, photometric corrections applied, no colour correction"/>
    		<column name="flux_err"  type="double precision" ucd="stat.error;phot.flux.density" unit="mJy"
        	description="Uncertainty of the in-band photometric flux density"/>

		    <column name="colour_correction_factor"  type="double precision" ucd="arith.factor"
        	description="Correction applied to obtain monochromatic flux density from in-band flux density"/>

			<column name="corrected_flux"  type="double precision" ucd="phot.flux.density" unit="mJy"
        	description="Monochromatic flux density (colour corrected in-band flux density)"/>
    		<column name="corrected_flux_err"  type="double precision" ucd="stat.error;phot.flux.density" unit="mJy"
        	description="Uncertainty on the monochromatic flux density"/>


    		<column name="abs_magnitude"  type="double precision" ucd="phys.magAbs" 
        	description="Absolute visual magnitude in HG system, from JPL/Horizon"/>
    		<column name="slope_parameter"  type="double precision" ucd="phot.flux;arith.ratio" 
        	description="Slope parameter in HG system, from JPL/Horizon"/>
    		<column name="magnitude"  type="double precision" ucd="phot.mag" 
        	description="Apparent visual magnitude, from JPL/Horizon"/>
		  
    		<column name="semi_major_axis"  type="double precision" ucd="phys.size.smajAxis" unit="au"	
    		description="Semimajor axis of the target orbit"/>
			<column name="inclination"  type="double precision" ucd="src.orbital.inclination" unit="deg"	
			description="Inclination of the target orbit"/>
			<column name="eccentricity"  type="double precision" ucd="src.orbital.eccentricity"	
			description="Eccentricity of the target orbit"/>

			<column name="mean_anomaly" type="double precision" ucd="src.orbital.meanAnomaly" unit="deg"	
			description="Mean anomaly at the epoch" verbLevel="15"/>
			<column name="arg_perihel" type="double precision" ucd="src.orbital.periastron" unit="deg" 
			description="Argument of perihelion" verbLevel="15"/>
			<column name="long_asc" type="double precision" ucd="src.orbital.node" unit="deg"
			description="Longitude of ascending node" verbLevel="15"/>


            <column name="sun_distance_min"  type="double precision" ucd="pos.distance;stat.min" unit="ua"
    	    description="Sun-target min distance"/>
      		<column name="sun_distance_max"  type="double precision" ucd="pos.distance;stat.max" unit="ua"
        	description="Sun-target max distance"/>

           	<column name="target_distance_min" type="double precision" description="Min observer-target distance"
            unit="km" ucd="pos.distance;stat.min" />
            <column name="target_distance_max" type="double precision" description="Max observer-target distance"
            unit="km" ucd="pos.distance;stat.max" />

		    <column name="target_time_min" type="timestamp" ucd="time.start;src"
      		description="Min observing time in target frame"/>
      		<column name="target_time_max" type="timestamp" ucd="time.end;src"
      		description="Max observing time in target frame"/>



			<column name="obsqual" tablehead="obsqual" type="text" ucd="meta.code.qual"   
			description="Contamination and confusion flags and photometric quality flags"/>

			<column name="data_calibration_desc" type="text" ucd="meta.note"
			tablehead="data_calibration_desc"
			description="Information on post-processing"
			verbLevel="3"/>


            <!--   Unused
               <column name="external_link" type="text" description="Link to a web page providing more details on the granule"
               ucd="meta.ref.url" verbLevel="2"/>

               <column name="solar_longitude_min" type="double precision" description="Min Solar longitude Ls (location on orbit/season)"
               unit="deg" ucd="pos.ecliptic.lon;pos.heliocentric;stat.min" verbLevel="2"/>

               <column name="solar_longitude_max" type="double precision" description="Max Solar longitude Ls (location on orbit/season)"
               unit="deg" ucd="pos.ecliptic.lon;pos.heliocentric;stat.max" verbLevel="2"/>
            -->


            <!-- to provide Miriade ephem through datalink -->
			<column name="ds_id" type="text"
			tablehead="Dataset ID"
			description="Identifier for this granule to use when calling datalink services"
			ucd="meta.id"/>

			<column name="datalink_url" type="text"
			tablehead="Datalink"
			description="Datalinks and services for this granule"
			ucd="meta.ref.url;meta.datalink"/>



	</table>

<!-- TABLE COMPLETE -->


	<data id="import">
		<sources pattern="data/*.csv" recurse="True"/>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>


		<make table="epn_core">
			<rowmaker idmaps="*">
				<!-- Map custom and optional parameters -->

				<var name="publisher">"Konkoly Observatory"</var>
				<var key="bib_reference" source ="documents_references" /> 
 				<var key="sun_distance_min" source="heliocentric_distance_r" />
				<var key="sun_distance_max" source="heliocentric_distance_r" />
				<var key="target_distance_min">149597870.7 * float(@obscentric_distance_delta)</var>
				<var key="target_distance_max">149597870.7 * float(@obscentric_distance_delta)</var>

				<var key="ra" source ="Right_Ascension_RA" />
				<var key="dec" source ="Declination_DEC" />

            <!--   Uses mJy for consistency with tnosarecool service; can be changed [coef 1000 here + unit above] -->
				<var key="flux">1000 * float(@calibrated_inband_flux_Jy)</var>
				<var key="flux_err">1000 * float(@inband_flux_error_Jy)</var>
				<var key="colour_correction_factor" source ="colour_correction_factor" />
				<var key="corrected_flux">1000 * float(@colour_corrected_flux_density)</var>
				<var key="corrected_flux_err">1000 * float(@absolute_flux_error)</var>


				<var key="abs_magnitude">@absolute_magnitude_H</var>
				<var key="slope_parameter">@slope_parameter_G</var>
				<var key="magnitude">@apparent_magnitude_V</var>

				<!-- needs double precision, OK with floats -->
				<var key="target_time_min">jdnToDateTime(float(@LTcorrected_epoch)+float(@observation_start_time)-float(@observation_mid_time))</var>
				<var key="target_time_max">jdnToDateTime(float(@LTcorrected_epoch)+float(@observation_end_time)-float(@observation_mid_time))</var>

				<var key="semi_major_axis" source ="orbital_param_A" />
				<var key="inclination" source ="orbital_param_IN" />
				<var key="eccentricity" source ="orbital_param_EC" />
				<var key="mean_anomaly" source ="orbital_param_MA" />
				<var key="arg_perihel" source ="orbital_param_W" />
				<var key="long_asc" source ="orbital_param_OM" />

				<var key="obsmode" source ="obsmode" />
				<var key="filter" source ="band_filter" />

				<var key="obsqual" source ="quality_flags" />
				<var key="data_calibration_desc" source ="comments_remarks" /> 

				<!-- store arguments for datalink -->
				<var key="ds_id">"asteroid/" + @targetname + "/" + str(float(@observation_mid_time))</var>
				<var key="datalink_url">("\getConfig{web}{serverURL}/\rdId/epdl/dlmeta"
					+"?ID="+urllib.quote(@ds_id))</var> 


				<apply procDef="//epntap2#populate-2_0" name="fillepn">
				<!-- Map mandatory parameters only -->

					<!-- this combination is unique -->
					<bind key="granule_uid">@targetname+'/'+@observation_start_time+'/'+@band_filter+'/'+@inband_flux_error_Jy</bind>
					<!-- not unique in the dataset, but this is OK for gid (target+instrument_host) -->
					<bind key="granule_gid">@granule_uid</bind>
					<!-- associates related obs -->
					<bind key="obs_id">@observatory_project+'/'+@observation_start_time+'/'+@band_filter</bind>

					<bind key="target_name">@targetname</bind>
					<bind key="target_class">"asteroid"</bind>
					<bind key="processing_level">"5"</bind>

					<bind key="time_min">@observation_start_time</bind>
					<bind key="time_max">@observation_end_time</bind>
					<bind key="time_scale">"UTC"</bind>

		<!-- can't be computed, min=max nearly always
					<bind key="time_exp_min">@time_exp_min</bind>
					<bind key="time_exp_max">@time_exp_max</bind>
		-->

					<!-- Convert to frequency in Hertz -->
					<bind key="spectral_range_min">2.99792458E14 / float(@reference_wavelengths_micron)</bind>
					<bind key="spectral_range_max">2.99792458E14 / float(@reference_wavelengths_micron)</bind>

		<!-- Unused
			   		<bind key="spectral_resolution_min">round(float(@spectral_range_min) / float(@spectral_resolution_min))</bind>
		   			<bind key="spectral_resolution_max">round(float(@spectral_range_max) / float(@spectral_resolution_max))</bind>

					<bind key="spectral_sampling_step_min">2.99792458E14 * (float(@spectral_range_max) - float(@spectral_range_min)) /float(@vims_bands) / float(@spectral_range_max)**2</bind>
					<bind key="spectral_sampling_step_max">2.99792458E14 * (float(@spectral_range_max) - float(@spectral_range_min)) /float(@vims_bands) / float(@spectral_range_min)**2</bind>
		-->

					<bind key="phase_min">@phase_angle_alpha</bind>
					<bind key="phase_max">@phase_angle_alpha</bind>
		
					<bind key="c1min">@Right_Ascension_RA</bind>
					<bind key="c1max">@Right_Ascension_RA</bind>
					<bind key="c2min">@Declination_DEC</bind>
					<bind key="c2max">@Declination_DEC</bind>

					<bind key="dataproduct_type">"ci"</bind>
					<bind key="measurement_type">"phot.flux.density;em.IR"</bind>

					<bind key="service_title">"sbnaf"</bind>
					<!-- from web site info -->
					<bind key="creation_date">"2019-02-08T00:00:00.00"</bind>
					<bind key="release_date">"2019-03-31T00:00:00.00"</bind>
					<bind key="modification_date">@data_last_modification</bind>

					<bind key="instrument_host_name">@observatory_project+'#'+@observatory_code</bind>
					<bind key="instrument_name">@instrument_detector</bind> 

				</apply>

			</rowmaker> 
		</make>
	</data>

	    <service id="epdl" allowed="dlmeta">
        <datalinkCore>

			<!-- Provide ephem through datalink from Miriade; physical ephem and image may not be available -->

            <metaMaker>
                <code>
                    upstream_service_url="http://vo.imcce.fr/webservices/miriade/ephemph_query.php?-from=vespa&amp;"
                    upstream_service2_url="http://vo.imcce.fr/webservices/miriade/ephemcc_query.php?-from=vespa&amp;"
                    parameters = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "votable",
                    }
                    url = upstream_service_url+urllib.urlencode(parameters)

                    parameters2 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "html",
                    }
                    url2 = upstream_service_url+urllib.urlencode(parameters2)

                    parameters3 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "votable",
                    }
                    url3 = upstream_service2_url+urllib.urlencode(parameters3)

                    parameters4 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "html",
                    }
                    url4 = upstream_service2_url+urllib.urlencode(parameters4)

                    parameters5 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "image",
                        "-view": "wired:png",
                    }
                    url5 = upstream_service_url+urllib.urlencode(parameters5)

                    yield LinkDef(descriptor.pubDID,
                        url2,
                        description="Miriade physical ephemeris, html",
                        semantics="#auxiliary",
                        contentType="text/html")

                    yield LinkDef(descriptor.pubDID,
                        url,
                        description="Miriade physical ephemeris, VOtable",
                        semantics="#auxiliary",
                        contentType="application/x-votable+xml")

                    yield LinkDef(descriptor.pubDID,
                        url4,
                        description="Miriade positional ephemeris, html",
                        semantics="#auxiliary",
                        contentType="text/html")

                    yield LinkDef(descriptor.pubDID,
                        url3,
                        description="Miriade positional ephemeris, VOtable",
                        semantics="#auxiliary",
                        contentType="application/x-votable+xml")

                    yield LinkDef(descriptor.pubDID,
                        url5,
                        description="Miriade physical ephemeris, simulation image",
                        semantics="#auxiliary",
                        contentType="image/png")

                </code>
            </metaMaker>

            <descriptorGenerator>
            <setup>
                <code>
                    class PlanetDescriptor(object):
                        def __init__(self, pubDID):
                            self.pubDID = pubDID
                            self.targetClass, self.targetName, self.epoch = self.pubDID.split("/", 2)
                            self.computeEphemerisId()

                        def computeEphemerisId(self):
                                shortClass = {
                                        'planet': 'p',
                                        'satellite': 's',
                                        'asteroid': 'a',
                                        'dwarf planet': 'dp',
                                        'comet': 'c',
                                }[self.targetClass]
                                self.ephId = "{}:{}".format(
                                        shortClass, self.targetName)
                        description="computed ephemeris of the target",
                </code>
            </setup>
                <code>
                    return PlanetDescriptor(pubDID)
                </code>
            </descriptorGenerator>

            <dataFunction>
				<!--	Not used	-->
                <setup>
                    <par name="upstream_service_url"
                        >"http://vo.imcce.fr/webservices/miriade/ephemph_query.php?-from=vespa&amp;"</par>
                    <code>
            import urllib
            from gavo.svcs import WebRedirect
                    </code>
                </setup>
                <code>
                    parameters3 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "500",
                        "-mime": "html",
                    }
                    raise WebRedirect(upstream_service_url+urllib.urlencode(parameters3))
                </code>
            </dataFunction>
        </datalinkCore>
    </service>


	<regSuite title="SBNAF regression test">
		<regTest title="SBNAF contains credible data">
			<url parSet="TAP" QUERY="select * from sbnaf.epn_core
					WHERE granule_uid='Dione/2454128.75793/S9W/0.064'"
				>/tap/sync</url>
			<code>
				row = self.getFirstVOTableRow()
				self.assertEqual(row["target_name"], "Dione")
				self.assertAlmostEqual(row["c1min"], 216.66192)
				self.assertAlmostEqual(row["time_min"], 2454128.75793)
			</code>
		</regTest>
	</regSuite>
</resource>
