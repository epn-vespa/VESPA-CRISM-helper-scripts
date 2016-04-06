-- PgSQL initialization script for Hisaki/Exceed EUV observation 
-- This script creates empty Tables and Views, that will be filled in
-- by a python script 'hisaki_fits_epncore.py', using the FITS files header.

-- Creating Hisaki SCHEMA (this is a grouping of tables)
DROP SCHEMA IF EXISTS hisaki CASCADE;
CREATE SCHEMA hisaki;

-- Creating Metadata TABLE
-- This TABLE will be filled in by a python script from the FITS files header 
DROP TABLE IF EXISTS hisaki.metadata CASCADE;
CREATE TABLE hisaki.metadata(
        instrument_host_name    TEXT,   			-- Should always be 'Hisaki' 
        instrument_name         TEXT,				-- Should always be 'Exceed EUV Spectrometer'
        creation_date           timestamp,			-- Date/time in ISO format of Data file
        iso_time_min            timestamp,			-- Date/time in ISO format of Observation Start
        iso_time_max            timestamp,			-- Date/time in ISO format of Observation Stop
        target_name             TEXT,				-- Jupiter, Venus... (with capitalized 1st letter)
        wavelength_min          DOUBLE PRECISION,	-- value of lower bound of wavelength range
        wavelength_max          DOUBLE PRECISION,	-- value of upper bound of wavelength range
        access_url              TEXT,				-- fully qualified URL access of FITS data file 
        access_md5              TEXT,				-- MD5 hash of FITS file
        access_estsize          DOUBLE PRECISION,	-- FITS file size in kB
        thumb_url               TEXT,				-- fully qualified URL access of PNG thumbnail file 
        preview_url             TEXT,				-- fully qualified URL access of PNG preview file 
        preview_md5             TEXT,				-- MD5 hash of PNG preview file
        preview_estsize         DOUBLE PRECISION,	-- PNG preview size in kB
        file                    TEXT,				-- file name (without extension)
        obs_id                  TEXT				-- observation name (without extension and level info)
-- if you want to add more metadata you can add TABLE columns (each line of the 
-- CREATE TABLE directive defines a TABLE column)
        );

-- Creating FOV_CORNERS table
-- This is filled through a python script from the FITS files header 
-- The python script is setting the values into pp as follows:
-- 'CAST(spoint(%s*pi()/180.0,%s*pi()/180.0) AS spoint)' % (imag_hdr['SLX1RA'],imag_hdr['SLX1DEC'])
-- 'CAST(spoint(%s*pi()/180.0,%s*pi()/180.0) AS spoint)' % (imag_hdr['SLX2RA'],imag_hdr['SLX2DEC'])
-- 'CAST(spoint(%s*pi()/180.0,%s*pi()/180.0) AS spoint)' % (imag_hdr['SLX3RA'],imag_hdr['SLX3DEC'])
-- 'CAST(spoint(%s*pi()/180.0,%s*pi()/180.0) AS spoint)' % (imag_hdr['SLX4RA'],imag_hdr['SLX4DEC'])
-- The "spoint" function is part of the PgSphere module. 
DROP TABLE IF EXISTS hisaki.fov_corners CASCADE;
CREATE TABLE hisaki.fov_corners(
		ii			SERIAL PRIMARY KEY,				-- index (to keep ordering of records)
		file		TEXT,							-- FITS file name (without extension)
        pp			SPOINT,							-- PgSphere point of corners
        ct			CHAR(2)							-- Corner type (nw,ne,se,sw) [not used yet]
        );

-- Creating FOV_POLYGON view
-- This is a virtual table that is automatically computing output on demand
-- The function "spoly" is part of the PgSphere module. 
DROP VIEW IF EXISTS hisaki.fov_polygon CASCADE;
CREATE VIEW hisaki.fov_polygon AS SELECT 
	fc.file 						AS file, 		-- FITS file name (without extension)
	spoly(fc.pp) 					AS region,		-- sPOLY formed by the series of 4 FOV corners for the same FITS file
	(min(long(pp)+2*pi()))-2*pi() 	AS lon_min,		-- min value of longitude
	(max(long(pp)+2*pi()))-2*pi()	AS lon_max, 	-- max value of longitude
	min(lat(pp)) 					AS lat_min,		-- min value of latitude
	max(lat(pp)) 					AS lat_max		-- max value of latitude
FROM hisaki.fov_corners fc GROUP BY fc.file;
-- NB: by chance I don't have to reorder the sPOINT from hisaki.fov_corners. 
-- If needed, it should be done differently (and I would appreciate any guidance on this aspect :-)

