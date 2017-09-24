<?xml version="1.0" encoding="iso-8859-1"?>

<resource schema="titan">
  <meta name="title">Abundancy Vertical Profile at Titan with Cassini/CIRS</meta>
  <meta name="creationDate">2012-06-05T17:42:00Z</meta>
  <meta name="description" format="plain">
  </meta>
  <meta name="copyright">please put reference to http://adsabs.harvard.edu/abs/2010Icar..205..559V and facilities of VOParis using Europlanet environment</meta>
  <meta name="creator.name">Sandrine Vinatier</meta>
  <meta name="contact.name">Sandrine Vinatier</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="subject">titan atmosphere</meta>

  <table id="epn_core" onDisk="True" adql="True">
    <meta name="description"> temperature pressure and element abundancy in planetary atmosphere.  </meta>
    <meta name="referenceURL">To be define </meta>


        <mixin
          spatial_frame_type="body"
          optional_columns="access_url access_format access_estsize time_scale thumbnail_url species publisher bib_reference target_region"
            >//epntap2#table-2_0</mixin> 
    <column name="local_time"  unit='h' 
      ucd="time.epoch" 
      description="Location of the solar meridian normalized to 24"/>
    <column name="solar_longitude"  unit='deg' 
      ucd="pos.posAngle" 
      description="the Sun-Planet vector angle counted from the planet position at N hemisphere spring equinox"/>
    <column name="accref" type="text" ucd="meta.ref;meta.file" description="File path from local directory."/>

  </table>

<!-- update="True" is to non ingest twice the salle accref
  <data id="import" updating="True">
-->
  <data id="import" updating="False">
        <sources pattern="data/*.txt" recurse="True">
            <ignoreSources fromdb="select accref from titan.epn_core;"/>
        </sources>


        <customGrammar module="get_metadata">
            <rowfilter procDef="//products#define">
                <bind name="table">"\schema.epn_core"</bind>
                <bind key="fsize">int(@access_estsize)*1024</bind>
                <bind key="accref">@accref</bind>
                <bind key="path">@access_url</bind>
                <bind key="mime">@access_format</bind>
            </rowfilter>
        </customGrammar>


        <make table="epn_core">
            <rowmaker idmaps="*">
                <map key="time_min">dateTimeToJdn(parseISODT(@theisotime))</map>
                <map key="time_max">dateTimeToJdn(parseISODT(@theisotime))</map>
                <map key="accref">\inputRelativePath</map>
                <map key="target_class">"satellite"</map>
                <map key="target_name">"Titan"</map>
                <map key="dataproduct_type">"pr"</map>
                <map key="instrument_host_name">"cassini"</map>
                <map key="instrument_name">"Composite Infrared Spectrometer (CIRS)"</map>
                <map key="target_region">"atmosphere"</map>
                <map key="processing_level">5</map>
                <map key="c1min">float(@longitude)</map>
                <map key="c1max">float(@longitude)</map>
                <map key="c2min">float(@latitude)</map>
                <map key="c2max">float(@latitude)</map>
                <map key="s_region">pgsphere.SCircle(pgsphere.SPoint.fromDegrees(float(@longitude), float(@latitude)), 0.001).asPoly()</map>
            </rowmaker>
        </make>
  </data>

<!--   <column name="solar_longitude"  unit='deg' 
      ucd="pos.posAngle" 
      description="the Sun-Planet vector angle counted from the planet position at N hemisphere spring equinox"/>
    <column name="time_scale"  type="text" 
      ucd="time.scale" 
      description="time scale taken from STC"/>
-->


</resource>
