-- SQL procedure to define the VVEX service view for EPN-TAP v2

-- Stephane Erard, LESIA/OVPDC, April 2016 (hand-written from v1 and IKS v2 examples)
-- Can be used as a template for other light services 

-- Creates one view per granule group (here, 2 of them), then merge to epn_core view (EPN-TAP v2)



CREATE OR REPLACE VIEW vvex.calibrated AS SELECT

	CAST(rootname || 'C' AS TEXT)				 AS granule_uid,
	TEXT 'calibrated'							 AS granule_gid,
	CAST(rootname AS TEXT)						 AS obs_id,

	TEXT 'sc'									AS dataproduct_type,
	CAST(target AS TEXT)						AS target_name ,
	CAST(targetType AS TEXT)					AS target_class,
	target_distance_min							AS  target_distance_min,
	target_distance_max							AS  target_distance_max,
	cast(to_char(time_start::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_start::timestamp::time)/86400 -0.5 AS time_min,
	cast(to_char(time_end::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_end::timestamp::time)/86400 -0.5 AS time_max,

	CAST(NULL AS DOUBLE PRECISION)				AS  target_time_min,	-- TBC***
	CAST(NULL AS DOUBLE PRECISION)				AS  target_time_max,
	TEXT 'UTC'									AS  time_scale,
	CAST(time_samp AS DOUBLE PRECISION)				AS time_sampling_step_min,
	CAST(time_samp AS DOUBLE PRECISION)				AS time_sampling_step_max,
	CAST(exp_time AS DOUBLE PRECISION)						AS  time_exp_min,
	CAST(exp_time AS DOUBLE PRECISION)						AS  time_exp_max,
	CAST((2.99792458E14/sp_max) AS DOUBLE PRECISION) 		AS  spectral_range_min,
	CAST((2.99792458E14/sp_min) AS DOUBLE PRECISION) 		AS  spectral_range_max,	
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_min,
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_max,

	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_resolution_min,
	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_resolution_max,
	CAST(lon_min AS DOUBLE PRECISION)						AS c1min,
	CAST(lon_max AS DOUBLE PRECISION)						AS c1max,
	CAST(lat_min AS DOUBLE PRECISION)						AS c2min,
	CAST(lat_max AS DOUBLE PRECISION)						AS c2max,
	CAST(NULL AS DOUBLE PRECISION)							AS c3min,
	CAST(NULL AS DOUBLE PRECISION)							AS c3max,
	CAST(NULL AS DOUBLE PRECISION)							AS c1_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)							AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)							AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c3_resol_max,
	TEXT 'body'												AS spatial_frame_type,
	CAST(s_region AS TEXT)										AS s_region,
	CAST(local_t_min AS DOUBLE PRECISION)					AS  local_time_min,
	CAST(local_t_max AS DOUBLE PRECISION)					AS  local_time_max,
	CAST(NULL AS DOUBLE PRECISION)		as incidence_min,
	CAST(NULL AS DOUBLE PRECISION)		as incidence_max,
	CAST(NULL AS DOUBLE PRECISION)		as emergence_min,
	CAST(NULL AS DOUBLE PRECISION)		as emergence_max,
	CAST(NULL AS DOUBLE PRECISION)		as phase_min,
	CAST(NULL AS DOUBLE PRECISION)		as phase_max,
	CAST(modeID AS INTEGER)			as instrument_mode,		-- Extra
	CAST(s_c_point AS TEXT)			as sc_pointing_mode,	-- Extra
	CAST(RA AS DOUBLE PRECISION)				AS RA,
	CAST(DECli AS DOUBLE PRECISION)				AS DEC,
	array_to_string(array(select distinct inst_host_name from vvex.data_table), ' ')	AS  instrument_host_name,
	array_to_string(array(select distinct inst_name from vvex.data_table), ' ') 		AS  instrument_name,
	TEXT 'phys.luminosity;phys.angArea;em.wl'		AS measurement_type,
	CAST(a_url AS TEXT)			AS access_url,
	CAST(a_format AS TEXT)		AS access_format,
	CAST(sizeD AS INTEGER)		AS access_estsize,
	CAST(th_url || th_url1 AS TEXT)			AS thumbnail_url,
	CAST(filename AS TEXT)			AS file_name,
	CAST(ref AS TEXT)				AS bib_reference,
	CAST(creattime as DATE)			AS  creation_date,
	CAST(creattime as DATE)			AS  modification_date,
	CAST(creattime as DATE)			AS  release_date,
	TEXT 'VVEX'						AS  service_title,
	integer '3'						AS processing_level
FROM vvex.data_table;
	
