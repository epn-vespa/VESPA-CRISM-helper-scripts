<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="cassini_kronos">
  <meta name="title">Radio data from Cassini/HFR</meta>
  <meta name="creationDate">2014-12-05T17:42:00Z</meta>
  <meta name="description" format="plain">
  </meta>
  <meta name="copyright">please put reference to http://www.lesia.obspm.fr/kronos, and facilities of VOParis using Europlanet environment</meta>
  <meta name="creator.name">Baptiste Cecconi</meta>
  <meta name="subject">radioastronomy</meta>
  <meta name="subject">Saturn</meta>
  <meta name="subject">Jupiter</meta>
  <meta name="subject">magnetosphere</meta>
  <meta name="subject">aurora</meta>
  <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3"> EPN-TAP </meta>
  <table id="epn_core" onDisk="True" adql="True">
    <meta name="info" infoName="SERVICE_PROTOCOL" infoValue="0.3"> EPN-TAP </meta>
    <meta name="description">Cassini RPWS (Radio and Plasma Wave Science) HFR (High Frequency Receiver) data.</meta>
    <meta name="referenceURL">http://www.lesia.obspm.fr/kronos</meta>
    <column name="resource_type" type="text" 
      ucd="meta.id;class" 
      description="ressource type can be dataset or granule"/>
    <column name="dataset_id" type="text"
      ucd="meta.id;class"
      description="ID to link granule to a dataset"/>
   <column name="index" type="integer" required="True"
      ucd="meta.id"
      description="index to identify granule and provide direct access"/>
    <column name="dataproduct_type"  type="text" 
      ucd="meta.id;class" 
      description="Organization of the data product, from enumerated list"/>
    <column name="target_name"  type="text" 
      ucd="meta.id;src" 
      description="name of target (from a list depending on target type)"/>
    <column name="target_class"  type="text" 
      ucd="src.class" 
      description="type of target from enumerated list"/>
    <column name="time_min"   type="double precision"
      ucd="time.start" unit="d" 
      description="Acquisition start time (in JD)"/>
    <column name="time_max"   type="double precision"
      ucd="time.end" unit="d"
      description="Acquisition stop time (in JD)"/>
    <column name="time_sampling_step_min"   type="double precision"
     ucd="time.interval;stat.min"  unit="s"
      description="Min time sampling step"/>
    <column name="time_sampling_step_max"  type="double precision"
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
      description="Min spectral range (frequency)"/>
    <column name="spectral_range_max"   type="double precision"
      ucd="em.freq;stat.max" unit="Hz"
      description="Max spectral range (frequency)"/>
    <column name="spectral_sampling_step_min"   type="double precision"
      ucd="em.freq.step;stat.min" unit="Hz"
      description="min spectral sampling step"/>
    <column name="spectral_sampling_step_max"   type="double precision"
      ucd="em.freq.step;stat.max" unit="Hz"
      description="max pectral sampling step"/>
    <column name="spectral_resolution_min"   type="double precision"
      ucd="spec.resolution;stat.min" unit="Hz"
      description="Min spectral resolution"/>
    <column name="spectral_resolution_max"   type="double precision"
      ucd="spec.resolution;stat.max" unit="Hz"
      description="Max spectral resolution"/>
    <column name="c1min"   type="double precision"
      ucd="obs.field;stat.min" unit="deg"
      description="longitude min on planetary surface"/>
    <column name="c1max"   type="double precision"
      ucd="obs.field;stat.max" unit="deg"
      description="longitude max on planetary surface"/>
    <column name="c2min"   type="double precision"
      ucd="obs.field;stat.min" unit="deg"
      description="latitude min on planetary surface"/>
    <column name="c2max"   type="double precision"
      ucd="obs.field;stat.max" unit="deg"
      description="latitude max on planetary surface"/>
    <column name="c3min"   type="double precision"
      ucd="obs.field;stat.min" unit=""
      description="Min of third coordinate (not used)"/>
    <column name="c3max"   type="double precision"
      ucd="obs.field;stat.max" unit=""
      description="Max of third coordinate (not used)"/>
    <column name="c1_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution on longitude"/>
    <column name="c1_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution on longitude"/>
    <column name="c2_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit="deg"
      description="Min resolution on latitude"/>
    <column name="c2_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit="deg"
      description="Max resolution on latitude"/>
    <column name="c3_resol_min"   type="double precision"
      ucd="pos.resolution;stat.min" unit=""
      description="Min resolution in third coordinate"/>
    <column name="c3_resol_max"   type="double precision"
      ucd="pos.resolution;stat.max" unit=""
      description="Max resolution in third coordinate"/>
    <column name="spatial_frame_type"  type="text" 
      ucd="pos.frame" 
      description="Flavor of coordinate system, defines the nature of coordinates (enumerated list)"/>
    <column name="incidence_min"  unit="deg"  type="double precision"
      ucd="pos.incidenceAng;stat.min"
      description="Min incidence angle (solar zenithal angle)"/>
    <column name="incidence_max"  unit="deg"  type="double precision"
      ucd="pos.incidenceAng;stat.max"
      description="Max incidence angle (solar zenithal angle) "/>
    <column name="emergence_min"  unit="deg"  type="double precision"
      ucd="pos.emergenceAng;stat.min"
      description="Min emergence angle"/>
    <column name="emergence_max"  unit="deg"  type="double precision"
      ucd="pos.emergenceAng;stat.max"
      description="Max emergence angle"/>
    <column name="phase_min"  unit="deg"  type="double precision"
      ucd="pos.phaseAng;stat.min"
      description="Min phase angle"/>
    <column name="phase_max"  unit="deg"  type="double precision"
      ucd="pos.phaseAng;stat.max"
      description="Max phase angle"/>
    <column name="instrument_host_name"  type="text" 
      ucd="meta.class" 
      description="Standard name of the observatory or spacecraft"/>
    <column name="instrument_name"  type="text" 
      ucd="meta.id;instr" 
      description="Standard name of instrument"/>
    <column name="measurement_type"  type="text" 
      ucd="meta.ucd" 
      description="UCD(s) defining the data"/>
    <column name="access_url"  type="text" 
      ucd="meta.ref.url" 
      description="URL of the data files."/>
    <column name="access_format"  type="text"
      ucd="meta.id;class" 
      description="file format type."/>
    <column name="access_estsize"  type="integer" required="True"
      ucd="phys.size;meta.file"
      description="estimate file size in kB."/>
    <column name="processing_level"  type="integer" required="True"
      ucd="meta.code;obs.calib" 
      description="type of calibration from CODMAC."/>
    <column name="publisher"  type="text" 
      ucd="meta.name" 
      description="publiher of the ressource"/>
    <column name="reference"  type="text" 
      ucd="meta.ref" 
      description="publication of reference"/>
    <column name="service_title"  type="text" 
      ucd="meta.note" 
      description="Title of the ressourcee"/>
    <column name="target_region"  type="text" 
      ucd="meta.id;class" 
      description="region of interest from a predifine list"/>
    <column name="instrument_type"  type="text" 
      ucd="meta.id;instr" 
      description="type of instrument"/>
    <column name="time_scale"  type="text" 
      ucd="time.scale" 
      description="time scale taken from STC"/>
</table>


 <data id="import">
    <make table="epn_core"/>
  </data>

<data id="collection" auto="false">
        <register services="__system__/tap#run"/>
        <make table="epn_core"/>
</data>
</resource>
