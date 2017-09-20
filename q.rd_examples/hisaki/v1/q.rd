<?xml version="1.0" encoding="UTF-8" ?>

<resource schema="hisaki">
	<meta name="title">Hisaki Planetary Database</meta>
	<meta name="creationDate">2016-02-16T17:42:00Z</meta>
	<meta name="description" format="plain">
		Hisaki/Exceed EUV Planetary observation database.
	</meta>
        <meta name="facility">Hisaki</meta>
	<meta name="copyright" format="raw">
		<![CDATA[
		This database is not public. The data should not be used.
		]]>
	</meta>
	<meta name="creator.name">Baptiste Cecconi</meta>
	<meta name="subject">Jupiter</meta>
	<meta name="subject">Venus</meta>
	<meta name="subject">Ultraviolet telescopes</meta>
	<meta name="subject">Magnetosphere</meta>
	<meta name="subject">Aurora</meta>

	<table id="epn_core" onDisk="True" adql="True">
		<meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3">EPN-TAP</meta>
		<meta name="description">EPN-TAP access to the Hisaki Planetary database.</meta>
		<meta name="referenceURL">https://hisaki.darts.isas.jaxa.jp</meta>
		<stc>
		     Polygon ICRS [s_region]
		</stc>
		<column name="granule_uid" type="text" ucd="meta.id" description="Unique ID of data product"/>
		<column name="granule_gid" type="text" ucd="meta.id" description="Group ID of data product"/>
		<column name="obs_id"  type="text" ucd="meta.id" description="Original data ID of data product"/>
		<column name="dataproduct_type" type="text" ucd="meta.code.class" description="Organization of the data product, from enumerated list"/>
		<column name="target_name" type="text" ucd="meta.id;src" description="name of target (from a list depending on target type)"/>
		<column name="target_class" type="text" ucd="meta.code.class;src" description="type of target from enumerated list"/>
		<column name="time_min" ucd="time.start" unit="d" description="Acquisition start time (in JD)"/> 
		<column name="time_max" ucd="time.end" unit="d" description="Acquisition stop time (in JD)"/>
		<column name="time_sampling_step_min" ucd="time.interval;stat.min" unit="s" description="Min time sampling step"/>
		<column name="time_sampling_step_max" ucd="time.interval;stat.max" unit="s" description="Max time sampling step"/>
		<column name="time_exp_min" ucd="time.duration;obs.exposure;stat.min" unit="s" description="Min integration time"/>
		<column name="time_exp_max" ucd="time.duration;obs.exposure;stat.max" unit="s" description="Max integration time"/>
		<column name="spectral_range_min" ucd="em.freq;stat.min" unit="Hz" description="Min spectral range (frequency)"/>
		<column name="spectral_range_max" ucd="em.freq;stat.max" unit="Hz" description="Max spectral range (frequency)"/>
		<column name="spectral_sampling_step_min" ucd="em.freq.step;stat.min" unit="Hz" description="min spectral sampling step"/>
		<column name="spectral_sampling_step_max" ucd="em.freq.step;stat.max" unit="Hz" description="max pectral sampling step"/>
		<column name="spectral_resolution_min" ucd="spec.resolution;stat.min" unit="Hz" description="Min spectral resolution"/>
		<column name="spectral_resolution_max" ucd="spec.resolution;stat.max" unit="Hz" description="Max spectral resolution"/>
		<column name="c1min" ucd="pos.eq.ra;stat.min" unit="deg" description="Min value of RA"/>
		<column name="c1max" ucd="pos.eq.ra;stat.max" unit="deg" description="Max value of RA"/>
		<column name="c2min" ucd="pos.eq.dec;stat.min" unit="deg" description="Min value of Dec"/>
		<column name="c2max" ucd="pos.eq.dec;stat.max" unit="deg" description="Max value of Dec"/>
		<column name="c3min" ucd="pos.distance;stat.min" unit="m" description="Min value of spatial coordinate 3 (not used)"/>
		<column name="c3max" ucd="pos.distance;stat.max" unit="m" description="Max value of spatial coordinate 3 (not used)"/>
		<column name="s_region" ucd="phys.angArea;obs" description="STC-S region" type="spoly"/>
		<column name="c1_resol_min" ucd="pos.resolution;stat.min" unit="" description="Min resolution on spatial coordinate 1 (not used)"/>
		<column name="c1_resol_max" ucd="pos.resolution;stat.max" unit="" description="Max resolution on spatial coordinate 1 (not used)"/>
		<column name="c2_resol_min" ucd="pos.resolution;stat.min" unit="" description="Min resolution on spatial coordinate 2 (not used)"/>
		<column name="c2_resol_max" ucd="pos.resolution;stat.max" unit="" description="Max resolution on spatial coordinate 2 (not used)"/>
		<column name="c3_resol_min" ucd="pos.resolution;stat.min" unit="" description="Min resolution on spatial coordinate 3 (not used)"/>
		<column name="c3_resol_max" ucd="pos.resolution;stat.min" unit="" description="Max resolution on spatial coordinate 3 (not used)"/>
		<column name="spatial_frame_type" type="text" ucd="meta.id;class" description="Flavor of coordinate system"/>
		<column name="incidence_min" unit="deg" ucd="pos.posang;stat.min" description="Min incidence angle (solar zenithal angle)"/> 
		<column name="incidence_max" unit="deg" ucd="pos.posang;stat.max" description="Max incidence angle (solar zenithal angle) "/>
		<column name="emergence_min" unit="deg" ucd="pos.posang;stat.min" description="Min emergence angle"/> 
		<column name="emergence_max" unit="deg"	ucd="pos.posang;stat.max" description="Max emergence angle"/>
		<column name="phase_min" unit="deg" ucd="pos.posAng;stat.min" description="Min phase angle"/>
		<column name="phase_max" unit="deg" ucd="pos.posAng;stat.max" description="Max phase angle"/>
		<column name="instrument_host_name" type="text" ucd="meta.code" description="Standard name of the observatory or spacecraft"/>
		<column name="instrument_name" type="text" ucd="meta.id;instr" description="Standard name of instrument"/>
		<column name="measurement_type" type="text" ucd="meta.ucd" description="UCD(s) defining the data"/>
		<column name="creation_date" type="date" ucd="time.creation" description="Granule creation date"/>
		<column name="modification_date" type="date" ucd="time.update" description="Granule last modification date"/>
		<column name="release_date" type="date" ucd="time.release" description="Granule public release date"/>
		<column name="access_url" type="text" ucd="meta.ref.url" description="URL of the data files."/>
		<column name="access_format" type="text" ucd="meta.code.mime" description="file format type."/>
		<column name="access_estsize" type="integer" unit="kbyte" required="True" ucd="phys.size;meta.file" description="estimate file size in kB."/>
		<column name="access_md5" type="text" ucd="meta.code" description="MD5 Hash of data product"/>
		<column name="thumbnail_url" type="text" ucd="meta.ref.url;meta.preview" description="URL of thumbnail image"/>
		<column name="processing_level" type="integer" required="True"	ucd="meta.class.qual" description="type of calibration from CODMAC."/>
		<column name="publisher" type="text" ucd="meta.name" description="publiher of the ressource"/>
		<column name="reference" type="text" ucd="meta.ref" description="publication of reference"/>
		<column name="service_title" type="text" ucd="meta.title" description="Title of the ressource"/>
		<column name="target_region" type="text" ucd="meta.name;class" description="Name of observed region on target"/>
		<column name="time_scale" type="text" ucd="time.scale" description="time scale taken from STC"/>
		<column name="feature_name" type="text" ucd="meta.name" description="Named feature or element observed on target"/>
	</table>

	<data id="import">
		<make table="epn_core"/>
	</data>

	<data id="collection" auto="false">
<!--		<register services="__system__/tap#run"/>  -->
		<make table="epn_core"/>
	</data>

</resource>
