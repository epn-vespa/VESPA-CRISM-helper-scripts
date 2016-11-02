<?xml version="1.0" encoding="UTF-8"?>
<resource schema="illu67p">
  <meta name="title">Illumination map of 67P</meta>
  <meta name="creationDate">2016-04-05T16:00:00</meta>
  <meta name="description" format="plain">Illumination by the Sun of each face of the comet 67P/Churyumov-Gerasimenko based on the shape model CSHP_DV_130_01_______00200.obj (http://npsadev.esac.esa.int/3D/67/Shapes/ ). The service provides the cosine between the normal of each face (in the same order as the faces defined in the shape model) and the Sun direction; both numerical values and images of the illumination are available. Each map is defined for a given position of the Sun in the frame of 67P (67P/C-G_CK). Longitude 0 is at the center of each map. The code is developed by A. Beth, Imperial College, UK and the service is provided by CDPP http://cdpp.eu</meta>
  <meta name="creator.name">Arnaud Beth</meta>
  <meta name="contact.name">Arnaud Beth</meta>
  <meta name="contact.email">abeth@ic.ac.uk</meta>
  <meta name="contact.address">Imperial College London, Dpt of Physics, Prince Consort Road, SW7 2AZ, London, United Kingdom</meta>
  <meta name="subject">comet</meta>
  <meta name="subject">67P</meta>
  <meta name="subject">body</meta>
  <meta name="utype">ivo://vopdc.obspm/std/EpnCore#schema-2.0</meta>
  <table id="epn_core" onDisk="True" adql="True">
    <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="2.0"> EPN-TAP </meta>
    <meta name="description">Illumination maps of 67P-Churyumov-Gerasimenko for different positions of the sun</meta>
    <meta name="referenceURL">http://npsadev.esac.esa.int/3D/67/Shapes/CSHP_DV_130_01_______00200.obj</meta>
    <meta name="utype">EPN-TAP 2.0</meta>
    <column name="granule_uid" type="text" required="True" ucd="meta.id" description="Granule unique identifier, provides direct access"/>
    <column name="dataproduct_type" type="text" ucd="meta.code.class" description="Organisation of the data product (from enumerated list)"/>
    <column name="target_name" type="text" ucd="meta.id;src" description="Name of target (IAU standard)"/>
    <column name="time_min" type="double precision" ucd="time.start" unit="d" description="Acquisition start time (in JD) (not necessary)"/>
    <column name="time_max" type="double precision" ucd="time.end" unit="d" description="Acquisition stop time (in JD) (not necessary)"/>
    <column name="subsolar_longitude" type="integer" ucd="pos.bodyrc.long" required="True"/>
    <column name="subsolar_colatitude" type="integer" ucd="pos.bodyrc.lat" required="True"/>
    <column name="access_url" type="text" ucd="meta.ref.url;meta.file"/>
    <column name="shape_model_url" type="text" ucd="meta.ref.url;meta.model"/>
    <column name="instrument_host_name" type="text" ucd="meta.id;instr.obsty" description="(not necessary)"/>
    <column name="instrument_name" type="text" ucd="meta.id;instr" description="(not necessary)"/>
    <column name="target_class" type="text" ucd="meta.code.class;src" description="Type of target, from enumerated list"/>
    <column name="processing_level" type="integer" ucd="meta.code;obs.calib" required="True"/>
    <column name="access_estsize" type="integer" ucd="phys.size;meta.file" required="True"/>
    <column name="thumbnail_url" type="text" ucd="meta.ref.url;meta.file"/>
    <column name="granule_gid" type="text" required="True" ucd="meta.id" description="Group identifier, identical for similar data products"/>
    <column name="obs_id" type="text" required="True" ucd="meta.id" description="Identical for data products related to the same original data"/>
    <column name="access_format" type="text" ucd="meta.code.mime"/>
	<column name="file_name" ucd="meta.id;meta.file" type="text" description="Name of the data file"/>
    <column name="creation_date" type="date" ucd="time.creation"/>
    <column name="modification_date" type="date" ucd="time.update"/>
    <column name="release_date" type="date" ucd="time.release"/>
    <column name="service_title" type="text" ucd="meta.title"/>
    <column name="publisher" type="text" ucd="meta.name"/>
    <column name="time_scale" type="text" ucd="time.scale"/>
    <column name="time_sampling_step_min" type="double precision" ucd="time.interval;stat.min" unit="s" description="Min time sampling step (not necessary)"/>
    <column name="time_sampling_step_max" type="double precision" ucd="time.interval;stat.max" unit="s" description="Max time sampling step (not necessary)"/>
    <column name="spatial_frame_type" type="text" ucd="meta.code.class;pos.frame" description="(can be necessary)"/>
    <column name="time_exp_min" type="double precision" ucd="time.duration;obs.exposure;stat.min" unit="s" description="Min integration time (not necessary)"/>
    <column name="time_exp_max" type="double precision" ucd="time.duration;obs.exposure;stat.max" unit="s" description="Max integration time (not necessary)"/>
    <column name="measurement_type" type="text" ucd="meta.ucd" description="(not necessary)"/>
    <column name="spectral_range_min" type="double precision" ucd="em.freq;stat.min" unit="Hz" description="Min spectral range (not necessary)"/>
    <column name="spectral_range_max" type="double precision" ucd="em.freq;stat.max" unit="Hz" description="Max spectral range (not necessary)"/>
    <column name="spectral_sampling_step_min" type="double precision" ucd="em.freq.step;stat.min" unit="Hz" description="Min spectral sampling step (not necessary)"/>
    <column name="spectral_sampling_step_max" type="double precision" ucd="em.freq.step;stat.max" unit="Hz" description="Max spectral sampling step (not necessary)"/>
    <column name="spectral_resolution_min" type="double precision" ucd="spect.resolution;stat.min" unit="Hz" description="Min spectral resolution (not necessary)"/>
    <column name="spectral_resolution_max" type="double precision" ucd="spect.resolution;stat.max" unit="Hz" description="Max spectral resolution (not necessary)"/>
    <column name="c1min" type="double precision" ucd="pos;stat.min" unit="deg" description="(not necessary)"/>
    <column name="c1max" type="double precision" ucd="pos;stat.max" unit="deg" description="(not necessary)"/>
    <column name="c2min" type="double precision" ucd="pos;stat.min" unit="deg" description="(not necessary)"/>
    <column name="c2max" type="double precision" ucd="pos;stat.max" unit="deg" description="(not necessary)"/>
    <column name="c3min" type="double precision" ucd="pos;stat.min" unit="" description="(not necessary)"/>
    <column name="c3max" type="double precision" ucd="pos;stat.max" unit="" description="(not necessary)"/>
    <column name="s_region" type="spoly" ucd="phys.outline;obs.field" description="(not necessary)"/>
    <column name="c1_resol_min" type="double precision" ucd="pos.resolution;stat.min" unit="deg" description="(not necessary)"/>
    <column name="c1_resol_max" type="double precision" ucd="pos.resolution;stat.max" unit="deg" description="(not necessary)"/>
    <column name="c2_resol_min" type="double precision" ucd="pos.resolution;stat.min" unit="deg" description="Min resolution in latitude"/>
    <column name="c2_resol_max" type="double precision" ucd="pos.resolution;stat.max" unit="deg" description="(not necessary)"/>
    <column name="c3_resol_min" type="double precision" ucd="pos.resolution;stat.min" unit="" description="(not necessary)"/>
    <column name="c3_resol_max" type="double precision" ucd="pos.resolution;stat.max" unit="" description="(not necessary)"/>
    <column name="incidence_min" type="double precision" ucd="pos.posAng;stat.min" unit="deg" description="(not necessary)"/>
    <column name="incidence_max" type="double precision" ucd="pos.posAng;stat.max" unit="deg" description="(not necessary)"/>
    <column name="emergence_min" type="double precision" ucd="pos.posAng;stat.min" unit="deg" description="(not necessary)"/>
    <column name="emergence_max" type="double precision" ucd="pos.posAng;stat.max" unit="deg" description="(not necessary)"/>
    <column name="phase_min" type="double precision" ucd="pos.phaseAng;stat.min" unit="deg" description="(not necessary)"/>
    <column name="phase_max" type="double precision" ucd="pos.phaseAng;stat.max" unit="deg" description="(not necessary)"/>
	<column name="species" ucd="meta.id;phys.atmol" type="text" description="(not necessary)"/>
	<column name="feature_name" ucd="meta.id;pos" type="text" description="(not necessary)"/>
	<column name="bib_reference" ucd="meta.bib" type="text" description="(not necessary)"/>
  </table>
  <data id="import">
    <make table="epn_core"/>
  </data>
  <data id="collection" auto="false">
    <register services="__system__/tap#run"/>
    <make table="epn_core"/>
  </data>
</resource>
