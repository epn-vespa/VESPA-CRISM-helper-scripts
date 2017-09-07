<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="bdip">
  <meta name="title">Planetary Images Database</meta>
  <meta name="creationDate">2017-06-14T18:00:00Z</meta>
  <meta name="description" format="plain">
*** One Century of Planetary Images ***

The database of planetary images (BDIP) comes from the digitization of photographs 
collected and preserved by the Center for Photographic Documentation of the planets 
held by the IAU at the Meudon Observatory in 1961 under the the curation of J.H. Focas 
(IAUC, 12th General Assembly, Report 1964). A similar center was established at the 
Lowell Observatory in Arizona, under the responsibility of W.A. Baum. The photographs 
were duplicated between the two centers.

Approximately 8400 photographs of Mars, Venus, Mercury, Jupiter and Saturn, acquired 
between 1890 and 1977, are kept at LESIA. They remain available for research on 
justified request. The digitization of these planetary photographs was performed by 
scanning between 1998 and 2000 by the staff of the Documentation Center (R. Boyer, 
E. Neyvoz et al), in the framework of a project proposed to the Scientific Council 
of the Paris Observatory by P. Drossart. Care was taken to preserve the best possible 
definition and photometric linearity of photographs during the scanning procedure. 
Storage was done using different image formats (JPEG, GIF and TIFF ie, lossy, lossless 
and uncompressed). Improved techniques for mass storage and network distribution today 
allow us to provide access to the highest definition images, thereby facilitating 
research on the evolution of planets, at asecular time scale.

*** Scientific interest ***