-- Creating EPN_CORE view
-- This is a virtual table that is automatically computing output on demand
-- The "hisaki.epn_core" VIEW is composed of the UNION of two SELECT directives.
DROP VIEW IF EXISTS hisaki.epn_core CASCADE;
CREATE VIEW hisaki.epn_core AS SELECT
-- This part is the FITS file metadata catalogue following EPNcore v2 specification
	md.file 															AS granule_uid,
	TEXT 'L2 dataset'													AS granule_gid,
	md.obs_id 															AS obs_id,
	TEXT 'im'  															AS dataproduct_type,
	CAST('#' || md.target_name || '#' AS TEXT)							AS target_name,
	CAST('#planet#' AS TEXT)											AS target_class,
	CAST(to_char(md.iso_time_min::timestamp,'J') AS DOUBLE PRECISION)  	AS time_min,	-- looks bugged in output table, to be fixed...
	CAST(to_char(md.iso_time_max::timestamp,'J') AS DOUBLE PRECISION)  	AS time_max,	-- looks bugged in output table, to be fixed...
	CAST(60. AS DOUBLE PRECISION)										AS time_sampling_step_min,
	CAST(60. AS DOUBLE PRECISION)										AS time_sampling_step_max,
	CAST(60. AS DOUBLE PRECISION)					 					AS time_exp_min,
	CAST(60. AS DOUBLE PRECISION)					 					AS time_exp_max,
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength_max AS DOUBLE PRECISION)	AS  spectral_range_min, -- wavelength transformed into Hz
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength_min AS DOUBLE PRECISION)	AS  spectral_range_max,	-- wavelength transformed into Hz
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_max,
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(5 AS DOUBLE PRECISION)	AS spectral_resolution_min, -- wavelength width transformed into Hz
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(1 AS DOUBLE PRECISION)	AS spectral_resolution_max,	-- wavelength width transformed into Hz
	CAST(fv.lon_min AS DOUBLE PRECISION)/pi()*180.						AS c1min,
	CAST(fv.lon_max AS DOUBLE PRECISION)/pi()*180.						AS c1max,
	CAST(fv.lat_min AS DOUBLE PRECISION)/pi()*180.						AS c2min,
	CAST(fv.lat_min AS DOUBLE PRECISION)/pi()*180.	 					AS c2max,
	CAST(NULL AS DOUBLE PRECISION)										AS c3min,
	CAST(NULL AS DOUBLE PRECISION)										AS c3max,
	CAST(fv.region AS spoly)											AS s_region,	
	CAST(17. AS DOUBLE PRECISION)/3600.									AS c1_resol_min,
 	CAST(17. AS DOUBLE PRECISION)/3600.									AS c1_resol_max,
	CAST(17. AS DOUBLE PRECISION)/3600.									AS c2_resol_min,
	CAST(17. AS DOUBLE PRECISION)/3600.									AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_max,
	CAST('celestial' AS TEXT)									AS spatial_frame_type,
	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(NULL AS DOUBLE PRECISION) as phase_min,
	CAST(NULL AS DOUBLE PRECISION) as phase_max,
	CAST(md.instrument_host_name AS TEXT)				AS  instrument_host_name,
	CAST(md.instrument_name AS TEXT)		 			AS  instrument_name,
	TEXT 'em.UV'									AS measurement_type,
	md.creation_date								AS creation_date,
	md.creation_date								AS modification_date,
	md.creation_date								AS release_date,
	CAST(md.access_url AS TEXT) AS access_url,
	CAST(md.access_estsize as DOUBLE PRECISION) 			AS access_estsize,
	CAST('image/fits' AS TEXT)		 			AS access_format,
	CAST(md.access_md5 AS TEXT)		 				AS access_md5,
	CAST(md.thumb_url AS TEXT) 						AS thumbnail_url,
	CAST(2 AS INTEGER)									AS processing_level,
	CAST(NULL AS TEXT) 			AS reference,
	CAST('JAXA/ISAS' AS TEXT) 			AS publisher,
	CAST('Hisaki EUV Planetary Observations' AS TEXT) 			AS service_title,
	CAST('Magnetosphere' AS TEXT)			AS target_region,	
	CAST('UTC' AS TEXT)			AS time_scale,	
	CAST(NULL AS TEXT)			AS feature_name	