CREATE OR REPLACE VIEW vvex.geometry AS SELECT

	CAST(rootname || 'G' AS TEXT)				 AS granule_uid,
	TEXT 'geometry'								 AS granule_gid,
	CAST(rootname AS TEXT)						 AS obs_id,

	TEXT 'sc'									AS dataproduct_type,
	CAST(target AS TEXT)						AS target_name ,
	CAST(targetType AS TEXT)					AS target_class,
	target_distance_min							AS  target_distance_min,
	target_distance_max							AS  target_distance_max,
	cast(to_char(time_start::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_start::timestamp::time)/86400 -0.5 AS time_min,
	cast(to_char(time_end::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_end::timestamp::time)/86400 -0.5 AS time_max,

	CAST(NULL AS DOUBLE PRECISION)				AS  target_time_min,	-- TBC***
	CAST(NULL AS DOUBLE PRECISION)				AS  target_time_max,
	TEXT 'UTC'									AS  time_scale,
	CAST(time_samp AS DOUBLE PRECISION)				AS time_sampling_step_min,
	CAST(time_samp AS DOUBLE PRECISION)				AS time_sampling_step_max,
	CAST(exp_time AS DOUBLE PRECISION)						AS  time_exp_min,
	CAST(exp_time AS DOUBLE PRECISION)						AS  time_exp_max,
	CAST((2.99792458E14/sp_max) AS DOUBLE PRECISION) 		AS  spectral_range_min,
	CAST((2.99792458E14/sp_min) AS DOUBLE PRECISION) 		AS  spectral_range_max,	
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_min,
	CAST((2.99792458E14*(sp_step_min+sp_step_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_sampling_step_max,

	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_max)^2) AS DOUBLE PRECISION)	AS spectral_resolution_min,
	CAST((2.99792458E14*(sp_res_min+sp_res_max)/2/(sp_min)^2) AS DOUBLE PRECISION)	AS spectral_resolution_max,
	CAST(lon_min AS DOUBLE PRECISION)						AS c1min,
	CAST(lon_max AS DOUBLE PRECISION)						AS c1max,
	CAST(lat_min AS DOUBLE PRECISION)						AS c2min,
	CAST(lat_max AS DOUBLE PRECISION)						AS c2max,
	CAST(NULL AS DOUBLE PRECISION)							AS c3min,
	CAST(NULL AS DOUBLE PRECISION)							AS c3max,
	CAST(NULL AS DOUBLE PRECISION)							AS c1_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)							AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)							AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)							AS c3_resol_max,
	TEXT 'body'												AS spatial_frame_type,
	CAST(s_region AS TEXT)										AS s_region,
	CAST(local_t_min AS DOUBLE PRECISION)					AS  local_time_min,
	CAST(local_t_max AS DOUBLE PRECISION)					AS  local_time_max,
	CAST(NULL AS DOUBLE PRECISION)		as incidence_min,
	CAST(NULL AS DOUBLE PRECISION)		as incidence_max,
	CAST(NULL AS DOUBLE PRECISION)		as emergence_min,
	CAST(NULL AS DOUBLE PRECISION)		as emergence_max,
	CAST(NULL AS DOUBLE PRECISION)		as phase_min,
	CAST(NULL AS DOUBLE PRECISION)		as phase_max,
	CAST(modeID AS INTEGER)			as instrument_mode,		-- Extra
	CAST(s_c_point AS TEXT)			as sc_pointing_mode,	-- Extra
	CAST(RA AS DOUBLE PRECISION)				AS RA,
	CAST(DECli AS DOUBLE PRECISION)				AS DEC,

	array_to_string(array(select distinct inst_host_name from vvex.data_table), ' ')	AS  instrument_host_name,
	array_to_string(array(select distinct inst_name from vvex.data_table), ' ') 		AS  instrument_name,
	CAST(NULL AS TEXT)			AS measurement_type,
	CAST(a_Gurl AS TEXT)		AS access_url,		-- different
	CAST(a_format AS TEXT)		AS access_format,
	CAST(sizeG AS INTEGER)		AS access_estsize,
	CAST(th_url || th_Gurl AS TEXT)			AS thumbnail_url,
	CAST(rootname || '.GEO' AS TEXT) 		AS file_name,		-- different
	CAST(ref AS TEXT)				AS bib_reference,
	CAST(creattime as DATE)			AS  creation_date,
	CAST(creattime as DATE)			AS  modification_date,
	CAST(creattime as DATE)			AS  release_date,
	TEXT 'VVEX'						AS  service_title,
	integer '6'						AS processing_level		-- different
FROM vvex.data_table;
	
	
	-- merge the above views and interleave groups
CREATE OR REPLACE VIEW vvex.epn_core AS (
	SELECT * FROM vvex.calibrated
	UNION
	SELECT * FROM vvex.geometry
	ORDER BY granule_uid
);
	

--GRANT ALL PRIVILEGES ON SCHEMA public TO gavo WITH GRANT OPTION;
--GRANT ALL PRIVILEGES ON SCHEMA public TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON vvex.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON vvex.epn_core to gavo WITH GRANT OPTION; 


