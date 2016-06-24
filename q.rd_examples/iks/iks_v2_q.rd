<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="iks">
  <meta name="title">IKS</meta>
  <meta name="creationDate">2016-02-14T19:42:00Z</meta>
  <meta name="description" format="plain">
Measurements of comet Halley in the spectral channel of IKS on board the Vega-1 spacecraft. Data are retrieved from the PDS Small Bodies Node data set (2011 reformatted version) and updated. The data set consists in 101 tables providing the radiance spectrum of comet Halley from various distances, plus two composite spectra. For details and further references, see: Combes M. et al., 1988, The 2.5-12 micron Spectrum of Comet Halley from the IKS-VEGA Experiment, Icarus, 76, 404-436 [1988Icar...76..404C]  </meta>
  <meta name="copyright">IKI/LESIA/PDS</meta>
  <meta name="creator.name">Stephane Erard</meta>
  <meta name="publisher">Paris Astronomical Data Centre - LESIA</meta>
  <meta name="contact.name">Stephane Erard</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="contact.address">Observatoire de Paris VOPDC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
  <meta name="subject">comet</meta>
  <meta name="subject">spectroscopy</meta>
  <meta name="subject">infrared</meta>
  <meta name="subject">1P Halley</meta>
  <meta name="source">1988Icar...76..404C</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="utype">eon  </meta>


