<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="exoplanet">
  <meta name="title">Exoplanet Catalog</meta>
  <meta name="creationDate">2012-09-02T08:42:00Z</meta>
  <meta name="description" format="plain"> Encyclopedia of extrasolar planet </meta>
  <meta name="copyright">please make reference to the article decribing catalog </meta>
  <meta name="creator.name">J. Schneider</meta>
  <meta name="subject">Extrasolar planet</meta>
 
  <table id="epn_core" onDisk="True" adql="True">
    <mixin spatial_frame_type="celestial" optional_columns="time_scale publisher bib_reference">//epntap2#table-2_0</mixin>
    <meta name="description"> Encyclopedia of extrasolar planet </meta>

    <column name="target_region"  type="text"
      ucd="meta.id;class"
      description="region of interest from a enumerated list"/>
    <column name="species"  type="text"
      ucd="phys.composition.species"
      description="List of detected molecules"/>
    <column name="detection_type" type="text" 
      ucd="meta.note" 
      description="detection type 1: detected by radial velocity 2: pulsar 3: controversial 4: detected by microlensing 5: detected by imaging 6: detected by transit 7: detected by astrometry 8: TTV 9: Other 10: Spectrum 11: Theorical 12: Flux 13: Secondary Transit 14: IR Excess "/>
    <column name="publication_status" type="text"  
      ucd="meta.code.status" 
      description="Publication status of exoplanet Information about status values : R : planet detections published in Refereed papers.  S : planet detections Submitted to a professional journal.  C : planet detections announced by astronomers in professional Conferences.  W : planet detections announced in Website."/>
    <column name="mass"  
      ucd="phys.mass" unit="'jupiterMass'"
      description="estimated mass of exoplanet expressed in jupMass"/>
    <column name="mass_error_min"  
      ucd="phys.mass;stat.error.min" unit="'jupiterMass'"
      description="estimated mass errir min of exoplanet expressed in jupMass"/>
    <column name="mass_error_max"  
      ucd="phys.mass;stat.error.max" unit="'jupiterMass'"
      description="estimated mass errir max of exoplanet expressed in jupMass"/>
    <column name="radius"   unit="'jupiterRad'" 
      ucd="phys.size.radius" 
      description="estimated radius of exoplanet expessed in jupRad"/>
    <column name="radius_error_min"   unit="'jupiterRad'" 
      ucd="phys.size.radius;stat.error.min" 
      description="estimated exoplanet radius error min expressed in Jupiter Radius"/>
    <column name="radius_error_max"   unit="'jupiterRad'" 
      ucd="phys.size.radius;stat.error.max" 
      description="estimated exoplanet radius error max expressed in Jupiter Radius"/>
    <column name="semi_major_axis" unit="AU"  
      ucd="phys.size.smajAxis" 
      description="estimated semi major axis of exoplanet orbital parameter"/>
    <column name="semi_major_axis_error_min" unit="AU"  
      ucd="phys.size.smajAxis;stat.error.min" 
      description="estimated semi major axis error min of exoplanet orbital parameter "/>
    <column name="semi_major_axis_error_max" unit="AU"  
      ucd="phys.size.smajAxis;stat.error.max" 
      description="estimated semi major axis error max of exoplanet orbital parameter "/>
    <column name="period" unit="d"  
      ucd="src.orbital;time.period" 
      description="estimated orbital period of exoplanet"/>
    <column name="period_error_min" unit="d" 
      ucd="src.orbital;time.period;stat.error.min" 
      description="estimated orbital period error min of exoplanet "/>
    <column name="period_error_max" unit="d" 
      ucd="src.orbital;time.period;stat.error.max" 
      description="estimated orbital period error max of exoplanet "/>
    <column name="eccentricity" unit="AU"  
      ucd="src.orbital.eccentricity" 
      description="estimated eccentricity of exoplanet orbital parameter"/>
    <column name="eccentricity_error_min" unit="AU"  
      ucd="src.orbital.eccentricity;stat.error.min" 
      description="estimated eccentricity error min of exoplanet orbital parameter"/>
    <column name="eccentricity_error_max" unit="AU"  
      ucd="src.orbital.eccentricity;stat.error.max" 
      description="estimated eccentricity error max of exoplanet orbital parameter"/>
    <column name="periastron" unit="deg"  
      ucd="src.orbital.periastron" 
      description="periastron angle omega"/>
    <column name="periastron_error_min" unit="deg"  
      ucd="src.orbital.periastron;stat.error.min" 
      description="periastron angle error min  omega "/>
    <column name="periastron_error_max" unit="deg"  
      ucd="src.orbital.periastron;stat.error.max" 
      description="periastron angle error max  omega "/>
    <column name="tzero_tr" unit="d"  
      ucd="time.epoch" 
      description="time at center of transit"/>
    <column name="tzero_tr_error_min"  unit="d"
      ucd="time.epoch;stat.error.min" 
      description="error min time of transit"/>
    <column name="tzero_tr_error_max" unit="d"
      ucd="time.epoch;stat.error.max" 
      description="error max time of transit"/>
    <column name="tzero_vr"  unit="d" 
      ucd="time.epoch" 
      description="Zero Radial Speed time in Julian day"/>
    <column name="tzero_vr_error_min"  unit="d" 
      ucd="time.epoch" 
      description="Zero Radial Speed time"/>
    <column name="t_peri" unit="d"  
      ucd="time.epoch;src.orbital.periastron" 
      description="time at periastron JD"/>
    <column name="t_peri_error_min" unit="d"  
      ucd="time.epoch;src.orbital.periastron;stat.error.min" 
      description="time at periastron error min"/>
    <column name="t_peri_error_max" unit="d"  
      ucd="time.epoch;src.orbital.periastron;stat.error.max" 
      description="time at periastron error max"/>
    <column name="t_conj" unit="d"  
      ucd="time.epoch" 
      description="time at conjunction"/>
    <column name="t_conj_error_min" unit="d" 
      ucd="time.epoch;stat.error.min" 
      description="time at conjunction error min"/>
    <column name="t_conj_error_max" unit="d" 
      ucd="time.epoch;stat.error.max" 
      description="time at conjunction error max"/>
    <column name="inclination" unit="deg"  
      ucd="src.orbital.inclination" 
      description="estimated angular inclination exoplanet orbital parameter"/>
    <column name="inclination_error_min" unit="deg" 
      ucd="src.orbital.inclination;stat.error.min" 
      description="estimated angular inclination error min on exoplanet orbital parameter "/>
    <column name="tzero_tr_sec" unit="d"  
      ucd="time.epoch" 
      description="time at center of secondary transit in JD"/>
    <column name="tzero_tr_sec_error_min" unit="d" 
      ucd="time.epoch;stat.error.min" 
      description="min error time of secondary transit"/>
    <column name="tzero_tr_sec_error_max" unit="d" 
      ucd="time.epoch;stat.error.max" 
      description="max error time of secondary transit"/>
    <column name="lambda_angle" unit="deg"  
      ucd="pos.posAng" 
      description="Sky-projected anomaly angle"/>
    <column name="lambda_angle_error_min" unit="deg" 
      ucd="pos.posAng;stat.error.min" 
      description="min error in Sky-projected anomaly angle"/>
    <column name="lambda_angle_error_max" unit="deg" 
      ucd="pos.posAng;stat.error.max" 
      description="max error in Sky-projected anomaly angle"/>
    <column name="discovered" type="integer" required="True" 
      ucd="time.publiYear" 
      description="Year of discovery"/>
    <column name="remarks" type="text" 
      ucd="meta.note" 
      description="remarks"/>
    <column name="detect_mode" type="text" 
      ucd="meta.note" 
      description="detection mode web"/>
    <column name="angular_distance" unit="arcsec"  
      ucd="pos.angDistance" 
      description="estimated angular distance exoplanet orbital parameter"/>
    <column name="temp_calculated" unit="K"  
      ucd="phys.temperature" 
      description="Temperature calculated"/>
    <column name="temp_measured" unit="K"  
      ucd="phys.temperature.effective" 
      description="Temperature measured"/>
    <column name="hot_point_lon"   
      ucd="meta.id"  unit='deg'
      description="Longitude of in degrees counted from substellar point"/>
    <column name="log_g"   
      ucd="phys.gravity" 
      description="gravitation expressed in log of terrestrial g"/>
    <column name="albedo"   
      ucd="phys.albedo" 
      description="Geometric albedo "/>
    <column name="albedo_error_min"   
      ucd="phys.albedo;stat.error.min" 
      description="Geometric albedo error min"/>
    <column name="albedo_error_max"   
      ucd="phys.albedo;stat.error.max" 
      description="Geometric albedo error max"/>
    <column name="mass_detection_type"  type="text" 
      ucd="meta.id" 
      description="mass detection type 1: detected by radial velocity 2: pulsar 3: controversial 4: detected by microlensing 5: detected by imaging 6: detected by transit 7: detected by astrometry 8: TTV 9: Other 10: Spectrum 11: Theorical 12: Flux 13: Secondary Transit 14: IR Excess"/>
    <column name="radius_detection_type"  type="text" 
      ucd="meta.id" 
      description="radius detection type 1: detected by radial velocity 2: pulsar 3: controversial 4: detected by microlensing 5: detected by imaging 6: detected by transit 7: detected by astrometry 8: TTV 9: Other 10: Spectrum 11: Theorical 12: Flux 13: Secondary Transit 14: IR Excess"/>
    <column name="mass_sin_i"   
      ucd="phys.mass" unit="'jupiterMass'"
      description="mass function of the orbit inclination  expressed in jupMass"/>
    <column name="mass_sin_i_error_min"  
      ucd="phys.mass;stat.error.min" unit="'jupiterMass'"
      description="mass function of the orbit inclination error min"/>
    <column name="mass_sin_i_error_max"  
      ucd="phys.mass;stat.error.max" unit="'jupiterMass'"
      description="mass function of the orbit inclination error max"/>
    <column name="k" unit="m.s-1" 
      ucd="spect.dopplerVeloc" 
      description="Velocity Semiamplitude K "/>
    <column name="k_error" unit="m.s-1" type="text"
      ucd="spect.dopplerVeloc;stat.error" 
      description="Velocity Semiamplitude K error"/>
    <column name="alternate_name"  type="text"
      ucd="meta.id" 
      description="planet alternate name"/>
    <column name="star_name" type="text" 
      ucd="meta.id" 
      description="name of host star"/>
    <column name="star_distance" unit="pc"  
      ucd="pos.distance" 
      description="distance of the star"/>
    <column name="star_distance_error_min" unit="pc"  type="double precision"
      ucd="pos.distance;stat.error.min" 
      description="Distance of the star error min"/>
    <column name="star_distance_error_max" unit="pc"  type="double precision"
      ucd="pos.distance;stat.error.max" 
      description="Distance of the star error max"/>
    <column name="star_spec_type"  type="text" 
      ucd="src.spType" 
      description="spectral type of the star"/>
    <column name="mag_v"   type="double precision"
      ucd="phot.mag;em.opt.V" 
      description="V magnitude of a host star"/>
    <column name="mag_i"   type="double precision"
      ucd="phot.mag;em.opt.I" 
     description="I magnitude of a host star"/>
    <column name="mag_j"   type="double precision"
      ucd="phot.mag;em.IR.J" 
      description="J magnitude of a host star"/>
    <column name="mag_h"   type="double precision"
      ucd="phot.mag;em.IR.H" 
      description="H magnitude of a host star"/>
    <column name="mag_k"   type="double precision"
      ucd="phot.mag;em.IR.K" 
      description="K magnitude of a host star"/>
    <column name="star_metallicity"   type="double precision"
      ucd="phys.abund.Z" 
      description="Decimal logarithm of the massive elements (« metals ») to hydrogen ratio in solar units  (i.e. Log [(metals/H)star/(metals/H)Sun])"/>
    <column name="star_mass" unit="solMass"  
      ucd="phys.mass" type="double precision" 
      description="Mass of a host star"/>
    <column name="star_radius" unit="solRad"  
      ucd="phys.size.radius" type="double precision" 
      description="Radius of a host star"/>
    <column name="star_sp_type" type="text" 
      ucd="src.spType" 
      description="Spectral type of a host star"/>
    <column name="star_age" unit="Gyr"  
      ucd="time.age" type="double precision" 
      description="Age of a host star"/>
    <column name="star_teff" unit="K"  
      ucd="phys.temperature.effective" type="double precision" 
      description="Effective temperature of a host star"/>
    <column name="detected_disc" type="text"  
      ucd="meta.info" 
      description="(direct imaging or IR excess) disc detected"/>
    <column name="ra" type="double precision" ucd="pos.eq.ra" unit="deg" description="Right ascension of the host star" />
    <column name="dec" type="double precision" ucd="pos.eq.dec" unit="deg" description="Declination of the host star" />
    <column name="external_link" type="text" ucd="meta.ref.url" description="Link to a web page providing more details on the granule." />