The scientific interest of the photographic database mainly concerns planetary 
atmospheric evolution of Mars, Jupiter, Saturn and Venus. The evolution of the Martian 
storms, or the polar caps on Mars, the survey of storms observed on Saturn, or features 
like the Great Red Spot of Jupiter or oval white spots are among the subjects which 
triggered on photographs. Such studies can be refined today thanks to digital pictures 
(Sanchez-Lavega and Battaner, A and A Suppl. Ser., 64, 287, 1986). Some images of 
Mercury are also available.
  </meta>
  <meta name="copyright">This research have been made using BDIP database by 
    P. Drossard and F. Henri Lesia-Observatoire de Paris</meta>
  <meta name="creator.name">Pierre Drossart</meta>
  <meta name="contact.name">Florence Henry</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="contact.address">Observatoire de Paris PADC, 5 place Jules Jansen, 92195 Meudon, France</meta>
  <meta name="contributor.name">Pierre Le Sidaner</meta>
  <meta name="contributor.name">Baptiste Cecconi</meta>
  
  <meta name="subject">Jupiter</meta>
  <meta name="subject">Saturn</meta>
  <meta name="subject">Mars</meta>
  <meta name="subject">Venus</meta>
  <meta name="subject">Mercury</meta>
  
  <meta name="referenceURL">http://www.lesia.obspm.fr/BDIP/bdip.php?PLACE=aff_presentation&amp;LANG=en</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="contentLevel">Amateur</meta>

  <mixinDef id="planet_table">
    <doc>
      <![CDATA[This mixin defines a generic table for eache planet database of BDIP.]]>
    </doc>
    <events>
      <adql>True</adql>
      <onDisk>True</onDisk>
      <primary>index</primary>
      <stc>Position ICRS "RA" "dec"</stc>
      <column name="index" type="integer" ucd="meta.id" description="Index"/>
      <column name="observatoire" type="text" ucd="meta.name" description="Observatory Name"/>
      <column name="code_obs" type="text" ucd="meta.id;instr" description="Observatory Code"/>
      <column name="incertitude_obs" type="text" ucd="meta.code.class" description="Uncertain Observatory Name"/>
      <column name="date_heure" type="timestamp" ucd="time.epoch" description="Observation Date and Time"/>
      <column name="observateurs" type="text" ucd="meta.name" description="Observer Names"/>
      <column name="instrument" type="text" ucd="meta.id" description="Instrument Name"/>
      <column name="diametre" type="double precision" ucd="pos.angDistance" description="Target Diameter" unit="arcsec"/>
      <column name="LCM1" type="double precision" unit="deg" description="Central Meridian Longitude" ucd="pos.bodyrc.lon"/>
      <column name="LCM2" type="double precision" unit="deg" description="Central Meridian Longitude" ucd="pos.bodyrc.lon"/>
      <column name="DE" type="double precision" unit="deg" description="DE" ucd=""/>
      <column name="PHA" type="double precision" unit="deg" description="PHA" ucd=""/>
      <column name="L" type="double precision" unit="deg" description="Lambda" ucd=""/>
      <column name="filtre" type="text" description="Filter name" ucd="meta.id;instr"/>
      <column name="nb_images" type="integer" description="Number of images" ucd="meta.number;obs"/>
      <column name="commentaire" type="text" description="Comment" ucd="meta.comment"/>
      <column name="lien_image" type="text" description="Link to image" ucd="meta.ref.url"/>
      <column name="RA" type="double precision" description="Right Ascension" ucd="pos.eq.ra"/>
      <column name="dec" type="double precision" description="Declination" ucd="pos.eq.dec"/>
      <column name="target_dist" type="double precision" description="Distance" ucd="pos.distance" unit="au"/>
      <column name="phase" type="double precision" description="Phase" ucd="pos.posAng" unit="deg"/>
      <column name="solar_elongation" type="double precision" description="Solar Elongation" unit="deg" ucd=""/>
      <column name="julian_date" type="double precision" description="Julian date" ucd="time.epoch" unit="d"/>
    </events>
  </mixinDef>
  
  <table id="mercure">
    <meta name="description">Mercury data table</meta>
    <mixin>planet_table</mixin>
  </table>

  <table id="venus">
    <meta name="description">Venus data table</meta>
    <mixin>planet_table</mixin>
  </table>

  <table id="mars">
    <meta name="description">Mars data table</meta>
    <mixin>planet_table</mixin>
  </table>
 
  <table id="jupiter">
    <meta name="description">Jupiter data table</meta>
    <mixin>planet_table</mixin>
  </table>
  
  <table id="saturne">
    <meta name="description">Saturn data table</meta>
    <mixin>planet_table</mixin>
  </table>
  
  <table id="observatoires" adql="True" onDisk="True" primary="id">
    <meta name="description">Observatory data table</meta>
    <column name="id" type="integer" description="Index" ucd="meta.id"/>
    <column name="code_obs" type="text" description="Observatory code" ucd="meta.id"/>
    <column name="nom_obs" type="text" description="Observatory name" ucd="meta.name"/>
    <column name="siteweb" type="text" description="Website URL" ucd="meta.ref.url"/>
    <column name="code_uai" type="text" description="IAU observatory code" ucd="meta.id"/>
  </table>

  <table id="epn_core" onDisk="True" adql="True">
    <mixin spatial_frame_type="body" optional_columns="access_url access_format access_estsize time_scale file_name
      thumbnail_url publisher bib_reference">//epntap2#table-2_0</mixin>
    <meta name="description">Planetary Images Database</meta>
    <column name="ra" ucd="pos.eq.ra;meta.main" description="right ascention"/>
    <column name="dec" ucd="pos.eq.dec;meta.main" description="declination"/>
    
    <viewStatement>
      CREATE VIEW \curtable AS SELECT
      REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(filename,'.*/', ''),'.jpg',''),'.TIF','_tif')::text as granule_uid,  
      REGEXP_REPLACE(REGEXP_REPLACE(SUBSTR(filename,length(filename) - 2,3),'jpg','preview'),'TIF','full_resolution')::text AS granule_gid,  
      lower(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(filename,'.*/', ''),'.TIF',''),'.jpg',''))::text  AS obs_id,
      TEXT 'im'       as dataproduct_type,
      regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(target , 'jupiter','Jupiter'), 'saturn', 'Saturn'), 'mercury', 'Mercury'), 'mars', 'Mars'), 'venus', 'Venus')::text  as target_name,
      TEXT 'planet'   as target_class,
      cast(julian_date as double precision)  as time_min,
      cast(julian_date as double precision)  as time_max,
      CAST(NULL AS DOUBLE PRECISION)                 as time_sampling_step_min,      
      CAST(NULL AS DOUBLE PRECISION)                 as time_sampling_step_max,      
      CAST(NULL AS DOUBLE PRECISION)                 as time_exp_min,
      CAST(NULL AS DOUBLE PRECISION)                 as time_exp_max,
      CAST(NULL AS DOUBLE PRECISION)                 as spectral_range_min,
      CAST(NULL AS DOUBLE PRECISION)                 as spectral_range_max,
      CAST(NULL AS DOUBLE PRECISION)                 as spectral_sampling_step_min,
      CAST(NULL AS DOUBLE PRECISION)         as spectral_sampling_step_max,
      CAST(NULL AS DOUBLE PRECISION)         as spectral_resolution_min,
      CAST(NULL AS DOUBLE PRECISION)         as spectral_resolution_max,
      CAST(NULL AS DOUBLE PRECISION)         as c1min,
      CAST(NULL AS DOUBLE PRECISION)         as c1max,
      CAST(NULL AS DOUBLE PRECISION)         as c2min,
      CAST(NULL AS DOUBLE PRECISION)         as c2max,
      CAST(NULL AS DOUBLE PRECISION)         as c3min,
      CAST(NULL AS DOUBLE PRECISION)         as c3max,
      CAST(NULL AS DOUBLE PRECISION)         as c1_resol_min,
      CAST(NULL AS DOUBLE PRECISION)         as c1_resol_max,
      CAST(NULL AS DOUBLE PRECISION)         as c2_resol_min,
      CAST(NULL AS DOUBLE PRECISION)         as c2_resol_max,
      CAST(NULL AS DOUBLE PRECISION)         as c3_resol_min,
      CAST(NULL AS DOUBLE PRECISION)         as c3_resol_max,
      TEXT 'body' as spatial_frame_type,
      CAST(NULL AS DOUBLE PRECISION)   as incidence_min,
      CAST(NULL AS DOUBLE PRECISION)   as incidence_max,
      CAST(NULL AS DOUBLE PRECISION)   as emergence_min,
      CAST(NULL AS DOUBLE PRECISION)   as emergence_max,
      CAST(NULL AS DOUBLE PRECISION)   as phase_min,
      CAST(NULL AS DOUBLE PRECISION)   as phase_max,
      CAST("code_uai" AS TEXT) as instrument_host_name,
      instrument::text as instrument_name,
      TEXT 'obs.image'                as measurement_type,
      CASE SUBSTR(filename,length(filename) - 2,3)
      when 'TIF' then TEXT 'http://www.lesia.obspm.fr/BDIP/bdip_tif/' || upper(regexp_replace(lien_image, '.jpg', '.tif'))::text 
      when 'jpg' then TEXT 'http://www.lesia.obspm.fr/BDIP/bdip_jpeg/' || lien_image::text  
      ELSE CAST(NULL AS TEXT) END 
      as access_url,
      CASE SUBSTR(filename,length(filename) - 2,3)
      when 'TIF' then TEXT 'image/tiff'
      when 'jpg' then TEXT 'image/jpeg'
      ELSE CAST(NULL AS TEXT) END 
      as access_format,
      filesize as access_estsize,
      filename as file_name,
      CAST (NULL AS TEXT) AS bib_reference,
      integer '3'                     as processing_level,
      TEXT 'LESIA - Observatoire de Paris' as publisher,
      TEXT 'BDIP'             as service_title,
      --      TEXT 'ADU' as units_expression,
      --      CAST(NULL AS TEXT)              as units_scalesi,
      --      TEXT 'Wm-2'             as units_dimequation,
      --      TEXT 'planet'   as target_region,
      --      TEXT 'Planetographic coordinates' as spatial_coordinate_description,
      --      TEXT 'Planetocenter' as spatial_origin,
      ra::double precision as ra,
      dec::double precision as dec,
      CAST('2007-11-23T08:42:00Z' as timestamp) as release_date,
      CAST(date_heure AS timestamp) AS creation_date,
      CAST('2007-11-23T08:42:00Z' as timestamp) AS modification_date,
      CAST('UTC' as text) AS time_scale,
      CAST(NULL AS spoly) AS s_region,
      TEXT 'http://www.lesia.obspm.fr/BDIP/bdip_icone/' || lien_image  as thumbnail_url
      FROM \schema.data
      LEFT OUTER JOIN \schema.observatoires ON \schema.data.code_obs = \schema.observatoires.code_obs
      LEFT OUTER JOIN \schema.files ON \schema.data.index = \schema.files.index
    </viewStatement>  
  </table>

  <table id="files" onDisk="True" adql="True">
    <meta name="description">File table</meta>
    <column name="index" description="Index" ucd="meta.id" type="integer"/>
    <column name="format" description="File format" ucd="meta.code.mime" type="text"/>
    <column name="filename" description="File name" ucd="meta.name" type="text"/>
    <column name="filesize" description="File size" ucd="phys.size;meta.file" type="double precision" unit="kbyte"/>
  </table>

  <table id="data" adql="True" onDisk="True">
    <meta name="description">BDIP all data table</meta>
    <mixin>planet_table</mixin>
    <column name="target" description="Target Name" type="text" ucd="meta.id;src"/>
    <viewStatement>
      CREATE VIEW \curtable AS (
        SELECT 'Jupiter' as target, 
          index as index, 
          observatoire as observatoire,
          code_obs as code_obs,
          incertitude_obs as incertitude_obs,
          date_heure as date_heure,
          observateurs as observateurs,
          instrument as instrument,
          diametre as diametre,
          LCM1 as LCM1,
          LCM2 as LCM2,
          DE as DE,
          PHA as PHA,
          L as L,
          filtre as filtre,
          nb_images as nb_images,
          commentaire as commentaire,
          lien_image as lien_image,
          RA as RA,
          Dec as Dec,
          target_dist as target_dist,
          phase as phase,
          solar_elongation as solar_elongation,
          julian_date as julian_date
        FROM bdip.jupiter) UNION (
        SELECT 'Mars' as target, 
          index as index, 
          observatoire as observatoire,
          code_obs as code_obs,
          incertitude_obs as incertitude_obs,
          date_heure as date_heure,
          observateurs as observateurs,
          instrument as instrument,
          diametre as diametre,
          LCM1 as LCM1,
          LCM2 as LCM2,
          DE as DE,
          PHA as PHA,
          L as L,
          filtre as filtre,
          nb_images as nb_images,
          commentaire as commentaire,
          lien_image as lien_image,
          RA as RA,
          Dec as Dec,
          target_dist as target_dist,
          phase as phase,
          solar_elongation as solar_elongation,
          julian_date as julian_date
        FROM bdip.mars) UNION (
        SELECT 'Mercury' as target, 
          index as index, 
          observatoire as observatoire,
          code_obs as code_obs,
          incertitude_obs as incertitude_obs,
          date_heure as date_heure,
          observateurs as observateurs,
          instrument as instrument,
          diametre as diametre,
          LCM1 as LCM1,
          LCM2 as LCM2,
          DE as DE,
          PHA as PHA,
          L as L,
          filtre as filtre,
          nb_images as nb_images,
          commentaire as commentaire,
          lien_image as lien_image,
          RA as RA,
          Dec as Dec,
          target_dist as target_dist,
          phase as phase,
          solar_elongation as solar_elongation,
          julian_date as julian_date
        FROM bdip.mercure) UNION (
        SELECT 'Saturn' as target, 
          index as index, 
          observatoire as observatoire,
          code_obs as code_obs,
          incertitude_obs as incertitude_obs,
          date_heure as date_heure,
          observateurs as observateurs,
          instrument as instrument,
          diametre as diametre,
          LCM1 as LCM1,
          LCM2 as LCM2,
          DE as DE,
          PHA as PHA,
          L as L,
          filtre as filtre,
          nb_images as nb_images,
          commentaire as commentaire,
          lien_image as lien_image,
          RA as RA,
          Dec as Dec,
          target_dist as target_dist,
          phase as phase,
          solar_elongation as solar_elongation,
          julian_date as julian_date
        FROM bdip.saturne) UNION (
        SELECT 'Venus' as target, 
          index as index, 
          observatoire as observatoire,
          code_obs as code_obs,
          incertitude_obs as incertitude_obs,
          date_heure as date_heure,
          observateurs as observateurs,
          instrument as instrument,
          diametre as diametre,
          LCM1 as LCM1,
          LCM2 as LCM2,
          DE as DE,
          PHA as PHA,
          L as L,
          filtre as filtre,
          nb_images as nb_images,
          commentaire as commentaire,
          lien_image as lien_image,
          RA as RA,
          Dec as Dec,
          target_dist as target_dist,
          phase as phase,
          solar_elongation as solar_elongation,
          julian_date as julian_date
        FROM bdip.venus) 
      ORDER by index, date_heure;
    </viewStatement>
  </table>
  
  <data id="import" auto="true">
    <sources pattern="data/bdip_tables.txt"/>
    <customGrammar isDispatching="True" module="res/get_metadata"/>

    <rowmaker id="make_bdip_tables" idmaps='*'/>
        
    <make table="mercure" rowmaker="make_bdip_tables" role="bdip_mercure"/>
    <make table="mars" rowmaker="make_bdip_tables" role="bdip_mars"/>
    <make table="venus" rowmaker="make_bdip_tables" role="bdip_venus"/>
    <make table="jupiter" rowmaker="make_bdip_tables" role="bdip_jupiter"/>
    <make table="saturne" rowmaker="make_bdip_tables" role="bdip_saturne"/>
    <make table="observatoires" rowmaker="make_bdip_tables" role="observatoires"/>
    <make table="files" rowmaker='make_bdip_tables' role="bdip_files"/>
  
    <make table="data"/>
 
    <make table="epn_core"/>
  
  </data>
    
</resource>