FROM hisaki.metadata md INNER JOIN hisaki.fov_polygon fv ON md.file = fv.file UNION ALL SELECT 
-- This part is the PNG previews metadata catalogue following EPNcore v2 specification
	CAST( md.file || '-preview' AS TEXT)	AS granule_uid,
	TEXT 'L2 dataset preview'				AS granule_gid,
	md.obs_id 								AS obs_id,
	TEXT 'im'  								AS dataproduct_type,
	CAST('#' || md.target_name || '#' AS TEXT)			AS target_name,
	CAST('#planet#' AS TEXT)			AS target_class,
	CAST(to_char(md.iso_time_min::timestamp,'J') AS DOUBLE PRECISION)  AS  time_min,
	CAST(to_char(md.iso_time_max::timestamp,'J') AS DOUBLE PRECISION)  AS  time_max,
	CAST(NULL AS DOUBLE PRECISION)										AS time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)										AS time_sampling_step_max,
	CAST(NULL AS DOUBLE PRECISION)					 					AS time_exp_min,
	CAST(NULL AS DOUBLE PRECISION)					 					AS time_exp_max,
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength_max AS DOUBLE PRECISION)	AS  spectral_range_min,
	CAST(2.99792458E18 AS DOUBLE PRECISION) / CAST(md.wavelength_min AS DOUBLE PRECISION)	AS  spectral_range_max,
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)								 		AS spectral_sampling_step_max,
	CAST(NULL AS DOUBLE PRECISION)										AS spectral_resolution_min,
	CAST(NULL AS DOUBLE PRECISION)										AS spectral_resolution_max,
	CAST(fv.lon_min AS DOUBLE PRECISION)/pi()*180.						AS c1min,
	CAST(fv.lon_max AS DOUBLE PRECISION)/pi()*180.						AS c1max,
	CAST(fv.lat_min AS DOUBLE PRECISION)/pi()*180.						AS c2min,
	CAST(fv.lat_min AS DOUBLE PRECISION)/pi()*180.	 					AS c2max,
	CAST(NULL AS DOUBLE PRECISION)										AS c3min,
	CAST(NULL AS DOUBLE PRECISION)										AS c3max,
	CAST(fv.region AS spoly)											AS s_region,	
	CAST(NULL AS DOUBLE PRECISION)										AS c1_resol_min,
 	CAST(NULL AS DOUBLE PRECISION)										AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)										AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)										AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)										AS c3_resol_max,
	CAST('celestial' AS TEXT)									AS spatial_frame_type,
	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(NULL AS DOUBLE PRECISION) as phase_min,
	CAST(NULL AS DOUBLE PRECISION) as phase_max,
	CAST(md.instrument_host_name AS TEXT)				AS  instrument_host_name,
	CAST(md.instrument_name AS TEXT)		 			AS  instrument_name,
	TEXT 'em.UV'									AS measurement_type,
	md.creation_date								AS creation_date,
	md.creation_date								AS modification_date,
	md.creation_date								AS release_date,
	CAST(md.preview_url AS TEXT) AS access_url,
	CAST(md.preview_estsize as DOUBLE PRECISION) 			AS access_estsize,
	CAST('image/png' AS TEXT)		 			AS access_format,
	CAST(md.preview_md5 AS TEXT)		 				AS access_md5,
	CAST(md.thumb_url AS TEXT) 						AS thumbnail_url,
	CAST(2 AS INTEGER)									AS processing_level,
	CAST(NULL AS TEXT) 			AS reference,
	CAST('JAXA/ISAS' AS TEXT) 			AS publisher,
	CAST('Hisaki EUV Planetary Observations' AS TEXT) 			AS service_title,
	CAST('Magnetosphere' AS TEXT)			AS target_region,	
	CAST('UTC' AS TEXT)			AS time_scale,	
	CAST(NULL AS TEXT)			AS feature_name	
FROM hisaki.metadata md INNER JOIN hisaki.fov_polygon fv ON md.file = fv.file;

-- Granting ALL PRIVILEGES on schema TO gavo and gavoadmin. 
GRANT ALL PRIVILEGES ON SCHEMA hisaki TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA hisaki TO gavoadmin WITH GRANT OPTION;
-- The next two lines are necessary for the script to write into hisaki.fov_corners because of the ii SERIAL index.
GRANT ALL ON ALL SEQUENCES IN SCHEMA hisaki to gavo;
GRANT ALL ON ALL SEQUENCES IN SCHEMA hisaki to gavoadmin;
-- Granting ALL PRIVILEGES on tables and views TO gavo and gavoadmin. 
GRANT ALL PRIVILEGES ON hisaki.metadata to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hisaki.metadata to gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON hisaki.fov_corners to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hisaki.fov_corners to gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON hisaki.fov_polygon to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hisaki.fov_polygon to gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON hisaki.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON hisaki.epn_core to gavo WITH GRANT OPTION; 

