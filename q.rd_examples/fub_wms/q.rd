<resource schema="fub_wms">
	<meta name="title">FUB_WMS</meta>
	<meta name="description">sample</meta>
	<meta name="creationDate">2016-03-30T00:00:00</meta>
	<meta name="subject">sample</meta>
	<meta name="creator.name">Sebastian Walter</meta>
	<meta name="contact.name">sample</meta>
	<meta name="contact.email">s.walter@fu-berlin.de</meta>
	<meta name="instrument">HRSC</meta>
	<meta name="facility">FU Berlin Planetary Sciences</meta>
	<meta name="source"></meta>
	<meta name="contentLevel"></meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
	<meta name="waveband">Optical</meta>
</meta>

<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true">
		<mixin processing_level="5" spatial_frame_type="celestial">//epntap2#table</mixin>
		<meta name="description">FUB WMS stuff</meta>
		<stc>
			Polygon ICRS [s_region]
		</stc>
<!-- MAKE OPTIONAL COLUMNS: -->
		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file, 
			case sensitive. If present, next 2 paramenters must be present."/> 
		<column name="access_format" type="text" ucd="meta.code.mime" verbLevel="1" description="File format type"/> 
		<column name="access_estsize" type="integer" unit="kbyte" ucd="phys.size;meta.file" verbLevel="1" description="Estimate file size in kbyte (with this spelling)"/> 
		<column name="file_name" type="text" ucd="meta.id;meta.file" verbLevel="1" description="Name of the data file only, case sensitive"/> 

<!-- MAKE more OPTIONAL COLUMNS, for example: -->
<!--
		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file, 
			case sensitive. If present, next 2 paramenters must be present."/> 
-->
<!-- MAKE NON-STANDARD COLUMNS, for example: -->
<!--
		<column name="counter" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="non standard" />
-->
		<publish />
	</table>
<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/wms.csv</sources>
		<csvGrammar></csvGrammar>
		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="granule_uid" source="LayerTitle" />
				<var key="granule_gid" source="System" />
				<var key="obs_id" source="LayerLayerName" />

				<var key="dataproduct_type">"ma"</var>

				<var key="target_name" source="Object" />
				<var key="target_class" source="TargetClass" />







				<var key="instrument_host_name">"InstrumentHostName"</var>
				<var key="instrument_name">"InstrumentName"</var>

				<var key="processing_level">5</var>
				<var key="access_url" source="OnlineResource" />

				<var key="access_url">@access_url + "service=WMS&amp;request=GetCapabilities"</var>
				<var key="access_format">"application/x-wms"</var>
				<var key="access_estsize">7</var>
				<var key="file_name">"mapserv.jpeg"</var>

				<var key="spatial_frame_type">"celestial"</var>

				<apply procDef="//epntap2#populate" name="fillepn">
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>

					<bind name="dataproduct_type">@dataproduct_type</bind>
					<bind name="measurement_type">@measurement_type</bind>

					<bind name="target_name">@target_name</bind>
					<bind name="target_class">@target_class</bind>

					<bind name="instrument_host_name">@instrument_host_name</bind>
					<bind name="instrument_name">@instrument_name</bind>


					<bind name="access_format">@access_format</bind>
					<bind name="spatial_frame_type">@spatial_frame_type</bind>

					<!--<bind name="access_estsize">@access_estsize</bind>
					<bind name="file_name">@file_name</bind>
					<bind name="access_url">@access_url</bind>
					<bind name="processing_level">@processing_level</bind>-->

				</apply>
			</rowmaker>
		</make>
	</data>
</resource>
