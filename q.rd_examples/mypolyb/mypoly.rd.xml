<!-- A template for resource metadata; look for ___ and fill these pieces
out (or delete them) -->

<resource schema="mypolyb">
        <meta name="title">___</meta>
        <meta name="description">
                ___
        </meta>
        <meta name="creationDate">___</meta>
        <meta name="subject">___</meta>
        <meta name="subject">__</meta>

        <meta name="creator.name">___; ___</meta>
        <meta name="contact.name">___</meta>
        <meta name="contact.email">___</meta>
        <meta name="instrument">___</meta>
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
                <mixin processing_level="2">//epntap#table</mixin>
                <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3">EPN-TAP</meta>
                <meta name="description">EPN-TAP access to the Test CHRISM database.</meta>
                <stc>
		     Polygon ICRS [s_region]
                </stc>
                <column name="id" type="integer" ucd="meta.id;meta.main" tablehead="id" verbLevel="1" required="True" />
                <column name="s_region" ucd="phys.angArea;obs" description="STC-S region" type="spoly"/>
                <column name="value" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" />
        </table>

        <data id="import">
                <sources>data/mypolytest.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.table"</bind>
			</rowfilter>
		</csvGrammar>
                <make table="epn_core">
			<rowmaker idmaps="*">
				<var key="myTargetName">str("Mars")</var>
				<var key="myAccessFormat">str("yourAccessFormat")</var>
				<var key="mySpatialFrameType">str("yourSpatialFrameType")</var>
				<apply procDef="//epntap#populate" name="fillepn">
					<bind name="target_name">@myTargetName</bind>
					<bind name="access_format">@myAccessFormat</bind>
					<bind name="spatial_frame_type">@mySpatialFrameType</bind>
					<bind name="instrument_host_name">'phobos'</bind>
				</apply>
			</rowmaker>
		</make>
        </data>


</resource>
