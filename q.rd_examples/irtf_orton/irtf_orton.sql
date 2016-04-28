-- PgSQL initialization script for IRTF/Orton NIR observation 
-- This script creates empty Tables and Views, that will be filled in
-- by a python script 'orton_irtf_fits_epncore.py', using the FITS files header.

-- Creating irtf_orton SCHEMA (this is a grouping of tables)
DROP SCHEMA IF EXISTS irtf_orton CASCADE;
CREATE SCHEMA irtf_orton;

-- Creating Metadata TABLE
-- This TABLE will be filled in by a python script from the FITS files header 
DROP TABLE IF EXISTS irtf_orton.metadata CASCADE;
CREATE TABLE irtf_orton.metadata(
        instrument_host_name    TEXT,   			-- Should always be 'NASA IRTF' 
        instrument_name         TEXT,				-- Should always be 'SpeX Imager'
        creation_date           timestamp,			-- Date/time in ISO format of Data file
        iso_time                timestamp,			-- Date/time in ISO format of Observation Start
        target_name             TEXT,				-- Jupiter, Venus... (with capitalized 1st letter)
        wavelength	            DOUBLE PRECISION,	-- central value of wavelength range (micron)
        exp_time	            DOUBLE PRECISION,	-- Exposure time (seconds)
        access_url              TEXT,				-- fully qualified URL access of FITS data file 
        access_md5              TEXT,				-- MD5 hash of FITS file
        access_estsize          DOUBLE PRECISION,	-- FITS file size in kB
        thumb_url               TEXT,				-- fully qualified URL access of PNG thumbnail file 
        file                    TEXT,				-- file name (without extension)
        target_dist             TEXT,				-- distance from Earth to target (in AU)
        solar_longitude			DOUBLE PRECISION,   -- Jupiter Solar Longitude (season) in Deg.
        longitude_sysIII		DOUBLE PRECISION	-- System III longitude at center of target (deg)
-- if you want to add more metadata you can add TABLE columns (each line of the 
-- CREATE TABLE directive defines a TABLE column)
        );


-- Creating EPN_CORE view
-- This is a virtual table that is automatically computing output on demand
-- The "irtf_orton.epn_core" VIEW is composed of the UNION of two SELECT directives.
DROP VIEW IF EXISTS irtf_orton.epn_core CASCADE;
CREATE VIEW irtf_orton.epn_core AS SELECT
-- This part is the FITS file metadata catalogue following EPNcore v2 specification
	md.file 															AS granule_uid,
	TEXT 'Raw data'														AS granule_gid,
	md.file 															AS obs_id,
	TEXT 'im'  															AS dataproduct_type,
	CAST('#' || md.target_name || '#' AS TEXT)							AS target_name,
	CAST('#planet#' AS TEXT)											AS target_class,
	CAST(to_char(md.iso_time::timestamp,'J') AS DOUBLE PRECISION)  		AS time_min,	-- looks bugged in output table, to be fixed...
	CAST(to_char(md.iso_time::timestamp,'J') AS DOUBLE PRECISION)  		AS time_max,	-- looks bugged in output table, to be fixed...
	CAST(NULL AS DOUBLE PRECISION)										AS time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)										AS time_sampling_step_max,
	CAST(NULL AS DOUBLE PRECISION)					 					AS time_exp_min,
	CAST(NULL AS DOUBLE PRECISION)					 					AS time_exp_max,
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength AS DOUBLE PRECISION)	AS  spectral_range_min, -- wavelength transformed into Hz
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength AS DOUBLE PRECISION)	AS  spectral_range_max,	-- wavelength transformed into Hz
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_max,
	CAST(NULL AS DOUBLE PRECISION) 										AS spectral_resolution_min, -- wavelength width transformed into Hz
	CAST(NULL AS DOUBLE PRECISION) 										AS spectral_resolution_max,	-- wavelength width transformed into Hz
	CAST(NULL AS DOUBLE PRECISION)										AS c1min,
	CAST(NULL AS DOUBLE PRECISION)										AS c1max,
	CAST(-90 AS DOUBLE PRECISION)										AS c2min,
	CAST(90 AS DOUBLE PRECISION)					 					AS c2max,
	CAST(md.longitude_sysIII-90. AS DOUBLE PRECISION)					AS c3min,
	CAST(md.longitude_sysIII+90. AS DOUBLE PRECISION)					AS c3max,
	CAST(NULL AS TEXT)													AS s_region,	
	CAST(NULL AS DOUBLE PRECISION)									AS c1_resol_min,
 	CAST(NULL AS DOUBLE PRECISION)									AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)									AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)									AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_max,
	CAST('spherical' AS TEXT)									AS spatial_frame_type,
	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(NULL AS DOUBLE PRECISION) as phase_min,
	CAST(NULL AS DOUBLE PRECISION) as phase_max,
	CAST(md.instrument_host_name AS TEXT)				AS  instrument_host_name,
	CAST(md.instrument_name AS TEXT)		 			AS  instrument_name,
	TEXT 'phys.count;em.IR'									AS measurement_type,
	md.creation_date								AS creation_date,
	md.creation_date								AS modification_date,
	md.creation_date								AS release_date,
	CAST(md.access_url AS TEXT) AS access_url,
	CAST(md.access_estsize as DOUBLE PRECISION) 			AS access_estsize,
	CAST('image/fits' AS TEXT)		 			AS access_format,
	CAST(md.access_md5 AS TEXT)		 				AS access_md5,
	CAST(md.thumb_url AS TEXT) 						AS thumbnail_url,
	CAST(1 AS INTEGER)									AS processing_level,
	CAST(NULL AS TEXT) 			AS reference,
	CAST('NASA/JPL' AS TEXT) 			AS publisher,
	CAST('NASA IRTF NIR Jupiter Observation' AS TEXT) 			AS service_title,
	CAST('Atmosphere' AS TEXT)			AS target_region,	
	CAST('Jovian System III' AS TEXT)			AS spatial_coordinate_description,	
	CAST('UTC' AS TEXT)			AS time_scale,	
	CAST(NULL AS TEXT)			AS feature_name,
	CAST(md.solar_longitude AS DOUBLE PRECISION)			AS solar_longitude_min,	
	CAST(md.solar_longitude AS DOUBLE PRECISION)			AS solar_longitude_max,	
	CAST(md.target_dist AS DOUBLE PRECISION)			AS target_distance_min,	
	CAST(md.target_dist AS DOUBLE PRECISION)			AS target_distance_max	
FROM irtf_orton.metadata md;

-- Granting ALL PRIVILEGES on schema TO gavo and gavoadmin. 
GRANT ALL PRIVILEGES ON SCHEMA irtf_orton TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA irtf_orton TO gavoadmin WITH GRANT OPTION;
-- Granting ALL PRIVILEGES on tables and views TO gavo and gavoadmin. 
GRANT ALL PRIVILEGES ON irtf_orton.metadata to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON irtf_orton.metadata to gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON irtf_orton.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON irtf_orton.epn_core to gavo WITH GRANT OPTION; 
