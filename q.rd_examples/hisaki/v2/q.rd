<?xml version="1.0" encoding="UTF-8" ?>
<resource schema="hisaki">
	<meta name="title">Hisaki Planetary Database</meta>
	<meta name="description" format="plain">
		Hisaki/Exceed EUV Planetary observation database.
	</meta>
	<meta name="copyright" format="raw">
		<![CDATA[
		This database is not public. The data should not be used.
		]]>
	</meta>
	<meta name="creationDate">2017-09-19T17:42:00Z</meta>
	<meta name="creator.name">Tomoki KIMURA</meta>
	<meta name="contact.name">Tomoki KIMURA</meta>
	<meta name="contact.email">tomoki.kimura@riken.jp</meta>
	<meta name="contact.address">RIBF403 2-1 Hirosawa, RIKEN, Saitama, Japan</meta>
	<meta name="subject">Jupiter</meta>
	<meta name="subject">Venus</meta>
	<meta name="subject">Ultraviolet telescopes</meta>
	<meta name="subject">Magnetosphere</meta>
	<meta name="subject">Aurora</meta>
	<meta name="subject">Io Plasma Torus</meta>
	<meta name="source">TBD</meta>
	<meta name="referenceURL">https://hisaki.darts.isas.jaxa.jp</meta>
	<meta name="contentLevel">General</meta>
	<meta name="contentLevel">University</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="contentLevel">Amateur</meta>
	<meta name="referenceURL">http://www.obs-nancay.fr/-Le-reseau-decametrique-.html?lang=en</meta>
	<meta name="instrument">EXCEED</meta>
	<meta name="facility">Hisaki</meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
		<meta name="waveband">UV</meta>
	</meta>


<!--
	<tableplanetplanet id="epn_core" onDisk="true" adql="True" primary="granule_uid">
n package must be installed: 
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

		<mixin
			spatial_frame_type="celestial"
			optional_columns="access_url access_format access_estsize time_scale access_md5
				thumbnail_url species publisher bib_reference target_region feature_name"
			>//epntap2#table-2_0</mixin>
		<column name="ra" type="double precision" ucd="pos.eq.ra" description=""/>
		<column name="dec" type="double precision" ucd="pos.eq.dec" description=""/>
		<column name="accref" type="text" ucd="meta.ref;meta.file" description="File path from local directory."/>
		<column name="subobserver_latitude" type="double precision" ucd="pos.bodyrc.lat;obs.observer" description=""/>  
		<column name="subobserver_longitude" type="double precision" ucd="pos.bodyrc.lon;obs.observer" description=""/>  
		<column name="subsolar_latitude" type="double precision" ucd="pos.bodyrc.lat" description=""/>  
		<column name="subsolar_longitude" type="double precision" ucd="pos.bodyrc.lon" description=""/>  
		<column name="target_distance_min" type="double precision" ucd="pos.distance;stat.min" description=""/>  
		<column name="target_distance_max" type="double precision" ucd="pos.distance;stat.max" description=""/>  
		<column name="sun_distance_min" type="double precision" ucd="pos.distance;stat.min" description=""/>  
		<column name="sun_distance_max" type="double precision" ucd="pos.distance;stat.max" description=""/>  
		<column name="obs_mode" type="text" ucd="meta.flag" description=""/>
		<column name="detector_name" type="text" ucd="meta.id;instr" description=""/>
		<column name="opt_elem" type="text" ucd="meta.id;instr" description=""/>
		<column name="filter" type="text" ucd="meta.id;instr.filter" description=""/>
		<column name="orientation" type="double precision" ucd="pos.posAng" description=""/>
		<column name="unit" type="text" ucd="meta.unit" description=""/>
		<column name="proposal_id" type="text" ucd="meta.id;obs.proposal" description=""/>
		<column name="proposal_pi" type="text" ucd="meta.id.PI;obs.proposal" description=""/>
		<column name="proposal_title" type="text" ucd="meta.title;obs.proposal" description=""/>
		<column name="platesc" type="double precision" ucd="pos.angResolution" description=""/>
		<column name="campaign" type="text" ucd="meta.id" description=""/>
		<column name="target_apparent_radius" type="double precision" ucd="phys.size.radius" description=""/>
		<column name="north_pole_position" type="double precision" ucd="pos.posAng" description=""/>
		<column name="target_primary_hemisphere" type="text" ucd="meta.id" description=""/>
		<column name="target_secondary_hemisphere" type="text" ucd="meta.id" description=""/>
		<column name="time_scale" type="text" ucd="time.scale" description="time scale taken from STC"/>
	</table>


	<data id="import" updating="True">
		
		<sources pattern="data/exeuv.*jupiter*2014010*.fits" recurse="True">
			<ignoreSources fromdb="select accref from hisaki.epn_core;"/>
		</sources>
		
		<customGrammar module="get_metadata">
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
				<bind key="fsize">int(@access_estsize)*1024</bind>
				<bind key="accref">@accref</bind>
				<bind key="path">@access_url</bind>
				<bind key="mime">@access_format</bind>
			</rowfilter>
		</customGrammar>
		
		<make table="epn_core">
			<rowmaker idmaps="*">
				<map key="time_min">dateTimeToJdn(parseISODT(@iso_time_min))</map>
				<map key="time_max">dateTimeToJdn(parseISODT(@iso_time_max))</map>
				<map key="accref">\inputRelativePath</map>
				<map key="target_class">"planet"</map>
				<map key="dataproduct_type">"sc"</map>
			</rowmaker>
		</make>
	</data>
</resource>

