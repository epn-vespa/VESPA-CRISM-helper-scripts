<resource schema="hst_planeto">
  <meta name="title">HST observations of planets and satellites</meta>
  <meta name="description" format="plain">
	HST observations of planets, dwarf planets, and satellites, extracted from the CADC database catalogue (regularly updated). Data are linked to the CADC repository, with file names common to all HST archives. Both calibrated and derived products are included. The main target is identified. Physical ephemeris and thumbnails  are provided when available. Files and previews are not accessible during the proprietary period.
  </meta>
  <meta name="creationDate">2018-06-07T09:42:00Z</meta>
  <meta name="subject">solar system</meta>
  <meta name="subject">planets</meta>
  <meta name="subject">satellites</meta>
  <meta name="subject">Pluto</meta>
  <meta name="subject">Ceres</meta>
  <meta name="subject">Eris</meta>
  <meta name="subject">Makemake</meta>
  <meta name="subject">Haumea</meta>
  <meta name="subject">Neptune</meta>
  <meta name="subject">Uranus</meta>
  <meta name="subject">Saturn</meta>
  <meta name="subject">Jupiter</meta>
  <meta name="subject">Mars</meta>
  <meta name="subject">Moon</meta>
  <meta name="subject">Venus</meta>
  <meta name="coverage.waveband">Optical</meta>
  <meta name="coverage.waveband">Infrared</meta>
  <meta name="coverage.waveband">UV</meta>


  <meta name="copyright">LESIA-Obs Paris, CADC, STScI, ESA</meta>
  <meta name="creator.name">Stephane Erard</meta>
  <meta name="publisher">Paris Astronomical Data Centre - LESIA</meta>
  <meta name="contact.name">Stephane Erard</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="contact.address">Observatoire de Paris VOPDC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>



