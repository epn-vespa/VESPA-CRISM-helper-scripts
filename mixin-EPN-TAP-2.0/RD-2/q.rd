<resource schema="m3">
	<meta name="title">Moon Mineralogy Mapper</meta>
	<meta name="description">Spectrometer on board Chandrayaan-1</meta>
	<meta name="creationDate">2017-07-18T00:00:00</meta>
	<meta name="subject">M3</meta>
	<meta name="creator.name">Mikhail Minin</meta>
	<meta name="contact.name">Mikhail Minin</meta>
	<meta name="contact.email">m.minin@jacobs-university.de</meta>
	<meta name="instrument">Moon Mineralogy Mapper</meta>
	<meta name="facility">Jacobs University</meta>
	<meta name="source">NASA</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Catalog</meta>
	<meta name="coverage">
		<meta name="waveband">Infrared</meta>
		<meta name="waveband">Optical</meta>
		<meta name="Profile">UNKNOWNFrame</meta>
		</meta>

<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true">
		<mixin  spatial_frame_type="body" optional_columns="access_url access_format access_estsize thumbnail_url file_name">//epntap2#table-2_0</mixin>
		<meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3">EPN-TAP</meta>
		<meta name="description">EPN-TAP access to rasdaman M3 database.</meta>
		<stc>
			Polygon ICRS [s_region]
		</stc>
<!-- MAKE OPTIONAL COLUMNS: -->
		<column name="access_url" type="text" ucd="meta.ref.url;meta.file" verbLevel="1" description="URL of the data file, 
			case sensitive. If present, next 2 paramenters must be present."/> 
		<column name="access_format" type="text" ucd="meta.code.mime" verbLevel="1" description="File format type"/> 
		<column name="access_estsize" type="text" ucd="phys.size;meta.file" verbLevel="1" description="Estimate file size in kbyte (with this spelling)"/> 
		<column name="thumbnail_url" type="text" ucd="meta.ref.url;meta.preview" verbLevel="1" description="URL of a thumbnail image with predefined size (png ~200 pix, for use in a client only)"/> 
		<column name="file_name" type="text" ucd="meta.id;meta.file" verbLevel="1" description="Name of the data file only, case sensitive"/> 
<!-- MAKE ADDITIONAL COLUMNS: -->
		<column name="image_width" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="Width of the granule in px." />
		<column name="image_height" type="text" ucd="meta.note;meta.main" tablehead="value" verbLevel="1" description="Height of the granule in px." />
		<publish />
	</table>
<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/data05.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>
		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="granule_uid" source="uid" />
				<var key="granule_gid">"main"</var>
				<var key="obs_id" source="coverageID" />

				<var key="dataproduct_type">"sc"</var>
				<var key="measurement_type">"phys.albedo;phys.luminosity;phys.angArea;em.wl"</var>

				<var key="processing_level">"3"</var>

				<var key="target_name">"Moon"</var>
				<var key="target_class">"satellite"</var>



				<var key="c1min" source="SubsetLonMin" />
				<var key="c1max" source="SubsetLonMax" />
				<var key="c1_resol_min" source="ResolMin" />
				<var key="c1_resol_max" source="ResolMax" />

				<var key="c2min" source="SubsetLatMin" />
				<var key="c2max" source="SubsetLatMax" />


				<var key="spatial_frame_type">"body"</var>




				<var key="s_region" source="PolygonSubset" />

				<var key="instrument_host_name">"CHANDRAYAAN-1 ORBITER" </var>
				<var key="instrument_name">"MOON MINERALOGY MAPPER"</var>

				<var key="service_title">"M3"</var>
				<var key="creation_date" source="CreationTime" />
				<var key="modification_date">"2017-7-19"</var>
				<var key="release_date">"2017-7-19"</var>

				<var key="access_url" source="Access" />
				<var key="access_format">"application/x-geotiff"</var>
				<var key="access_estsize">"100000"</var>
				<var key="thumbnail_url" source="Preview" />
				<var key="file_name" source="coverageID" />








				<var key="image_width" source="width" />
				<var key="image_height" source="subsetHeight" />

				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="obs_id">@obs_id</bind>

					<bind name="dataproduct_type">@dataproduct_type</bind>
					<bind name="measurement_type">@measurement_type</bind>

					<bind name="processing_level">@processing_level</bind>

					<bind name="target_name">@target_name</bind>
					<bind name="target_class">@target_class</bind>



					<bind name="c1min">@c1min</bind>
					<bind name="c1max">@c1max</bind>
					<bind name="c1_resol_min">@c1_resol_min</bind>
					<bind name="c1_resol_max">@c1_resol_max</bind>

					<bind name="c2min">@c2min</bind>
					<bind name="c2max">@c2max</bind>






					<bind name="s_region">@s_region</bind>

					<bind name="instrument_host_name">@instrument_host_name</bind>
					<bind name="instrument_name">@instrument_name</bind>

					<bind name="service_title">@service_title</bind>
					<bind name="creation_date">@creation_date</bind>
					<bind name="modification_date">@modification_date</bind>
					<bind name="release_date">@release_date</bind>

				</apply>
			</rowmaker>
		</make>
	</data>
</resource>
