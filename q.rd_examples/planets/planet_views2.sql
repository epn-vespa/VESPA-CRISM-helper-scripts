-- SQL procedure to define the planets service view for EPN-TAP v2

-- Stephane Erard, LESIA/OVPDC, June 2016 (hand-written from v1 and VVEx v2 examples)
-- Can be used as a template for other light services 
-- Use a single granule group




CREATE OR REPLACE VIEW planets.epn_core AS SELECT
	CAST(target  AS TEXT)						AS granule_uid,
	TEXT 'Planet'							 	AS granule_gid,
	CAST(id AS TEXT)						 	AS obs_id,

	TEXT 'ca'  									AS dataproduct_type,
	CAST(target AS TEXT)	 					AS target_name,
	TEXT 'planet'								AS target_class,

	cast(NULL AS DOUBLE PRECISION) 		AS time_min,
	cast(NULL AS DOUBLE PRECISION)	 	AS time_max,
	TEXT 'UTC' 							AS time_scale,


	CAST(NULL AS DOUBLE PRECISION)		AS time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)		AS time_sampling_step_max,
	CAST(NULL AS DOUBLE PRECISION)  			AS  time_exp_min,
	CAST(NULL AS DOUBLE PRECISION) 				AS  time_exp_max,
	CAST(NULL AS DOUBLE PRECISION) 		AS  spectral_range_min,
	CAST(NULL AS DOUBLE PRECISION) 		AS  spectral_range_max,	
	CAST(NULL AS DOUBLE PRECISION)		AS spectral_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)		AS spectral_sampling_step_max,

	CAST(NULL AS DOUBLE PRECISION)	AS spectral_resolution_min,
	CAST(NULL AS DOUBLE PRECISION)	AS spectral_resolution_max,
	CAST(NULL AS DOUBLE PRECISION)				AS c1min,
	CAST(NULL AS DOUBLE PRECISION)				AS c1max,
	CAST(NULL AS DOUBLE PRECISION)				AS c2min,
	CAST(NULL AS DOUBLE PRECISION)	 			AS c2max,
	CAST(NULL AS DOUBLE PRECISION)				AS c3min,
	CAST(NULL AS DOUBLE PRECISION)				AS c3max,
	CAST(NULL AS DOUBLE PRECISION)				AS c1_resol_min,
	CAST(NULL AS DOUBLE PRECISION)				AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)				AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)				AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)				AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)				AS c3_resol_max,
	TEXT 'celestial'					 	AS spatial_frame_type,
	TEXT 'Sun' 								AS spatial_origin,
	CAST(NULL AS TEXT) 							AS s_region,
	CAST(NULL AS DOUBLE PRECISION) 		as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) 		as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) 		as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) 		as emergence_max,
	CAST(NULL AS DOUBLE PRECISION) 		as phase_min,
	CAST(NULL AS DOUBLE PRECISION) 		as phase_max,
	CAST(NULL AS TEXT)							AS  instrument_host_name,
	CAST(NULL AS TEXT)						 	AS  instrument_name,
	TEXT 'phys.mass#phys.size.radius' 		AS  measurement_type,
	
--	CAST(Mean_Dist AS DOUBLE PRECISION)		 	AS target_distance_min,
--	CAST(Mean_Dist AS DOUBLE PRECISION)		 	AS target_distance_max,
	CAST(Mean_Dist/149597870.7 AS DOUBLE PRECISION)		 AS semi_major_axis,
	CAST(Mean_rad AS DOUBLE PRECISION) 			AS Mean_radius,
	CAST(Mean_rad_unc AS DOUBLE PRECISION) 		AS Mean_radius_uncertainty,
	CAST(Eq_rad AS DOUBLE PRECISION) 			AS Equatorial_radius,
	CAST(Eq_rad_unc AS DOUBLE PRECISION) 		AS Equatorial_radius_uncertainty,
	CAST(Polar_Rad AS DOUBLE PRECISION) 		AS Polar_radius,
	CAST(Polar_Rad_Unc AS DOUBLE PRECISION) 	AS Polar_radius_uncertainty,
	CAST(Rms_Dev AS DOUBLE PRECISION) 			AS RMS_deviation,
	CAST(Min_Elev AS DOUBLE PRECISION) 			AS Elevation_Min,
	CAST(Max_Elev AS DOUBLE PRECISION) 			AS Elevation_Max,
	CAST(Mass AS DOUBLE PRECISION) 				AS Mass,
	CAST(Rotation AS DOUBLE PRECISION) 			AS Sideral_rotation_period,

	TEXT '2011CeMDA.109..101A#2000asqu.book.....C' 		AS bib_reference,
	DATE '2015-08-20T07:54:00.00+00:00'		AS  creation_date,		
	DATE '2015-08-20T07:54:00.00+00:00'		AS  modification_date,
	DATE '2015-08-20T07:54:00.00+00:00'		AS  release_date,
	TEXT 'Planets'  								AS  service_title,
	integer '5'											AS processing_level
FROM planets.data_table;

	

--GRANT ALL PRIVILEGES ON SCHEMA public TO gavo WITH GRANT OPTION;
--GRANT ALL PRIVILEGES ON SCHEMA public TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON planets.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON planets.epn_core to gavo WITH GRANT OPTION; 