<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true" adql="True">
		<mixin spatial_frame_type="celestial"
		optional_columns= "access_url access_format access_estsize access_md5 thumbnail_url time_scale  publisher file_name" >//epntap2#table-2_0</mixin>

		<column name="detector_name"  type="text"  required="True"
			ucd="meta.id;instr.det" 
			description="Detector name"
			verbLevel="2"/>

		<column name="obs_mode"  type="text"  required="True"
			ucd="meta.code;instr.setup" 
			description="Observing mode"
			verbLevel="2"/>
 
		<column name="filter" type="text"
			tablehead="Filter"
			description="filter used"
			ucd="meta.id;instr.filter"
			verbLevel="2"/>

		<column name="waveband" type="text"
			tablehead="Waveband"
			description="Electro-magnetic band"
			ucd="instr.bandpass"
			verbLevel="2"/>

		<column name="proposal_target_name" type="text"
			tablehead="Proposal_target_name"
			description="target name as in proposal title"
			ucd="meta.note;meta.main"
			verbLevel="2"/>

		<column name="target_description" type="text"
			tablehead="Target_description"
			description="Original target kuywords"
			ucd="meta.id"
			verbLevel="2"/>

		<column name="proposal_id" type="text"
			tablehead="Proposal_id"
			description="Proposal ID"
			ucd="meta.id;meta.code"
			verbLevel="2"/>

		<column name="proposal_title"  type="text"  required="True"
			tablehead="Proposal_title"
			ucd="meta.title" 
			description="Proposal title"
			verbLevel="2"/>

		<column name="proposal_pi" type="text"
			tablehead="Proposal_PI"
			description="Proposal Principal Investigator"
			ucd="meta.bib.author"
			verbLevel="2"/>

		<column name="ds_id" type="text"
			tablehead="Dataset ID"
			description="Identifier for this granule to use when calling 
				datalink services"
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

			<rowfilter name="addExtraProducts">
					
				<code>
					# default type, TBC
					@dataproduct_type= "im"	
					if "image" in @Data_Type:
						@dataproduct_type= "im"
					elif "IMAGING" in @Obs_Type and ("STIS" in @Instrument or "COS" in @Instrument):
					# those are ~always uncorrectly marked as spectrum in Data_Type
						@dataproduct_type= "im"
					elif "spectrum" in @Data_Type:
						@dataproduct_type= "sp"

					# spectral_range left empty when not provided
					if @Min_Wavelength != "0.0" and @Min_Wavelength is not "":
						@spectral_range_max = 2.99792458E14 /float(@Min_Wavelength) / 1.E6
					if @Max_Wavelength != "0.0" and @Max_Wavelength is not "":
						@spectral_range_min = 2.99792458E14 /float(@Max_Wavelength) / 1.E6

					# To be refined carefuly
					@publisher=@Prov_Producer + " / CADC"

					@instrument = @Instrument.split("/", 1)[0]
					@obs_mode =  ((@Instrument_Keywords.partition('OBSMODE')[2]).split('|',1)[0])[1:]
					@detector_name = ((@Instrument_Keywords.partition('DETECTOR')[2]).split('|',1)[0])[1:]
					
					if  "2" in @Cal_Lev:
						# CALIBRATED 
						# Checked .gz for HST cal files. All instru have non-gz files of these types
						if "WFPC2" in @Instrument:
							@file_name = @Obs_ID+"_c0f.fits"
							@measurement_type="obs.image"
						elif "WFPC" in @Instrument:
							@file_name = @Obs_ID+"_c0f.fits"
							@measurement_type="obs.image"
						elif  "HRS" in @Instrument:
						# should use a datalink to associate c0f.fits (wvl) and c2f (errors)
							@file_name = @Obs_ID+"_c1f.fits"
							@measurement_type="phot.flux.density;em.wl"
						elif  "STIS" in @Instrument:
						# must separate images and spectra using @dataproduct_type ?
							@file_name = @Obs_ID+"_flt.fits"
							@measurement_type="phot.flux.density;em.wl"
							if "IMAGING" in @Obs_Type:
								@measurement_type="obs.image"
						elif  "ACS" in @Instrument:
							@file_name = @Obs_ID+"_flt.fits"
							@measurement_type="obs.image"
						elif  "WFC" in @Instrument:
							@file_name = @Obs_ID+"_flt.fits"
							@measurement_type="obs.image"
						elif  "COS" in @Instrument:
							@file_name = @Obs_ID+"_flt.fits"
							@measurement_type="phot.flux.density;em.wl"
							if "IMAGING" in @Obs_Type:
								@measurement_type="obs.image"
						elif  "FOC" in @Instrument:
							@file_name = @Obs_ID+"_c1t.fits"
							@measurement_type="obs.image"
						elif  "NICMOS" in @Instrument:
						# 	Mars _mos images not present? _asn.fits neither; _ima are low quality
						#  _cal may be better in fact 
							@file_name = @Obs_ID+"_ima.fits"
							@measurement_type="obs.image"
						elif  "FOS" in @Instrument:
						# should use a datalink to associate c0f.fits (wvl) and c2f (errors)
							@file_name = @Obs_ID+"_c1f.fits"
							@measurement_type="phot.flux.density;em.wl"
						elif  "HSP" in @Instrument:
						# Short lived photometer, data are not available (?)
							@file_name = @Obs_ID+"_c1f.fits"
	
						@access_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data"
							"/pub/MAST/HST/product/"+@file_name)
						@granule_gid = "calibrated"
						# A jpg version is always there apparently
						@thumbnail_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data"
								"/pub/HSTCA/"+@Obs_ID+"_prev.jpg")
						# much better versions for this camera, always there
						if  "WFPC2" in @Instrument:
							@thumbnail_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data/pub/"
								"MAST/HST/product/"+@Obs_ID+"_c0f_thumb.jpg")

					else:
						# PRODUCTS
						@suff= ".jpg"
						if "WFPC2" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_drz.fits")
							@measurement_type="obs.image"
						elif "WFPC" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_c0f.fits")
							@measurement_type="obs.image"
						elif  "HRS" in @Instrument:
						# should use a datalink to associate c0f.fits (wvl) and c2f (errors)
							@file_name = @Product_ID.replace("-PRODUCT", "_c1f.fits")
							@measurement_type="phot.flux.density;em.wl"
						elif  "MAMA" in @Instrument:
						# STIS/FUV and NUV ; seems OK, TBC
						# must separate images and spectra using @dataproduct_type ?
							@file_name = @Product_ID.replace("-PRODUCT", "_x2d.fits")
							@measurement_type="phot.flux.density;em.wl"
							if "IMAGING" in @Obs_Type:
								@measurement_type="obs.image"
						elif  "STIS/CCD" in @Instrument:
						# product suffix depends on summing mode... 
							@file_name = @Product_ID.replace("-PRODUCT", "_x2d.fits")
							#@file_name = @Product_ID.replace("-PRODUCT", "_sx2.fits")
							@measurement_type="phot.flux.density;em.wl"
						elif  "ACS" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_drz.fits")
							@measurement_type="obs.image"
							@suff= "_thumb.jpg"
						elif  "WFC" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_drz.fits")
							@measurement_type="obs.image"
							@suff= ".jpg"
						elif  "COS" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_flt.fits")
							@measurement_type="phot.flux.density;em.wl"
							@suff= "_prev.jpg"
							if "IMAGING" in @Obs_Type:
								@measurement_type="obs.image"
						elif  "FOC" in @Instrument:
							@file_name = @Product_ID.replace("-PRODUCT", "_c1t.fits")
							@measurement_type="obs.image"
						elif  "NICMOS" in @Instrument:
						# 	Mars _mos images not present? _asn.fits neither; _ima are low quality
							@file_name = @Product_ID.replace("-PRODUCT", "_mos.fits")
							@measurement_type="obs.image"
							@suff= "_prev.jpg"
						elif  "FOS" in @Instrument:
						# should use a datalink to associate c0f.fits (wvl) and c2f (errors)
							@file_name = @Product_ID.replace("-PRODUCT", "_c1f.fits")
							@measurement_type="phot.flux.density;em.wl"
						elif  "HSP" in @Instrument:
						# Short lived photometer, data are not available (?)
							@file_name = @Product_ID.replace("-PRODUCT", "_c1f.fits")
	
						@access_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data"
							"/pub/MAST/HST/product/"+@file_name)
						@granule_gid = "product"
						if  "STIS" in @Instrument or "NICMOS" in @Instrument:
							@thumbnail_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data"
								"/pub/HSTCA/"+@Obs_ID+"_prev.jpg")
						elif  "COS" in @Instrument:
							@thumbnail_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/"
								"AdvancedSearch/preview/HSTCA/"+@Obs_ID+"_prev.jpg")
						else:
						# not corresponding to PRODUCT...
							@thumbnail_url = ("http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/data"
								"/pub/MAST/HST/product/"+@file_name.replace(".fits","")+@suff )


					# force target_name to std values, and save original elsewhere in proposal_target_name for ref
					# @target_name is the EPN-TAP param, @Target_name is from the csv (OK…)
					@Target_Keywords = @Target_Keywords.replace("BROAD_CATEGORY=SOLAR SYSTEM|TARGET_DESCRIP=","")
					@target_name = ""
					# process MOON separately to allow reaffectation (can be Moon of a planet...)
					if "MOON" in @Target_Name or "COPERNICUS" in @Target_Name or "CABEUS" in @Target_Name or "8539" in @Proposal_ID or "10719" in @Proposal_ID or "LUNAR" in @Target_Name: 
						@target_name = "Moon"
						@target_class = "satellite"

					if "MARS" in @Target_Name: 
						@target_name = "Mars"
						@target_class = "planet"
					elif "VENUS" in @Target_Name: 
						@target_name = "Venus"
						@target_class = "planet"
					elif "JUPITER" in @Target_Name or "JUP-" in @Target_Name:
						@target_name = "Jupiter"
						@target_class = "planet"
					elif "PLUTO" in @Target_Name or "PLCH" in @Target_Name or "PL-CH" in @Target_Name: 
						@target_name = "Pluto"
						@target_class = "dwarf planet"
					elif "SATURN" in @Target_Name: 
						@target_name = "Saturn"
						@target_class = "planet"
					elif "NEPTUNE" in @Target_Name: 
						@target_name = "Neptune"
						@target_class = "planet"
					elif "URANUS" in @Target_Name: 
						@target_name = "Uranus"
						@target_class = "planet"
					elif "PHOBOS" in @Target_Name: 
						@target_name = "Phobos"
						@target_class = "satellite"
					elif "DEIMOS" in @Target_Name: 
						@target_name = "Deimos"
						@target_class = "satellite"
					elif "GAN-" in @Target_Name  or "GANY-" in @Target_Name or "GANYMEDE" in @Target_Name: 
						@target_name = "Ganymede"
						@target_class = "satellite"
					elif "EUROPA" in @Target_Name: 
						@target_name = "Europa"
						@target_class = "satellite"
					elif "CALLISTO" in @Target_Name: 
						@target_name = "Callisto"
						@target_class = "satellite"
					elif "IO-" in @Target_Name or "IO160" in @Target_Name or @Target_Name=="IO":  
						@target_name = "Io"
						@target_class = "satellite"
					elif "TITAN" in @Target_Name: 
						@target_name = "Titan"
						@target_class = "satellite"
					elif "IAPETUS" in @Target_Name: 
						@target_name = "Iapetus"
						@target_class = "satellite"
					elif "DIONE" in @Target_Name: 
						@target_name = "Dione"
						@target_class = "satellite"
					elif "ENCELADUS" in @Target_Name: 
						@target_name = "Enceladus"
						@target_class = "satellite"
					elif "MIMAS" in @Target_Name: 
						@target_name = "Mimas"
						@target_class = "satellite"
					elif "TRITON" in @Target_Name: 
						@target_name = "Triton"
						@target_class = "satellite"
					elif "PROTEUS" in @Target_Name: 
						@target_name = "Proteus"
						@target_class = "satellite"
					elif "PUCK" in @Target_Name: 
						@target_name = "Puck"
						@target_class = "satellite"
					elif "RHEA" in @Target_Name: 
						@target_name = "Rhea"
						@target_class = "satellite"
					elif "TETHYS" in @Target_Name: 
						@target_name = "Tethys"
						@target_class = "satellite"
					elif "ARIEL" in @Target_Name: 
						@target_name = "Ariel"
						@target_class = "satellite"
					elif "OBERON" in @Target_Name: 
						@target_name = "Oberon"
						@target_class = "satellite"
					elif "MIRANDA" in @Target_Name: 
						@target_name = "Miranda"
						@target_class = "satellite"
					elif "PORTIA" in @Target_Name: 
						@target_name = "Portia"
						@target_class = "satellite"
					elif "MIRANDA" in @Target_Name: 
						@target_name = "Miranda"
						@target_class = "satellite"
					elif "METIS" in @Target_Name: 
						@target_name = "Metis"
						@target_class = "satellite"
					elif "THEBE" in @Target_Name: 
						@target_name = "Thebe"
						@target_class = "satellite"
					elif "JULIET" in @Target_Name: 
						@target_name = "Juliet"
						@target_class = "satellite"
					elif "AMALTHEA" in @Target_Name: 
						@target_name = "Amalthea"
						@target_class = "satellite"
					elif "CHARON" in @Target_Name: 
						@target_name = "Charon"
						@target_class = "satellite"
					elif "HAUMEA" in @Target_Name: 
						@target_name = "Haumea"
						@target_class = "dwarf planet"
					elif "MAKEMAKE" in @Target_Name or "2005-FY9" in @Target_Name or "2005FY9" in @Target_Name: 
						@target_name = "Makemake"
						@target_class = "dwarf planet"
					elif "ERIS" in @Target_Name or "2003UB313" in @Target_Name: 
						@target_name = "Eris"
						@target_class = "dwarf planet"
					elif "2007OR10" in @Target_Name: 
						@target_name = "2007 OR10"
						@target_class = "asteroid"
					elif "CERES" in @Target_Name: 
						@target_name = "Ceres"
						@target_class = "dwarf planet"

					# if still blanck, look at other kw
					elif "JUPITER" in @Target_Keywords or "13402" in @Proposal_ID or "8108" in @Proposal_ID:
						@target_name = "Jupiter"
						@target_class = "planet"
					elif "SATURN" in @Target_Keywords: 
						@target_name = "Saturn"
						@target_class = "planet"
					elif "NEPTUNE" in @Target_Keywords: 
						@target_name = "Neptune"
						@target_class = "planet"
					elif "URANUS" in @Target_Keywords: 
						@target_name = "Uranus"
						@target_class = "planet"
					elif "TITAN" in @Target_Keywords: 
						@target_name = "Titan"
						@target_class = "satellite"
					elif "SATELLITE IO" in @Target_Keywords or "SATELLITE; IO" in @Target_Keywords: 
						@target_name = "Io"
						@target_class = "satellite"
					# All main targets identified at the time of writing!

					# datalink compact argument, dummy if target not identified
					# to be secured if multiple targets are present
					if @target_name is not "":
						@ds_id = @target_class + "/" + @target_name + "/" + str(float(@Start_Date)+2400000.5)
					else:
						@ds_id = " / / "

					# filter not eligible targets (asteroids and else)
					if "1996RR20" not in @Target_Name and "COMET-SL" not in @Target_Name and "AGK+26D0765" not in @Target_Name: 
						yield row


				</code>
			</rowfilter>



		</csvGrammar>

		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="spatial_frame_type">"celestial"</var>
				<var key="proposal_target_name" source ="Target_Name" />
				<var key="filter" source="Filter" />
				<var key="waveband" source="Band" />
				<var key="target_description" source="Target_Keywords" />


				<var key="service_title">"hst_planeto" </var>

				<var key="access_format">"application/fits"</var>
				<var key="proposal_pi" source="PI_Name" />
				<var key="proposal_id" source="Proposal_ID" />
				<var key="proposal_title" source="Proposal_Title" />


				<!-- the id for our datalink services is just the
				concatenation of object class, object name, and epoch
				<var key="ds_id">@granule_gid+"/"+@target_name+"/"+str(float(@Start_Date)+2400000.5)</var>
				-->
				<var key="datalink_url">("\getConfig{web}{serverURL}/\rdId/epdl/dlmeta"
					+"?ID="+urllib.quote(@ds_id))</var> 


				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind key="granule_gid">@granule_gid</bind>
					<bind key="granule_uid">@Product_ID</bind>
					<bind key="obs_id">@Obs_ID</bind>
					<bind key="target_class">@target_class</bind>
					<bind key="time_scale">"UTC"</bind>
					<bind key="target_name">@target_name</bind>
					<bind key="processing_level">@Cal_Lev</bind>

				<!-- correct, but has to convert from string to float, and limited precision in original data -->
					<bind key="time_min">dateTimeToJdn(mjdToDateTime(float(@Start_Date))) </bind>
					<bind key="time_max">dateTimeToJdn(mjdToDateTime(float(@End_Date)))</bind>

					<bind key="time_exp_min">@Int_Time </bind>
					<bind key="time_exp_max">@Int_Time </bind>
					<bind key="spectral_range_min">@spectral_range_min</bind>
					<bind key="spectral_range_max">@spectral_range_max</bind>

					<bind name="dataproduct_type">@dataproduct_type</bind>
					<bind name="measurement_type">@measurement_type</bind>

					<bind name="service_title">@service_title</bind>
					<bind name="creation_date">@Meta_Release</bind>
					<bind name="modification_date">@Meta_Release</bind>
					<bind name="release_date">@Data_Release</bind>

					<bind key="instrument_host_name">@Collection</bind>
					<bind key="instrument_name">@instrument</bind> 

				<!--	Could also extract min/max in RA/DEC from Polygon (and put those in RA/DEC)	-->

					<bind key="c1min">@RA</bind>
					<bind key="c1max">@RA</bind>
					<bind key="c2min">@Dec</bind>
					<bind key="c2max">@Dec</bind>

				</apply>
			</rowmaker>
		</make>
	</data>


    <service id="epdl" allowed="dlmeta">
        <datalinkCore>

            <metaMaker>
                <code>
                    upstream_service_url="http://vo.imcce.fr/webservices/miriade/ephemph_query.php?-from=vespa&amp;"
                    parameters = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "hst",
                        "-mime": "votable",
                    }
                    url = upstream_service_url+urllib.urlencode(parameters)

                    parameters2 = {
                        "-name": descriptor.ephId,
                        "-ep": descriptor.epoch,
                        "-observer": "hst",
                        "-mime": "html",
                    }
                    url2 = upstream_service_url+urllib.urlencode(parameters2)

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
                        description="computed ephemeris of the planet",
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
                        "-observer": "hst",
                        "-mime": "html",
                    }
                    raise WebRedirect(upstream_service_url+urllib.urlencode(parameters3))
                </code>
            </dataFunction>
        </datalinkCore>
    </service>

</resource>
