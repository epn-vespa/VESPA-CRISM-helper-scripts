<resource schema="spicam">
	
	<!--
		Information describing the schema (which represents the database)
											-->

	<meta name="title">SPICAM - LATMOS</meta>
	
	<meta name="creationDate">2018-04-17T16:28:28Z</meta>
	<meta name="description" format="raw">
		<![CDATA[
INSTRUMENT DESCRIPTION: 

The following description of SPICAM has been adapted from:

Bertaux et al. (2006), SPICAM on Mars Express: Observing modes and overview of UV spectrometer data and scientific results, J. Geophys. Res., 111, E10S90, doi:10.1029/2006JE002690.

Korablev et al. (2006), SPICAM IR acousto-optic spectrometer experiment on Mars Express, J. Geophys. Res., 111, E09S03, doi:10.1029/2006JE002696.

SPICAM was the first instrument to perform stellar occultations at Mars, and its UV imaging spectrometer (118–320 nm, resolution 1.5 nm) was designed primarily to obtain atmospheric vertical profiles by stellar occultation. The wavelength range was dictated by the strong UV absorption of CO2 (wavelength under 200 nm) and the strong Hartley ozone absorption (220–280 nm). The capacity to orient the spacecraft allows a great versatility of observation modes: nadir and limb viewing (both day and night) and solar and stellar occultations.

The SPICAM IR spectrometer on Mars Express mission (1.0–1.7 μm, spectral resolution 0.5–1.2 nm) is one of two channels of SPICAM UV‐IR instrument. In this spectrometer is applied for the first time in planetary research the technology of an acousto‐optic tunable filter (AOTF). SPICAM IR is a point nadir‐looking spectrometer with sequential scanning of the spectrum by the AOTF. Sun occultations are performed with a help of dedicated solar port.

A recent review of the 10 years of observations by SPICAM was published by Montmessin et al. (2017), SPICAM on Mars Express: A 10 year in-depth survey of the Martian atmosphere, Icarus 297, pp. 195-216, <a href=https://doi.org/10.1016/j.icarus.2017.06.022>Article link</a>.
		]]>
	</meta>
	<meta name="copyright">LATMOS/IPSL</meta>
	<meta name="creator.name">Zi Yin; Alexandre Rostaing</meta>
	<meta name="publisher">Laboratoire Atmosphères, Milieux, Observations Spatiales</meta>
	<meta name="contact.name">\metaString{contact.name}</meta>
	<meta name="contact.email">anni.maattanen@latmos.ipsl.fr</meta>
	<meta name="contact.address">\metaSting{contact.address}</meta>
	<meta name="contact.telephone">\metaString{contact.telephone}</meta>
	<meta name="contributor.name">Anni Määttänen</meta>
        <meta name="contributor.name">François Forget</meta>
        <meta name="contributor.name">Sébastien Lebonnois</meta>
	<meta name="referenceURL">http://europlaneth2020.projet.latmos.ipsl.fr/</meta>
	<meta name="facility">LATMOS, avec soutien du CNES et de l'ESA</meta>
	<meta name="instrument">SPICAM</meta>
	<meta name="subject">Mars Express</meta>
	<meta name="subject">SPICAM</meta>
	<meta name="subject">Mars</meta>
	<meta name="subject">Stellar occulation</meta>
	<meta name="subject">Solar occulation</meta>
	<meta name="subject">Atmospheric profiles</meta>
	<meta name="subject">Temperature</meta>
        <meta name="subject">CO2 concentration</meta>
        <meta name="subject">Ozone concentration</meta>
        <meta name="subject">Aerosol extinction</meta>
	<meta name="coverage">
		<meta name="waveband">Infrared</meta>
		<meta name="waveband">UV</meta>
	</meta>
	<meta name="type">Catalog</meta>
	<meta name="source">Määttänen et al. (2013), A complete climatology of the aerosol vertical distribution on Mars from MEx/SPICAM UV solar occultations, Icarus, 223, doi:10.1016/j.icarus.2012.12.001; Lebonnois et al. (2006), Vertical distribution of ozone on Mars as measured by SPICAM/Mars Express using stellar occultations, J. Geophys. Res., 111, E09S05, doi:10.1029/2005JE002643; Forget et al. (2009), Density and temperatures of the upper Martian atmosphere measured by stellar occultations with Mars Express SPICAM, J. Geophys. Res., 114, E01004, doi:10.1029/2008JE003086</meta>
	<meta name="contentLevel">General</meta>
	<meta name="contentLevel">University</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="utype">ivo://vopdc.obspm/std/EpnCore#schema-2.0</meta>

	

	<!--
		Table Creation (for EPN-TAP there should only be one table per schema and it has to be called epn_core)
																-->

	<table id="epn_core" onDisk="True" adql="True" primary="granule_uid">

		<!--    Additionnal information on the table    -->
                <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="2.0"> EPN-TAP </meta>
                <meta name="description">
			The database contains profiles of atmospheric CO2 density and temperature derived thereof, and ozone concentration profiles, all derived from the first year(s) of SPICAM UV stellar occultation observations (Forget et al. 2009, Lebonnois et al. 2006). The database also includes the full dataset of four Martian years of aerosol extinction profiles from SPICAM UV solar occultations (Määttänen et al. 2013).
		</meta>
                <property key="supportsModel">EpnCore#schema-2.0</property>
                <property key="supportsModelURI">ivo://vopdc.obspm/std/EpnCore#schema-2.0</property>
                <publish sets="local"/>
                <stc>
                        Polygon ICRS [s_region]
                </stc>

        	<!--	This mixin predefines the columns required by EPN-TAP (with the optional ones)	-->
		<mixin
			spatial_frame_type="body"
			optional_columns="access_url access_format access_estsize time_scale"
			>//epntap2#table-2_0</mixin>
		
		<!--	Define the additionnal columns needed in your table	-->
		<column name="spatial_coordinate_description" type="text" ucd="meta.code.class;pos.frame" description="Describes the type of spatial coordinates" />
	        <column name="solar_longitude_min" type="double precision" unit="deg" ucd="pos.posAng;pos.heliocentric;stat.min"  description="Sub-dataset minimum solar longitude" />
        	<column name="solar_longitude_max" type="double precision" unit="deg" ucd="pos.posAng;pos.heliocentric;stat.max"  description="Sub-dataset maximum solar longitude" />
	        <column name="local_time_min" type="double precision" unit="h" ucd="time.phase;stat.min"  description="Sub-dataset minimum local time (Mars)" />
        	<column name="local_time_max" type="double precision" unit="h" ucd="time.phase;stat.max"  description="Sub-dataset maximum local time (Mars)" />
		<column name="time_scale" type="text" ucd="time.scale"  verbLevel="1" description="time scale" />
		<column name="orbit_pos" type="text" ucd="" description="Orbit and observation session number for a specific occultation" verbLevel="2" note="orbit"/>
		<column name="ds_id" type="text" tablehead="Dataset ID" description="Identifier for this profile to use when calling datalink services" ucd="meta.id"/>
		<column name="datalink_url" type="text" ucd="meta.ref.url;meta.datalink" tablehead="Datalink" description="URL of a datalink document for this dataset"  note="mcd_url"/>
	
		<meta name="note" tag="orbit">
			Mars Express orbits and observations are given numbers indicating the orbit number and the observation session along that orbit, with format "orbitAsession".
		</meta>
		<meta name="note" tag="mcd_link"><![CDATA[
			In this service, links to different Mars Climate Scenario (MCS) are available.
			These links enable data comparisions between the SPICAM derived profiles and the MCD (Mars Climate Database) generated profiles. The MCD profiles are generated according to the SPICAM profile's Solar longitude, martian local time, latitude and longitude on Mars, the MCS and the max/min altitude.

			The available scenarion are as follow:

			* my - Martian Year scenario is the dust scenario corresponding to the Martian year of the SPICAM profile.
			* clim - Climato dust scenario with average solar EUV.
			* cold - Cold dust scenario with minimum solar EUV.
			* warm - Warm dust scenario with maximum solar EUV.
			* storm - Dust storm dust scenarion, only available during Martian summers (Solar longitude 180 to 360)
		]]>
		</meta>
	</table>



	<!--
		Define the rows of data to add to the table
								-->

	<data id="import">
                <publish/>
		
		<!--	Define where to retrieve the data	-->
		<sources>
			<!-- Pattern is used when there are multiple source files (here all the .csv files)	-->
			<pattern>csv/*.csv</pattern>
		</sources>
		
		<!--	Grammars are used to read and retrieve data (here rows in csv files). The rows are saved in local variables	-->
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind key="table">"\schema.epn_core"</bind>
				<!--	Python code can be used in rowfilter to modify/format the data (modifications are done as the rows are read)	-->
				<code>
					@granule_uid = @Id + @orbit
					@granule_gid = @Id+"MY"+@MY
					@obs_id = @Id

					@ds_id=@Id+"/"+@orbit+"/"+@Sl+"/"+@LST+"/"+@lon+"/"+@lat+"/"+@zmin+"/"+@zmax+"/"+@nData

					@access_url = "http://vo.projet.latmos.ipsl.fr:8080/cgi-bin/cgi-script.py?orbit="+@orbit+chr(38)+"profiletype="+@Id

					<!-- After formating or modifying the data, each row must be yielded (automatically done for the default row if no formating/modifications are done)	-->
					yield row
				</code>
			</rowfilter>
		</csvGrammar>
		

		<!--	Add the rows of data to the table (should always be epn_core)	-->
		<make table="epn_core">
			
			<!-- Inserts the data of each row made by the grammar in its column	-->
			<rowmaker idmaps="*">

				<!--	Insert fixed data	-->
				<var key="spatial_frame_type">"body"</var>
				<var key="orbit_pos" source="orbit" />
				<var key="target_name">"Mars"</var>
                                <var key="spatial_coordinate_description">"Mars_IAU2000"</var>
                                <var key="access_format">"application/x-votable+xml"</var>
                                <var key="access_estsize">5</var>
                                <var key="target_class">"planet"</var>
                                <var key="dataproduct_type">"pr"</var>
                                <var key="target_region">"atmosphere"</var>
                                <var key="time_scale">"UTC"</var>
                                <var key="service_title">"SPICAM"</var>
                                <var key="creation_date">"2018-04-17"</var>
				<var key="datalink_url">("\getConfig{web}{serverURL}/\rdId/mcddata/dlmeta"+"?ID="+@ds_id)</var>

				<!--	Associates the EPN-TAP values to the grammar values (key and source respectively)	--> 
				<var key="c1min" source="lon" />
				<var key="c1max" source="lon" />
				<var key="c2min" source="lat" />
				<var key="c2max" source="lat" />
				<var key="c3min" source="zmin" />
                                <var key="c3max" source="zmax" />
				<var key="time_min" source="JD" />  
				<var key="time_max" source="JD" />    
				<var key="solar_longitude_min" source="Sl" />
				<var key="solar_longitude_max" source="Sl" />
				<var key="local_time_min" source="LST" />
				<var key="local_time_max" source="LST" />
				<var key="measurement_type" source="datatype" />
				
				<!-- Bind the columns required by EPN-TAP	-->
				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind key="granule_uid">@granule_uid</bind>
					<bind key="granule_gid">@granule_gid</bind>
					<bind key="obs_id">@obs_id</bind>
					
					<bind key="target_class">@target_class</bind>
					
					<bind key="c1min">@c1min</bind>
					<bind key="c1max">@c1max</bind>
					<bind key="c2min">@c2min</bind>
					<bind key="c2max">@c2max</bind>
					<bind key="c3min">@c3min</bind>
					<bind key="c3max">@c3max</bind>
					
					<bind key="processing_level">"5"</bind>
					
					<bind key="dataproduct_type">@dataproduct_type</bind>
					<bind key="measurement_type">@measurement_type</bind>
					
					<bind key="service_title">@service_title</bind> 
					<bind key="creation_date">@creation_date</bind>
					
					<bind key="time_min">@time_min</bind>
					<bind key="time_max">@time_max</bind>
					<bind key="target_name">"Mars"</bind>
					<bind key="instrument_host_name">@instrument_host_name</bind>
					<bind key="instrument_name">@instrument_name</bind>
					<bind key="target_name">@target_name</bind> 
					<bind key="target_region">@target_region</bind>
					<bind key="time_scale">@time_scale</bind>
				</apply>
			</rowmaker>
		</make>
	</data>

	<service id="mcddata" allowed="dlget,dlmeta">
        	<datalinkCore>
			<metaMaker>
				<code>
					url = "http://vo.projet.latmos.ipsl.fr:8080/vo/"
					if "o3dens" in descriptor.profiletype:
						url += "o3dens/"+descriptor.orbit+".txt"
					elif "co2dens" in descriptor.profiletype:
						url += "temp_densCO2/d_"+descriptor.orbit+".txt"
					elif "temp" in descriptor.profiletype:
						url += "temp_densCO2/t_"+descriptor.orbit+".txt"
					elif "aero" in descriptor.profiletype:
						url += "aerosols/"+descriptor.orbit+".txt"
					yield LinkDef(descriptor.profiletype+descriptor.orbit,url,description="SPICAM profile used to call this datalink service")
                                </code>
                        </metaMaker>

            		<metaMaker>
                		<code>
                    			yield MS(InputKey, name="MCD_Scenario",type="text",ucd="meta.id", description="This service allows to access the profile generated by the MCD with the same spatial and temporal coordinates as the SPICAM profile. However, the MCD generates profiles according to a dust scenario. For more information on the Mars Climate Database and its related simulations, go to http://www-mars.lmd.jussieu.fr/.", multiplicity="forced-single",required="True",values=MS(Values,min=1,max=32,))
                		</code> 
            		</metaMaker>

            		<descriptorGenerator>
            			<setup>
					<code>
						class ProfileDescriptor(object):
							def __init__(self, pubDID):
								self.pubDID=pubDID
								self.profiletype, self.orbit, self.LS, self.lst, self.lon, self.lat, self.min, self.max, self.data = self.pubDID.split("/")
							description="SPICAM profile parameters",
					</code>
            			</setup>
                		<code>
                    			return ProfileDescriptor(pubDID)
                		</code>
            		</descriptorGenerator>

            		<dataFunction>
                		<setup>
                    			<par name="upstream_service_url">"http://sery.lmd.jussieu.fr:8080/cgi-bin/spicamcgi.py?"</par>
                    			<code>
						import urllib
						from gavo.svcs import WebRedirect
                    			</code>
                		</setup>
				<code>
					parameters = {
						"dust" : args['MCD_Scenario'],
						"ls" : descriptor.LS,
						"localtime" : descriptor.lst,
						"lon" : descriptor.lon,
						"lat" : descriptor.lat,
						"altmin" : descriptor.min,
						"altmax" : descriptor.max,
						"nValues" : descriptor.data,
					}
					raise WebRedirect(upstream_service_url+urllib.urlencode(parameters))
				</code>
            		</dataFunction>
        	</datalinkCore>
    	</service>

<!--	<data id="collection" auto="false">
                <register services="__system__/tap#run"/>
                <make table="epn_core"/>
		<publish/>
        </data> -->
</resource>


