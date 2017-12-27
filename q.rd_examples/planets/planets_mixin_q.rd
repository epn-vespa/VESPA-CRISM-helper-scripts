<resource schema="planets">
  <meta name="title">Characteristics of Planets (demo)</meta>
  <meta name="description" format="plain">
Main characteristics of planets. Data are included in the table, therefore most relevant parameters are non-standard in EPN-TAP. Data are retrieved from Archinal et al 2009 (IAU report, 2011CeMDA.109..101A) [radii] and Cox et al 2000 (Allen's astrophysical quantities, 2000asqu.book.....C) [masses, heliocentric distances, and rotation periods]. </meta>
  <meta name="creationDate">2015-08-16T09:42:00Z</meta>
  <meta name="subject">planet</meta>
  <meta name="subject">mass</meta>
  <meta name="subject">radius</meta>
  <meta name="subject">period</meta>
  <meta name="copyright">LESIA-Obs Paris</meta>
  <meta name="creator.name">Stephane Erard</meta>
  <meta name="publisher">Paris Astronomical Data Centre - LESIA</meta>
  <meta name="contact.name">Stephane Erard</meta>
  <meta name="contact.email">vo.paris@obspm.fr</meta>
  <meta name="contact.address">Observatoire de Paris VOPDC, bat. Perrault, 77 av. Denfert Rochereau, 75014 Paris, FRANCE</meta>
  <meta name="source">2000asqu.book.....C</meta>
  <meta name="contentLevel">General</meta>
  <meta name="contentLevel">University</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="contentLevel">Amateur</meta>
  <meta name="utype">ivo://vopdc.obspm/std/EpnCore#schema-2.0</meta>



<!-- METADATA COMPLETE -->

	<table id="epn_core" onDisk="true" adql="True">
		<mixin spatial_frame_type="celestial"
		optional_columns= "time_scale publisher bib_reference" >//epntap2#table-2_0</mixin>


	    <column name="distance_to_primary"  type="double precision"
			tablehead="Distance_to_primary"  unit="km"
      		description="Extra: Mean heliocentric distance (semi-major axis)"
     	 	ucd="pos.distance;stat.min" 
			verbLevel="2"/>

	    <column name="mean_radius"    type="double precision" 
			tablehead="Mean_radius"  unit="km"
      		description="Extra: Mean radius (1 bar level on giant planets)"
      		ucd="phys.size.radius"
			verbLevel="2"/>

	    <column name="mean_radius_uncertainty"    type="double precision" 
			tablehead="Mean_radius_uncertainty"  unit="km"
      		description="Extra: Uncertainty on mean radius"
      		ucd="phys.size.radius;stat.error"
			verbLevel="2"/>

	    <column name="equatorial_radius"    type="double precision" 
			tablehead="Equatorial_radius"  unit="km"
      		description="Extra: equatorial radius (1 bar level on giant planets)"
      		ucd="phys.size.radius"
			verbLevel="2"/>

	    <column name="equatorial_radius_uncertainty"    type="double precision" 
			tablehead="Equatorial_radius_uncertainty"  unit="km"
      		description="Extra: Uncertainty on equatorial radius"
      		ucd="phys.size.radius;stat.error"
			verbLevel="2"/>

	    <column name="polar_radius"    type="double precision" 
			tablehead="Polar_radius"  unit="km"
      		description="Extra: polar radius (1 bar level on giant planets)"
      		ucd="phys.size.radius"
			verbLevel="2"/>

	    <column name="polar_radius_uncertainty"    type="double precision" 
			tablehead="Polar_radius_uncertainty"  unit="km"
      		description="Extra: Uncertainty on polar radius"
      		ucd="phys.size.radius;stat.error"
			verbLevel="2"/>

	    <column name="rms_deviation"    type="double precision" 
			tablehead="RMS_deviation"  unit="km"
      		description="Extra: Average departure from ellipsoid"
      		ucd="phys.size.radius;stat.stdev"
			verbLevel="2"/>

	    <column name="elevation_min"    type="double precision" 
			tablehead="Elevation_min"  unit="km"
      		description="Deepest depression relative to ellipsoid"
		    ucd="pos.bodyrc.alt;stat.min"
			verbLevel="2"/>

	    <column name="elevation_max"    type="double precision" 
			tablehead="Elevation_max"  unit="km"
      		description="Highest relief relative to ellipsoid"
		    ucd="pos.bodyrc.alt;stat.max"
			verbLevel="2"/>

	    <column name="mass"    type="double precision" 
			tablehead="Mass"  unit="kg"
      		description="Mass of planet"
	   		ucd="phys.mass"
			verbLevel="2"/>

	    <column name="sideral_rotation_period"    type="double precision" 
			tablehead="Sideral_rotation_period"  unit="h"
      		description="Rotation period (internal for giant planets)"
      		ucd="time.period.rotation"
			verbLevel="2"/>

	</table>

<!-- TABLE COMPLETE -->

	<data id="import">
		<sources>data/Masses2.csv</sources>
		<csvGrammar>
			<rowfilter procDef="//products#define">
				<bind name="table">"\schema.epn_core"</bind>
			</rowfilter>
		</csvGrammar>

		<make table="epn_core">
			<rowmaker idmaps="*">
				<var key="dataproduct_type">"ci"</var>
				<var key="spatial_frame_type">"celestial"</var>

				<var key="target_name" source="target_name" />
				<var key="granule_uid" source="target_name" />
				<var key="granule_gid">"Planet" </var>
				<var key="obs_id" source="obs_id" />
				<!--  <var key="target_class">"planet" </var> -->
				<!--  <var key="time_scale">"UTC" </var> -->


				<var key="distance_to_primary" source="distance_to_primary" />

				<var key="creation_date">"2015-08-20T07:54:00.00" </var>
				<var key="modification_date">"2017-12-15T17:54:00.00" </var>
				<var key="release_date">"2015-08-20T07:54:00.00" </var>

				<var key="service_title">"planets" </var>
				<var key="bib_reference">"2011CeMDA.109..101A#2000asqu.book.....C"</var>
				<var key="publisher">"LESIA" </var>


				<apply procDef="//epntap2#populate-2_0" name="fillepn">
					<bind name="granule_gid">@granule_gid</bind>
					<bind name="granule_uid">@granule_uid</bind>
					<bind name="obs_id">@obs_id</bind>
					<bind name="target_class">"planet"</bind>
					<bind name="time_scale">"UTC"</bind>

					<bind name="target_name">@target_name</bind>
					<!--  <bind name="access_format">""</bind> -->
					<bind name="instrument_host_name">""</bind>
					<bind name="instrument_name">""</bind>


					<bind key="processing_level">5</bind>

					<bind name="dataproduct_type">@dataproduct_type</bind>
					<bind name="measurement_type">"phys.mass#phys.size.radius"</bind>


					<bind name="service_title">@service_title</bind>
					<bind name="creation_date">@creation_date</bind>
					<bind name="modification_date">@modification_date</bind>
					<bind name="release_date">@release_date</bind>

				</apply>
			</rowmaker>
		</make>
	</data>
</resource>
