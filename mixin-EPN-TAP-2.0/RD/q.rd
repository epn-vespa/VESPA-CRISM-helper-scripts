<!-- A template for resource metadata; look for ___ and fill these pieces
out (or delete them) -->

<resource schema="epn_vespa_crism">
        <meta name="title">CRISM data from Earth Server 2</meta>
        <meta name="description">
                ___
        </meta>
        <meta name="creationDate">2016-03-30T00:00:00</meta>
        <meta name="subject">___</meta>
        <meta name="subject">__</meta>

        <meta name="creator.name">Mikhail Minin</meta>
        <meta name="contact.name">Mikhail Minin</meta>
        <meta name="contact.email">m.minin@jacobs-university.de</meta>
        <meta name="instrument">CRISM</meta>
        <meta name="facility">___</meta>

        <meta name="source">___</meta>
        <meta name="contentLevel">Research</meta>
        <meta name="type">Catalog</meta>  <!-- or Archive, Survey -->

        <meta name="coverage">
<!--         
                <meta name="waveband"></meta> 
-->
<!-- One of Radio, Millimeter,
                        Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated -->
<!--
                <meta name="profile">Mars</meta>
-->
        </meta>

        <table id="epn_core">
                <mixin spatial_frame_type="body">//epntap2#table-2_0</mixin>
<!--                <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3">EPN-TAP</meta>-->
                <meta name="description">EPN-TAP access to the Test CRISM database.</meta>
                <stc>
		     Polygon ICRS [s_region]
                </stc>
		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file, 
				case sensitive. If present, next 2 paramenters must be present."/>
		<column name="access_format" type="text" unit="mime type in lowercase" description="File format type" ucd="meta.code.mime" verbLevel="1"/> 
		<column name="access_estsize" type="integer" unit="kbyte" description="Estimate file size in kbyte" ucd="phys.size;meta.file" verbLevel="1"/>
                <column name="thumbnail_url" type="text" ucd="meta.ref.url;meta.file" description="URL of an image preview" />
<!--non-standard-->
                <column name="counter" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="activity" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard"/>
                <column name="activity_macro" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard"/>
                <column name="sensor_id" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="filetype" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="version" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />


                <column name="E" type="integer" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="image width" />
                <column name="N" type="integer" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="image height" />

                <column name="subgranule_url" type="text" ucd="meta.ref.url" verbLevel="1" description="Link to a web application to extract data for CASSIS" />

		<!--temporary only -->
		
                <column name="f_region" type="text" ucd="meta.ref.url" verbLevel="1" description="Container for temporary data, this field will be removed at a later time" />

                <publish />
        </table>

        <data id="import">
                <sources>data/fp05-good.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>
                <make table="epn_core">
			<rowmaker idmaps="*">
				<var key="c1min" source="Westernmost_longitude" />
				<var key="c1max" source="Easternmost_longitude" />
				<var key="c2min" source="Minimum_latitude" />
				<var key="c2max" source="Maximum_latitude" />
				<var key="f_region" source="footprint" />
				<var key="s_region">@f_region[:@f_region[:@f_region.rfind(" ")].rfind(" ")]</var>

				<var key="spatial_frame_type">"body"</var>
				<var key="processing_level">3</var>

				<var key="granule_uid" source="name" />
				<var key="granule_gid">(@granule_uid)[0:3]</var>
				<var key="obs_id">(@granule_uid)[3:11]</var>

				<var key="counter">(@granule_uid)[12:14]</var>
				<var key="activity">(@granule_uid)[15:17]</var>
				<var key="activity_macro">(@granule_uid)[17:20]</var>
				<var key="sensor_id">(@granule_uid)[20:21]</var>
				<var key="filetype">(@granule_uid)[22:25]</var>
				<var key="version">(@granule_uid)[25:26]</var>
				<var key="access_url">('http://access.planetserver.eu:8080/rasdaman/ows?&amp;SERVICE=WCS&amp;VERSION=2.0.1&amp;REQUEST=GetCoverage&amp;COVERAGEID=') + (@granule_uid).lower() + ('&amp;FORMAT=image/tiff')</var>
				<var key="target_name">"Mars"</var>
				<var key="target_class">"Planet"</var>

				<var key="access_format">"image/tiff"</var>
				<var key="access_estsize">1000000</var>

				<var key="E" source="dimE" />
				<var key="N" source="dimN" />

				<var key="instrument_name">"CRISM"</var>
				<var key="instrument_host_name">"MRO"</var>

				<var key="thumbnail_url">('http://access.planetserver.eu:8080/rasdaman/ows?service=WCS&amp;version=2.0.1&amp;request=ProcessCoverages&amp;query=for%20data%20in%20(%20') + (@granule_uid).lower() + "%20)%20return%20" + ('encode(%20struct{%20red:%20(int)(255%20/%20(max((data.band_54%20!=%2065535)%20*%20data.band_54)%20-%20min(data.band_54)))%20*%20(data.band_54%20-%20min(data.band_54));%20green:%20(int)(255%20/%20(max((data.band_37%20!=%2065535)%20*%20data.band_37)%20-%20min(data.band_37)))%20*%20(data.band_37%20-%20min(data.band_37));%20blue:%20(int)(255%20/%20(max((data.band_27%20!=%2065535)%20*%20data.band_27)%20-%20min(data.band_27)))%20*%20(data.band_27%20-%20min(data.band_27))},%20"png","nodata=null"%20)','encode(%20struct{%20red:%20(int)(255%20/%20(max((data.band_233%20!=%2065535)%20*%20data.band_233)%20-%20min(data.band_233)))%20*%20(data.band_233%20-%20min(data.band_233));%20green:%20(int)(255%20/%20(max((data.band_78%20!=%2065535)%20*%20data.band_78)%20-%20min(data.band_78)))%20*%20(data.band_78%20-%20min(data.band_78));%20blue:%20(int)(255%20/%20(max((data.band_13%20!=%2065535)%20*%20data.band_13)%20-%20min(data.band_13)))%20*%20(data.band_13%20-%20min(data.band_13))},%20"png","nodata=null"%20)')[@sensor_id=="L"]</var>

				<var key="subgranule_url">('http://epn1.epn-vespa.jacobs-university.de:8080/subGranule/index.html?cov=') + (@granule_uid).lower() + ('&amp;c1min=') + str(@c1min) + ('&amp;c1min=') + str(@c1min) + ('&amp;c1max=') + str(@c1max) + ('&amp;c2min=') + str(@c2min) + ('&amp;c2max=') + str(@c2max) + ('&amp;E_px=') + str(@E) + ('&amp;N_px=') + str(@N)  + ('&amp;sensor_id=') + (@sensor_id).lower()</var>
<!--
 + str(@c2_max) + ('&amp;E_px=') + str(@E) + ('&amp;N_px=') + str(@N) + ('&amp;sensor_id=') + (@sensor_id)</var>
-->
				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind name="processing_level">3</bind>
					<bind name="target_name">@target_name</bind>
					<bind name="target_class">@target_class</bind>
					<bind name="instrument_host_name">@instrument_host_name</bind>
					<bind name="instrument_name">@instrument_name</bind>
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>
					<bind name="spatial_frame_type">"body"</bind>
					<bind name="access_format">@access_format</bind>

					<bind name="c1min">@c1min</bind>
					<bind name="c1max">@c1max</bind>
					<bind name="c2min">@c2min</bind>
					<bind name="c2max">@c2max</bind>
				</apply>
			</rowmaker>
		</make>
        </data>
</resource>
