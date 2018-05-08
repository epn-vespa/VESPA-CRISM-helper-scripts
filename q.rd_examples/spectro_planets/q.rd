<resource schema="spectro_planets">
	<meta name="title">Spectra of planets</meta>
	<meta name="description" format="plain">
This service provides a compilation of global spectra of planets and satellites in the visible and NIR range, for quick reference purpose. It is made from various libraries, including the Tohoku-Hiroshima-Nagoya Planet Spectra Library (Lundock et al 2009) and spectra from a USGS web site (R. Clark). Reformatted VOtable versions are provided together with links to the original data. </meta>
	<meta name="creationDate">2017-06-23T00:00:00</meta>
	<meta name="subject">spectroscopy</meta>
	<meta name="subject">planets</meta>
	<meta name="creator.name">Stephane Erard</meta>
	<meta name="contact.name">Stephane Erard</meta>
	<meta name="contact.email">vo.paris@obspm.fr</meta>
	<meta name="contact.address">Observatoire de Paris PADC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
	<meta name="instrument">various</meta>
	<meta name="facility">various</meta>
	<meta name="source">various</meta>
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
		optional_columns= "access_url access_format access_estsize access_md5 time_scale thumbnail_url publisher bib_reference file_name" >//epntap2#table-2_0</mixin>


		<column name="magnitude" type="double precision"
			tablehead="magnitude"
			description="V magnitude at time of observation"
			ucd="phot.mag"
			verbLevel="2"/>

		<column name="feature_name" type="text"
			tablehead="feature_name"
			description="feature_name"
			ucd="meta.id"
			verbLevel="2"/>

		<column name="observer_name" type="text"
			tablehead="observer_name"
			description="observer_name"
			ucd="meta.note;meta.main"
			verbLevel="2"/>

		<column name="observer_institute" type="text"
			tablehead="observer_institute"
			description="observer_institute"
			ucd="meta.note;meta.main"
			verbLevel="2"/>

		<column name="data_calibration_desc" type="text"
			tablehead="data_calibration_desc"
			description="data_calibration_desc"
			ucd="meta.note"
			verbLevel="3"/>

	</table>

