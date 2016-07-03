<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="iks">
  <meta name="title">SHORT NAME</meta>
  <meta name="creationDate">2016-05-22T09:42:00Z</meta>
  <meta name="description" format="plain">
Service description: this is generic q.rd file for EPN-TAP v2 services in DaCHS. Mandatory parameters are in first block. Replace with your values</meta>
  <meta name="copyright">PADC/LESIA</meta>
  <meta name="creator.name">Stephane Erard</meta>
  <meta name="publisher">Paris Astronomical Data Centre - LESIA</meta>
  <meta name="contact.name">Stephane Erard</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="contact.address">Observatoire de Paris VOPDC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
  <meta name="subject">Replicate this descriptor as needed</meta>
  <meta name="source">Bibcode goes here</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="utype">ivo://vopdc.obspm/std/EpnCore#schema-2.0</meta>


<table id="epn_core" onDisk="True" adql="True">
    <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="2.0"> EPN-TAP </meta>
    <meta name="description"> Short service description </meta>
    <meta name="referenceURL">http://lesia.obspm.fr</meta>
    <meta name="utype">EPN-TAP 2.0</meta>
    <property key="supportsModel">EpnCore#schema-2.0</property>
    <property key="supportsModelURI">ivo://vopdc.obspm/std/EpnCore#schema-2.0</property>
    <publish sets="ivo_managed"/>
    <stc> Polygon UNKNOWNFrame [s_region] </stc>
    
    <column name="granule_uid" type="text" required="True" ucd="meta.id" 
      description="Granule unique identifier"/>
    <column name="granule_gid" type="text" required="True" ucd="meta.id" 
      description="Granule group identifier"/>
    <column name="obs_id" type="text" required="True" ucd="meta.id" 
      description="Observation identifier"/>
    <column name="dataproduct_type"  type="text" required="True" ucd="meta.code.class" 
      description="Science organization of the data product"/>
    <column name="target_name"  type="text" required="True" ucd="meta.id;src" 
      description="Standard name of target"/>
    <column name="target_class"  type="text" required="True" ucd="meta.code.class;src" 
      description="Standard type of target"/>
    <column name="time_min"  type="double precision" ucd="time.start" unit="d"
      description="Acquisition start time"/>
    <column name="time_max" type="double precision" ucd="time.end" unit="d"
      description="Acquisition stop time"/>
    <column name="time_scale" type="text" ucd="time.scale" 
      description="Time scale, constant for data services = UTC"/>
    <column name="time_sampling_step_min"  type="double precision" ucd="time.interval;stat.min"  unit="s"
      description="Min time sampling step"/>
    <column name="time_sampling_step_max"  type="double precision" ucd="time.interval;stat.max"  unit="s"
      description="Max time sampling step"/>
    <column name="time_exp_min"  type="double precision" ucd="time.duration;stat.min"  unit="s"
      description="Min integration time"/>
    <column name="time_exp_max"  type="double precision" ucd="time.duration;stat.max"  unit="s"
      description="Max integration time"/>
    <column name="spectral_range_min"  type="double precision" ucd="em.freq;stat.min" unit="Hz"
      description="Spectral range low limit (as fq)"/>
    <column name="spectral_range_max"  type="double precision" ucd="em.freq;stat.max" unit="Hz"
      description="Spectral range high limit (as fq)"/>
    <column name="spectral_sampling_step_min" type="double precision" ucd="em.freq.step;stat.min" unit="Hz"
      description="Min spectral sampling step (as fq)"/>
    <column name="spectral_sampling_step_max" type="double precision" ucd="em.freq.step;stat.max" unit="Hz"
      description="Max spectral sampling step (as fq)"/>
    <column name="spectral_resolution_min" type="double precision" ucd="spect.resolution;stat.min" unit="Hz"
      description="Min spectral resolution (as fq)"/>
    <column name="spectral_resolution_max" type="double precision" ucd="spect.resolution;stat.max" unit="Hz"
      description="Max spectral resolution (as fq)"/>
    <column name="c1min"   type="double precision" ucd="pos;stat.min" unit="deg"
      description="Westernmost longitude / min RA"/>
    <column name="c1max"   type="double precision" ucd="pos;stat.max" unit="deg"
      description="Easternmost longitude / max RA"/>
    <column name="c2min"   type="double precision" ucd="pos;stat.min" unit="deg"
      description="Min latitude / DEC"/>
    <column name="c2max"   type="double precision" ucd="pos;stat.max" unit="deg"
      description="Max latitude / DEC"/>
    <column name="c3min"   type="double precision" ucd="pos;stat.min" unit=""
      description="3rd spatial coordinate min value"/>
    <column name="c3max"   type="double precision" ucd="pos;stat.max" unit=""
      description="3rd spatial coordinate max value"/>
    <column name="c1_resol_min"   type="double precision" ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution of 1st spatial coordinate"/>
    <column name="c1_resol_max"   type="double precision" ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution of 1st spatial coordinate"/>
    <column name="c2_resol_min"   type="double precision" ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution of 2nd spatial coordinate"/>
    <column name="c2_resol_max"   type="double precision" ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution of 2nd spatial coordinate"/>
    <column name="c3_resol_min"   type="double precision" ucd="pos.resolution;stat.min" unit=""
      description="Min resolution of 3rd spatial coordinate"/>
    <column name="c3_resol_max"   type="double precision" ucd="pos.resolution;stat.max" unit=""
      description="Max resolution of 3rd spatial coordinate"/>
    <column name="spatial_frame_type"  type="text" ucd="meta.code.class;pos.frame" 
      description="Defines the nature of coordinates"/>
    <column name="s_region"  type="spoly" ucd="phys.outline;obs.field" 
      description="Footprint, STC style"/>
    <column name="incidence_min"    type="double precision" ucd="pos.posAng;stat.min" unit="deg"
      description="Min incidence angle (solar zenith angle)"/>
    <column name="incidence_max"   type="double precision" ucd="pos.posAng;stat.max" unit="deg"
      description="Max incidence angle (solar zenith angle) "/>
    <column name="emergence_min"   type="double precision" ucd="pos.posAng;stat.min" unit="deg"
      description="Min emergence angle"/>
    <column name="emergence_max" type="double precision" ucd="pos.posAng;stat.max" unit="deg"
      description="Max emergence angle"/>
    <column name="phase_min" type="double precision" ucd="pos.phaseAng;stat.min" unit="deg"
      description="Min phase angle"/>
    <column name="phase_max"  type="double precision" ucd="pos.phaseAng;stat.max" unit="deg"
      description="Max phase angle"/>
    <column name="instrument_host_name" type="text" ucd="meta.id;instr.obsty"
      description="Standard name of the observatory or spacecraft"/>
    <column name="instrument_name" type="text" ucd="meta.id;instr"
      description="Standard name of the instrument"/>
    <column name="measurement_type"  type="text" ucd="meta.id;phys.atmol"
      description="UCD defining the nature of the data"/>
    <column name="processing_level"  type="integer" required="True" ucd="meta.code;obs.calib"
      description="Data calibration level"/>
    <column name="creation_date"  type="date" ucd="time.creation"
      description="Creation date of granule"/>
    <column name="modification_date"  type="date" ucd="time.update"
      description="Date of last modification of granule"/>
    <column name="release_date"  type="date" ucd="time.release"
      description="Starting date of public period"/>
    <column name="service_title"  type="text" ucd="meta.title"
      description="Acronym of data service"/>

    <column name="access_url"  type="text" ucd="meta.ref.url;meta.file"
      description="URL of the data file"/>
    <column name="access_format"  type="text" ucd="meta.code;mime"
      description="Data file format"/>
    <column name="access_estsize" type="integer" unit="kbyte" ucd="phys.size;meta.file"
      description="Estimate file size in kB"/>
    <column name="access_md5" type="integer" ucd="meta.checksum;meta.file"
      description="Ckecksum, md5"/>
    <column name="thumbnail_url"  type="text" ucd="meta.ref.url;meta.file"
      description="URL of a small thumbnail"/>
    <column name="file_name"  type="text" ucd="meta.id;meta.file"
      description="Data file name"/>
    <column name="bib_reference"  type="text" ucd="meta.bib"
      description="Bibliograpic reference"/>
	<column name="species" type="text" ucd="meta.name" 
	  description="Molecular/atomic species"/>
    <column name="target_region"  type="text" ucd="obs.field"
      description="Type of region of interest"/>
    <column name="feature_name"  type="text" ucd="obs.field"
      description="Name of region of interest"/>
    <column name="target_time_min"  type="double precision" ucd="time.start" unit="d"
      description="Acquisition start time at target"/>
    <column name="target_time_max" type="double precision" ucd="time.end" unit="d"
      description="Acquisition stop time at target"/>
    <column name="target_distance_min"  type="double precision" ucd="pos.distance;stat.min" unit="km"
      description="Spacecraft-target min distance"/>
    <column name="target_distance_max"  type="double precision" ucd="pos.distance;stat.max" unit="km"
      description="Spacecraft-target max distance"/>
    <column name="local_time_min"  type="double precision" ucd="time.phase;stat.min" unit="h"
      description="Min local time"/>
    <column name="local_time_max" type="double precision" ucd="time.phase;stat.min" unit="h"
      description="Max local time"/>
    <column name="solar_longitude_min" type="double precision" 
	  ucd="pos.angDistance;pos.heliocentric;stat.min " unit="deg"
      description="Min Ls/season parameter"/>
    <column name="solar_longitude_max" type="double precision" 
	  ucd="pos.angDistance;pos.heliocentric;stat.max " unit="deg"
      description="Max Ls/season parameter"/>
    <column name="publisher"  type="text" ucd="meta.curation"
      description="Service publisher"/>


</table>


 <data id="import">
    <make table="epn_core"/>
 </data>

<data id="collection" auto="false">
        <register services="__system__/tap#run"/>
        <make table="epn_core"/>
		<publish/>
</data>
</resource>