</table>

  <data id="import" updating="False" >

    <sources pattern="data/exoplanet_table.txt">
    </sources>
    <customGrammar  module="get_metadata"/>

        
 
    <make table="epn_core">
    	<rowmaker idmaps='*'>
            <map key="target_class">"exoplanet"</map>
            <map key="target_region">"extrasolar planet"</map>
            <map key="granule_gid">"exoplanet_catalog"</map>
            <map key="measurement_type">"phys.size;meta.file#phys.composition.species#phys.mass#phys.mass;stat.error#phys.size.radius#phys.size.radius;stat.error#phys.size.smajAxis#phys.size.smajAxis;stat.error#src.orbital;time.period#src.orbital;time.period;stat.error#src.orbital.eccentricity#src.orbital.eccentricity;stat.error#src.orbital.periastron#src.orbital.periastron;stat.error#time.epoch#time.epoch;src.orbital.periastron#time.epoch;src.orbital.periastron;stat.error#time.epoch;stat.error#src.orbital.inclination#src.orbital.inclination;stat.error#time.publiYear#pos.angDistance#phys.temperature#phys.temperature.effective#phys.gravity#pos.distance#src.spType#phot.mag;em.opt.V#phot.mag;em.opt.I#phot.mag;em.IR.J#phot.mag;em.IR.H#phot.mag;em.IR.K#phys.abund.Z#phys.mass#phys.size.radius#src.spType#time.age#phys.temperature.effective"</map>
            <map key="publisher">"PADC on behalf of LESIA"</map>
            <map key="bib_reference">"http://adsabs.harvard.edu/abs/2011A%26A...532A..79S"</map>
            <map key="service_title">"exoplanet"</map>
            <map key="time_scale">"UTC"</map>
            <map key="processing_level">"5"</map>
            <map key="dataproduct_type">"ci"</map>
            <map key="target_class">"exoplanet"</map>
    	</rowmaker>

    </make>
  
  </data>
    
</resource>

