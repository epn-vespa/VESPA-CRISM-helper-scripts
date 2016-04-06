-- SQL procedure to define the IKS service view for EPN-TAP v2
-- Stephane Erard, LESIA/OVPDC, Feb 2016 (adapted from older v1 version, hand-written)
-- Can be used as a template for other light services, especially in spectroscopy 

-- Creates one view per granule group (here, 2 of them), then merge to epn_core view (EPN-TAP v2)


CREATE OR REPLACE VIEW iks.corrected AS SELECT
	CAST(rootname || 'C' AS TEXT)				 AS granule_uid,
	TEXT 'corrected'							 AS granule_gid,
		CAST(rootname AS TEXT)					 AS obs_id,
	TEXT 'sp'  									AS dataproduct_type,
	TEXT '1P'	 								AS target_name,
	CAST(target AS TEXT)						AS alt_target_name,
	TEXT 'comet'								AS target_class,
	CAST(observation_id AS TEXT) 				AS  acquisition_id,			-- renamed to avoid confusions with obs_id
	distance		 							AS  target_distance_min,
	distance		 							AS  target_distance_max,
	sdistance		 							AS  sun_distance,
	edistance		 							AS  earth_distance,
	cast(to_char(time_obs::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_obs::timestamp::time)/86400 -0.5 AS time_min,
	cast(to_char(time_obs::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_obs::timestamp::time)/86400 -0.5 AS time_max,

	CAST(NULL AS DOUBLE PRECISION)							AS  target_time_min,	-- not provided because time is not well characterized
	CAST(NULL AS DOUBLE PRECISION)							AS  target_time_max,
	TEXT 'UTC' 												AS  time_scale,
	CAST(NULL AS DOUBLE PRECISION)							AS  time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)							AS  time_sampling_step_max,
	CAST(exp_time AS DOUBLE PRECISION)  					AS  time_exp_min,
	CAST(exp_time AS DOUBLE PRECISION) 						AS  time_exp_max,
	CAST((2.99792458E14/sp_max) AS DOUBLE PRECISION) 		AS  spectral_range_min,
	CAST((2.99792458E14/sp_min) AS DOUBLE PRECISION) 		AS  spectral_range_max,	
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_min,
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_max,

	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_resolution_min,
	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_resolution_max,
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
	TEXT 'body'									AS spatial_frame_type,
	CAST(NULL AS TEXT) 							AS s_region,

	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(phase_ang AS DOUBLE PRECISION)	 as phase_min,
	CAST(phase_ang AS DOUBLE PRECISION)	 as phase_max,
	array_to_string(array(select distinct inst_host_name from iks.data_table), ' ')	AS  instrument_host_name,
	array_to_string(array(select distinct inst_name from iks.data_table), ' ') 		AS  instrument_name,
	TEXT 'phot.flux.density'					AS measurement_type,
	--	CAST('http://voparis-srv.obspm.fr/vo/planeto/iks/' || filename AS character varying)	AS access_url,
	CAST(a_url AS TEXT)				AS access_url,
	CAST(a_format AS TEXT)			AS access_format,
	INTEGER '19'					AS access_estsize,
	CAST(rootname || '.xml' AS TEXT)		 	AS file_name,
	CAST(ref AS TEXT) 				AS bib_reference,
	DATE '2013-11-17T10:41:00.00+00:00'	AS  creation_date,
	DATE '2013-11-17T10:41:00.00+00:00'	AS  modification_date,
	DATE '2013-11-17T10:41:00.00+00:00'	AS  release_date,
	TEXT 'IKS'  					AS  service_title,
	integer '3'						AS processing_level
FROM IKS.data_table;
	

CREATE OR REPLACE VIEW iks.archive AS SELECT
	CAST(rootname || 'A' AS TEXT)				 AS granule_uid,	-- this is different
	TEXT 'archived'								 AS granule_gid,	-- this is different
	CAST(rootname AS TEXT)						 AS obs_id,
	TEXT 'sp'  									AS dataproduct_type,
	TEXT '1P'	 								AS target_name,
	CAST(target AS TEXT)						AS alt_target_name,
	TEXT 'comet'								AS target_class,
	CAST(observation_id AS TEXT) 				AS  acquisition_id,
	distance		 							AS  target_distance_min,
	distance		 							AS  target_distance_max,
	sdistance		 							AS  sun_distance,
	edistance		 							AS  earth_distance,
	cast(to_char(time_obs::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_obs::timestamp::time)/86400 -0.5 AS time_min,
	cast(to_char(time_obs::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_obs::timestamp::time)/86400 -0.5 AS time_max,

	CAST(NULL AS DOUBLE PRECISION)							AS  target_time_min,
	CAST(NULL AS DOUBLE PRECISION)							AS  target_time_max,
	TEXT 'UTC' 												AS  time_scale,
	CAST(NULL AS DOUBLE PRECISION)							AS  time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)							AS  time_sampling_step_max,
	CAST(exp_time AS DOUBLE PRECISION)  					AS  time_exp_min,
	CAST(exp_time AS DOUBLE PRECISION) 						AS  time_exp_max,
	CAST((2.99792458E14/sp_max) AS DOUBLE PRECISION) 		AS  spectral_range_min,
	CAST((2.99792458E14/sp_min) AS DOUBLE PRECISION) 		AS  spectral_range_max,	
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_min,
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_max,

	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_resolution_min,
	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_resolution_max,
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
	TEXT 'body'									AS spatial_frame_type,
	CAST(NULL AS TEXT) 							AS s_region,

	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(phase_ang AS DOUBLE PRECISION)	 as phase_min,
	CAST(phase_ang AS DOUBLE PRECISION)	 as phase_max,
	array_to_string(array(select distinct inst_host_name from iks.data_table), ' ')	AS  instrument_host_name,
	array_to_string(array(select distinct inst_name from iks.data_table), ' ') 		AS  instrument_name,
	TEXT 'phot.flux.density'					AS measurement_type,
	CAST(o_url AS TEXT)				AS access_url, 		-- this is different
	CAST(o_format AS TEXT)			AS access_format, 	-- this is different
	INTEGER '4'						AS access_estsize, 			-- this is different
	CAST(rootname || '.tab' AS TEXT)		 				AS file_name,		-- this is may be different
	CAST(ref AS TEXT) 				AS bib_reference,
	DATE '1993-11-10T07:54:00.00+00:00'	AS  creation_date,		-- this is different
	DATE '1993-11-10T07:54:00.00+00:00'	AS  modification_date,	-- this is different
	DATE '1993-11-10T07:54:00.00+00:00'	AS  release_date,		-- this is different
	TEXT 'IKS'  					AS  service_title,
	integer '3'						AS processing_level
FROM IKS.data_table;


	-- merge the above views and interleave groups
CREATE OR REPLACE VIEW iks.epn_core AS (
	SELECT * FROM iks.corrected
	UNION
	SELECT * FROM iks.archive
	ORDER BY granule_uid
);



GRANT ALL PRIVILEGES ON SCHEMA public TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA public TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON iks.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON iks.epn_core to gavo WITH GRANT OPTION; 