<table id="epn_core" onDisk="True" adql="True">
    <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="2.0"> EPN-TAP </meta>
    <meta name="description"> IR spectroscopy of comet Halley </meta>
    <meta name="referenceURL">http://lesia.obspm.fr</meta>
    <meta name="utype">EPN-TAP 2.0</meta>
    <property key="supportsModel">EPN-TAP 2.0</property>
    <property key="supportsModelURI">ivo://vopdc.obspm/std/EpnCore-2.0</property>
    <publish sets="ivo_managed"/>
    <stc> Polygon UNKNOWNFrame [s_region] </stc>

    <column name="granule_uid" type="text" required="True" 
      ucd="meta.id" 
      description="Granule unique identifier, provides direct access"/>
    <column name="granule_gid" type="text" required="True" 
      ucd="meta.id" 
      description="Group identifier, identical for similar data products"/>
    <column name="obs_id" type="text" required="True" 
      ucd="meta.id" 
      description="Identical for data products related to the same original data"/>
    <column name="dataproduct_type"  type="text" 
      ucd="meta.code.class" 
      description="Organization of the data product (from enumerated list)"/>
    <column name="target_name"  type="text" 
      ucd="meta.id;src" 
      description="Name of target (IAU standard)"/>
    <column name="alt_target_name"  type="text" 
      ucd="meta.id;src" 
      description="Extra: Alternative name of target"/>
    <column name="target_class"  type="text" 
      ucd="meta.code.class;src" 
      description="Type of target, from enumerated list"/>
    <column name="acquisition_id" type="text" 
      ucd="meta.id" 
      description="Extra: ID of the data file in the original archive"/>
    <column name="target_distance_min"  type="double precision"
      ucd="pos.distance;stat.min" unit="km"
      description="Spacecraft-target min distance"/>
    <column name="target_distance_max"  type="double precision"
      ucd="pos.distance;stat.max" unit="km"
      description="Spacecraft-target max distance"/>
    <column name="sun_distance_min"  type="double precision"
      ucd="pos.distance;stat.min" unit="au"
      description="Extra: min target heliocentric distance in au"/>
    <column name="sun_distance_max"  type="double precision"
      ucd="pos.distance;stat.max" unit="au"
      description="Extra: max target heliocentric distance in au"/>
    <column name="earth_distance_min"  type="double precision"
      ucd="pos.distance;stat.min" unit="au"
      description="Extra: min target-Earth distance in au"/>
    <column name="earth_distance_max"  type="double precision"
      ucd="pos.distance;stat.max" unit="au"
      description="Extra: max target-Earth distance in au"/>
    <column name="time_min"  type="double precision"
      ucd="time.start" unit="d"
      description="Acquisition start time (in JD)"/>
    <column name="time_max" type="double precision"
      ucd="time.end" unit="d"
      description="Acquisition stop time (in JD)"/>
    <column name="target_time_min"  type="double precision"
      ucd="time.start" unit="d"
      description="Acquisition start time at target"/>
    <column name="target_time_max" type="double precision"
      ucd="time.end" unit="d"
      description="Acquisition stop time at target"/>
    <column name="time_scale" type="text"
      ucd="time.scale" 
      description="Time scale, constant for data services = UTC"/>
    <column name="time_sampling_step_min"   type="double precision"
     ucd="time.interval;stat.min"  unit="s"
      description="Min time sampling step"/>
    <column name="time_sampling_step_max"   type="double precision"
      ucd="time.interval;stat.max"  unit="s"
      description="Max time sampling step"/>
    <column name="time_exp_min"   type="double precision"
      ucd="time.duration;stat.min"  unit="s"
      description="Min integration time"/>
    <column name="time_exp_max"   type="double precision"
      ucd="time.duration;stat.max"  unit="s"
      description="Max integration time"/>
    <column name="spectral_range_min"   type="double precision"
      ucd="em.freq;stat.min" unit="Hz"
      description="Min spectral range (as frequency)"/>
    <column name="spectral_range_max"   type="double precision"
      ucd="em.freq;stat.max" unit="Hz"
      description="Max spectral range (as frequency)"/>
    <column name="spectral_sampling_step_min"  type="double precision"
      ucd="em.freq.step;stat.min" unit="Hz"
      description="Min spectral sampling step (as frequency)"/>
    <column name="spectral_sampling_step_max"  type="double precision"
        ucd="em.freq.step;stat.max" unit="Hz"
      description="Max spectral sampling step (as frequency)"/>
    <column name="spectral_resolution_min"  type="double precision"
      ucd="spect.resolution;stat.min" unit="Hz"
      description="Min spectral resolution (as frequency)"/>
    <column name="spectral_resolution_max"  type="double precision"
      ucd="spect.resolution;stat.max" unit="Hz"
      description="Max spectral resolution (as frequency)"/>
    <column name="c1min"   type="double precision"
      ucd="pos;stat.min" unit="deg"
      description="Min (westernmost) longitude on surface"/>
    <column name="c1max"   type="double precision"
      ucd="pos;stat.max" unit="deg"
      description="Max (easternmost) longitude on surface"/>
    <column name="c2min"   type="double precision"
      ucd="pos;stat.min" unit="deg"
      description="Min latitude on planetary surface"/>
    <column name="c2max"   type="double precision"
      ucd="pos;stat.max" unit="deg"
      description="Max latitude on planetary surface"/>
    <column name="c3min"   type="double precision"
      ucd="pos;stat.min" unit=""
      description="Coordinate not used (altitude or depth)"/>
    <column name="c3max"   type="double precision"
      ucd="pos;stat.max" unit=""
      description="Coordinate not used (altitude or depth)"/>
    <column name="c1_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution in longitude"/>
    <column name="c1_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution in longitude"/>
    <column name="c2_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution in latitude"/>
    <column name="c2_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution in latitude"/>
    <column name="c3_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit=""
      description="not used"/>
    <column name="c3_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit=""
      description="not used"/>
    <column name="spatial_frame_type"  type="text" 
      ucd="meta.code.class;pos.frame" 
      description="Defines the nature of coordinates (from enumerated list)"/>
    <column name="s_region"  type="spoly" 
      ucd="phys.outline;obs.field" 
      description="Provides footprint"/>
    <column name="incidence_min"    type="double precision"
      ucd="pos.posAng;stat.min" unit="deg"
      description="Min incidence angle (solar zenith angle)"/>
    <column name="incidence_max"   type="double precision"
      ucd="pos.posAng;stat.max" unit="deg"
      description="Max incidence angle (solar zenith angle) "/>
    <column name="emergence_min"   type="double precision"
      ucd="pos.posAng;stat.min" unit="deg"
      description="Min emergence angle"/>
    <column name="emergence_max"   type="double precision"
      ucd="pos.posAng;stat.max" unit="deg"
      description="Max emergence angle"/>
    <column name="phase_min"    type="double precision"
      ucd="pos.phaseAng;stat.min" unit="deg"
      description="Min phase angle"/>
    <column name="phase_max"   type="double precision" 
      ucd="pos.phaseAng;stat.max" unit="deg"
      description="Max phase angle"/>
    <column name="instrument_host_name"  type="text"
      ucd="meta.id;instr.obsty"
      description="Standard name of the observatory or spacecraft"/>
    <column name="instrument_name"  type="text"
      ucd="meta.id;instr"
      description="Standard name of the instrument"/>
    <column name="measurement_type"  type="text"
      ucd="meta.ucd"
      description="UCD(s) defining the nature of measurements"/>
    <column name="access_url"  type="text"
      ucd="meta.ref.url;meta.file"
      description="URL of the data file"/>
    <column name="access_format"  type="text"
      ucd="meta.code;mime"
      description="File format type"/>
    <column name="access_estsize"  type="integer" unit="kbyte" required="True"
      ucd="phys.size;meta.file"
      description="Estimate file size in kB"/>
    <column name="thumbnail_url"  type="text" 
      ucd="meta.ref.url;meta.file"
      description="URL of a small thumbnail"/>
    <column name="file_name"  type="text"
      ucd="meta.id;meta.file"
      description="Name root of the data file"/>
    <column name="bib_reference"  type="text"
      ucd="meta.bib"
      description="Bibliograpic reference"/>
    <column name="creation_date"  type="date"
      ucd="time.creation"
      description="Creation date of entry"/>
    <column name="modification_date"  type="date"
      ucd="time.update"
      description="Date of last modification of entry"/>
    <column name="release_date"  type="date"
      ucd="time.release"
      description="Start of public period"/>
    <column name="service_title"  type="text"
      ucd="meta.title"
      description="Acronym of this data service"/>
    <column name="processing_level"  type="integer" required="True"
      ucd="meta.code;obs.calib"
      description="Level of calibration (CODMAC level)"/>
</table>


 <data id="import">
    <make table="epn_core"/>
 </data>

<data id="collection" auto="false">
        <register services="__system__/tap#run"/>
        <make table="epn_core"/>
</data>
</resource>