<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/spectroplanet.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>

			<rowfilter name="addExtraProducts">
				<!-- Duplicate input granules to provide 2 alternative versions -->
					
				<code>
					if "THN-PSL" in @granule_gid:
						# VOtable version of THN
						@dataset_id = @file_name.replace(".txt", "")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_estsize = "110"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name.replace('.txt', '.vot'))
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@file_name.replace('.txt', '.png'))
						@file_name = @dataset_id+".vot"
						@measurement_type="phot.radiance;em.wvl" 
						@modification_date="2017-08-19T20:00:00.00"
						yield row.copy()

						# native version
						@access_url = ("http://cdsarc.u-strasbg.fr/ftp/pub/A+A/507/1649/sp/"
							+@file_name.replace('.vot','.txt.gz'))
						@access_format = "text/plain-gzip"
						@access_estsize = "20"
						@granule_uid = @dataset_id+"_txt"
						@file_name = @dataset_id+".txt.gz"
						@modification_date=@release_date
						yield row
					
					elif "IRTF" in @granule_gid:
						# VOtable version of IRTF
						@dataset_id = @file_name.replace(".fits", "")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_estsize = "800"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name.replace('.fits', '.vot'))
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@file_name.replace('.fits', '.png'))
						@file_name = @dataset_id+".vot"
						@measurement_type="phot.flux.density;em.wl" 
						@modification_date="2017-08-19T20:00:00.00"
						yield row.copy()

						# native version
						@file_name = @dataset_id+".fits"
						@access_url = ("http://irtfweb.ifa.hawaii.edu/~spex/IRTF_Spectral_Library/Data/"
							+@file_name)
						@access_format = "application/fits"
						@access_estsize = "100"
						@granule_uid = @dataset_id+"_fits"
						@file_name = @dataset_id+".fits"
						@modification_date=@release_date
						yield row

					elif "ESO-JSNU" in @granule_gid: 
						# VOtable version of Karkoschka1998
						@dataset_id = @file_name.replace(".vot", "")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_estsize = "300"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name)
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@file_name.replace('.vot', '.png'))
						@measurement_type="phys.reflectance;em.wl" 
						@modification_date="2017-08-19T20:00:00.00"
						yield row.copy()

						# native version (grouped in PDS tables, link is to label)
						@file_name = "1995low.lbl"
						if "_hi" in @dataset_id: 
							@file_name = "1995high.lbl"

						@access_url = ("http://atmos.nmsu.edu/pdsd/archive/data"
							"/eso-jsnu-spectrophotometer-4-v20/gbat_0001/data/"+@file_name)
						@access_format = "application/x-pds3-detached"
						@access_estsize = "150"
						@granule_uid = @dataset_id+"_pds"
						@modification_date=@release_date
						yield row


					elif "LESIA" in @granule_gid: 
						# only a VOtable version for local spectra
						@dataset_id = @file_name.replace(".vot", "")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_estsize = "150"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name)
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@file_name.replace('.vot', '.png'))
						@measurement_type="phys.reflectance;em.wl" 
						@modification_date="2017-08-25T20:00:00.00"
						yield row

					elif "solar" in @granule_gid: 
						# Original versions solar spectra
						@dataset_id = @file_name.replace(".fits", "")
						@dataset_id = @file_name.replace(".dat", "")
						#@granule_uid = @dataset_id+"_ori"
						if "sun_reference_stis_001.fits" in @file_name: 
							@file_name2 = "colina"
							@access_format = "application/fits"
							@measurement_type="phot.flux.density;em.wl" 
							@access_url = ("ftp://ftp.stsci.edu/cdbs/calspec/"+@file_name)
							@access_estsize = "50"
							@access_estsize2 = "130"
						elif "solspec.dat" in @file_name: 
							@file_name2 = "thuillier"
							@access_format = "text/plain"
							@measurement_type="phot.flux.density;em.wl" 
							@access_url = ("...")
							@access_estsize = "300"
							@access_estsize2 = "730"
						elif "spectrum.dat.gz" in @file_name: 
							@file_name2 = "meftah"
							@access_format = "text/plain.gzip"
							@measurement_type="phot.flux.density;em.wl" 
							@access_url = ("http://cdsarc.u-strasbg.fr/vizier/ftp/cats/J/A+A/611/A1/"+@file_name)
							@access_estsize = "580"
							@access_estsize2 = "6000"
						else: 
							#"irradiancebins.dat" in @file_name: 
							@file_name2 = "kurucz97"
							@access_format = "text/plain"
							@measurement_type="phot.flux.density;em.wavenumber" 
							@access_url = ("http://kurucz.harvard.edu/sun/IRRADIANCE/"+@file_name)
							@access_estsize = "500"
							@access_estsize2 = "4500"

						@dataset_id = @file_name2
						@granule_uid = @dataset_id+"_ori"
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@file_name2+".png")
						@modification_date=@release_date
						yield row.copy()

						# VOtable versions solar spectra
						@file_name = @file_name2+".vot"
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name)
						@access_estsize = @access_estsize2
						@measurement_type="phot.flux.density;em.wl" 
						@modification_date="2017-08-25T20:00:00.00"
						yield row

					elif "atmosphere" in @granule_gid: 
						# transmission spectrum
						#@file_name2 = @file_name
						#@access_format = ""
						#@measurement_type="obs.atmos.extinction;em.wl" 
						#@access_url = ("http://cds-espri.ipsl.fr/tapas/")
						#@access_estsize = ""
						#yield row.copy()

						# VOtable version, transmission
						@dataset_id = @file_name.replace(".vo.gz", "")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml-gzip"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@file_name)
						@access_estsize = "180"
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo/planeto/spectro_planets"
							"/thumbnails/"+@dataset_id+".png")
						@measurement_type="obs.atmos.extinction;em.wl" 
						@modification_date="2017-08-25T18:18:00.00"
						yield row

					else:
						# VOtable version of USGS
						@file_name2 = @file_name
						@dataset_id = @file_name.replace(".asc", "")
						@dataset_id = @dataset_id.replace(".", "_")
						@granule_uid = @dataset_id+"_vot"
						@access_format = "application/x-votable+xml"
						@access_estsize = "30"
						@access_url = ("http://voparis-srv.obspm.fr/vo/"
							"planeto/spectro_planets/spectra/"+@dataset_id+".vot")
						@thumbnail_url = ("http://voparis-srv.obspm.fr/vo"
							"/planeto/spectro_planets/thumbnails/"+@dataset_id+".png")
						@file_name = @dataset_id+".vot"
						@measurement_type="phys.reflectance;em.wl" 
						@modification_date="2017-08-19T20:00:00.00"
						yield row.copy()

						# native version
						@file_name = @file_name2.replace(".asc", "")
						@access_url = ("https://speclab.cr.usgs.gov/planetary.spectra/"
							+@file_name)
						@access_format = "text/plain"
						@access_estsize = "5"
						@granule_uid = @dataset_id+"_txt"
						@modification_date=@release_date
						yield row
				</code>
			</rowfilter>

		</csvGrammar>
		<make table="epn_core">
			<rowmaker idmaps="*">

					<var key="spectral_range_min" source="sp_min" /> 
					<var key="spectral_range_max" source="sp_max" /> 
					<var key="spectral_resolution_min" source="sp_res_min" /> 
					<var key="spectral_resolution_max" source="sp_res_max" /> 

					<var key="bib_reference" source="bib_code"/>
					<var key="publisher">"LESIA" </var>
					<var key="access_format" source="access_format" /> 


				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind key="granule_gid">@granule_gid</bind>
					<bind key="granule_uid">@granule_uid</bind>
					<bind key="obs_id">@dataset_id</bind>
					<bind key="target_name">@target_name</bind>
					<bind key="target_class">@target_class</bind>

					<bind key="processing_level">3</bind>
					<bind key="dataproduct_type">"sp"</bind>
					<bind key="measurement_type">@measurement_type</bind>


					<bind key="spectral_resolution_min">2.99792458E14 /@spectral_resolution_max / @spectral_range_max</bind>
					<bind key="spectral_resolution_max">2.99792458E14 /@spectral_resolution_min / @spectral_range_min</bind>
					<bind key="spectral_range_min">2.99792458E14 /@spectral_range_max</bind>
					<bind key="spectral_range_max">2.99792458E14 /@spectral_range_min</bind>


					<bind key="phase_min">@phase_min</bind>
					<bind key="phase_max">@phase_max</bind>

					<bind key="time_min">dateTimeToJdn(parseISODT(@start_time))</bind>
					<bind key="time_max">dateTimeToJdn(parseISODT(@start_time))</bind>
					<bind key="time_scale">"UTC"</bind>

			<!--		  <bind key="access_format">@access_format</bind>  -->
					<bind key="service_title">@service_title</bind>
					<bind key="instrument_host_name">@instrument_host_name</bind>
					<bind key="instrument_name">@instrument_name</bind>
					<bind key="creation_date">@creation_date</bind>
					<bind key="modification_date">@modification_date</bind>
					<bind key="release_date">@release_date</bind>


				</apply>

			</rowmaker>
		</make>
	</data>
</resource>
