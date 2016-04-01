<!-- A template for resource metadata; look for ___ and fill these pieces
out (or delete them) -->

<resource schema="evn_vespa_crism">
        <meta name="title">CRISM data from Earth Server 2</meta>
        <meta name="description">
                ___
        </meta>
        <meta name="creationDate">March 30th, 2016</meta>
        <meta name="subject">___</meta>
        <meta name="subject">__</meta>

        <meta name="creator.name">Mikhail Minin; ___</meta>
        <meta name="contact.name">___</meta>
        <meta name="contact.email">___</meta>
        <meta name="instrument">CRISM</meta>
        <meta name="facility">___</meta>

        <meta name="source">___</meta>
        <meta name="contentLevel">Research</meta>
        <meta name="type">Catalog</meta>  <!-- or Archive, Survey -->

        <meta name="coverage">
                <meta name="waveband">___</meta> <!-- One of Radio, Millimeter,
                        Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated -->
                <meta name="profile">Mars</meta>
        </meta>

        <table id="epn_core" onDisk="true">
                <mixin processing_level="2" spatial_frame_type="body">//epntap2#table</mixin>
                <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3">EPN-TAP</meta>
                <meta name="description">EPN-TAP access to the Test CRISM database.</meta>
                <stc>
		     Polygon ICRS [s_region]
                </stc>
		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file, 
				case sensitive. If present, next 2 paramenters must be present."/>
		<column name="access_format" type="text" unit="mime type in lowercase" description="File format type" ucd="meta.code.mime" verbLevel="1"/> 
		<column name="access_estsize" type="integer" unit="kbyte" description="Estimate file size in kbyte" ucd="phys.size;meta.file" verbLevel="1"/>
<!--non-standard-->
                <column name="counter" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="activity" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard"/>
                <column name="activity_macro" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard"/>
                <column name="sensor_id" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="filetype" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
                <column name="version" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
        </table>

        <data id="import">
                <sources>data/fp04-a.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>
                <make table="epn_core">
			<rowmaker idmaps="*">
				<map key="c1_min" source="Westernmost_longitude" />
				<map key="c1_max" source="Easternmost_longitude" />
				<map key="c2_min" source="Minimum_latitude" />
				<map key="c2_max" source="Maximum_latitude" />
				<map key="s_region" source="footprint" />

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

				<var key="access_format">"tif"</var>
				<var key="access_estsize">0</var>

				<apply procDef="//epntap2#populate" name="fillepn">
					<bind name="target_name">"Mars"</bind>
					<bind name="instrument_host_name">'MRO'</bind>
					<bind name="instrument_name">'CRISM'</bind>
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>
					<bind name="spatial_frame_type">"body"</bind>
					<bind name="access_format">@access_format</bind>
				</apply>
			</rowmaker>
		</make>
        </data>


</resource>
