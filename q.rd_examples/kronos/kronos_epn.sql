-- Creating Schema Kronos

CREATE SCHEMA kronos;

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Creating MySQL Foreign Data Wrapper for Typhon2 database connexion. 
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

CREATE EXTENSION mysql_fdw SCHEMA kronos;
CREATE SERVER typhon2_server FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host 'typhon2.obspm.fr', port '3306');
CREATE USER MAPPING FOR postgres SERVER typhon2_server OPTIONS (username 'kronos', password '############');

-- Creating MySQL Foreign Table from Typhon2:kronos

CREATE FOREIGN TABLE kronos.prep_epn (
 	file 	char(11),
	t_min 	date,
	t_max 	date,
	time_resol_min 	INTEGER,
	time_resol_max 	INTEGER,
	spec_range_min 	double precision,
	spec_range_max 	double precision,
	spec_sampl_min 	double precision,
	spec_sampl_max 	double precision,
	spec_resol_min 	double precision,
	spec_resol_max 	double precision,
	nsamples 	INTEGER,
	ndf_samp 	INTEGER)
SERVER typhon2_server
	OPTIONS (dbname 'kronos', table_name 'prep_epn');
	
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Creating PostgresQL Foreign Data Wrapper for Kronos database connexion. 
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

CREATE EXTENSION postgres_fdw SCHEMA kronos;
CREATE SERVER kronos_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'kronos', dbname 'kronosdb', port '5432');
CREATE USER MAPPING FOR postgres SERVER kronos_server OPTIONS (user 'hchain', password '############');

-- Creating PostgresQL Foreign Table from Kronos:n0_epn

CREATE FOREIGN TABLE kronos.n0_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n0_epn');

-- Creating PostgresQL Foreign Table from Kronos:n1_epn

CREATE FOREIGN TABLE kronos.n1_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n1_epn');

-- Creating PostgresQL Foreign Table from Kronos:n2_epn

CREATE FOREIGN TABLE kronos.n2_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n2_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3b_epn

CREATE FOREIGN TABLE kronos.n3b_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n3b_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3c_epn

CREATE FOREIGN TABLE kronos.n3c_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n3c_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3d_epn

CREATE FOREIGN TABLE kronos.n3d_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n3d_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3e_epn

CREATE FOREIGN TABLE kronos.n3e_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n3e_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3g_epn

CREATE FOREIGN TABLE kronos.n3g_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'n3g_epn');

-- Creating PostgresQL Foreign Table from Kronos:n3g_epn

CREATE FOREIGN TABLE kronos.pdf_ext (
	mod_date 	DATE NOT NULL, 
	p_url		TEXT,
	obsv		TEXT,
	file		TEXT,
	gid			TEXT,
	lev			INTEGER NOT NULL)
SERVER kronos_server 
	OPTIONS (schema_name 'public', table_name 'pdf_epn');

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Creating intermediate local Views
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------

-- Creating View kronos.n0_int
DROP VIEW IF EXISTS kronos.n0_int CASCADE;
CREATE VIEW kronos.n0_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	file		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n0_ext;

-- Creating View kronos.n1_int
DROP VIEW IF EXISTS kronos.n1_int CASCADE;
CREATE VIEW kronos.n1_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n1_ext;

-- Creating View kronos.n2_int
DROP VIEW IF EXISTS kronos.n2_int CASCADE;
CREATE VIEW kronos.n2_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n2_ext;

-- Creating View kronos.n2_int
DROP VIEW IF EXISTS kronos.n2_int CASCADE;
CREATE VIEW kronos.n2_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n2_ext;

-- Creating View kronos.n3b_int
DROP VIEW IF EXISTS kronos.n3b_int CASCADE;
CREATE VIEW kronos.n3b_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3b_ext;

-- Creating View kronos.n3b_int
DROP VIEW IF EXISTS kronos.n3b_int CASCADE;
CREATE VIEW kronos.n3b_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3b_ext;

-- Creating View kronos.n3c_int
DROP VIEW IF EXISTS kronos.n3c_int CASCADE;
CREATE VIEW kronos.n3c_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3c_ext;

-- Creating View kronos.n3d_int
DROP VIEW IF EXISTS kronos.n3d_int CASCADE;
CREATE VIEW kronos.n3d_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3d_ext;

-- Creating View kronos.n3e_int
DROP VIEW IF EXISTS kronos.n3e_int CASCADE;
CREATE VIEW kronos.n3e_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3e_ext;

-- Creating View kronos.n3g_int
DROP VIEW IF EXISTS kronos.n3g_int CASCADE;
CREATE VIEW kronos.n3g_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/octet-stream' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.n3g_ext;

-- Creating View kronos.pdf_int
DROP VIEW IF EXISTS kronos.pdf_int CASCADE;
CREATE VIEW kronos.pdf_int AS SELECT
	mod_date 	as mod_date, 
	p_url		as p_url,
	CAST('application/pdf' AS TEXT)	as format,
	obsv		as obsv,
	file		as file,
	gid			as gid, 
	lev			as lev
FROM kronos.pdf_ext;

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- Creating final MATERIALIZED VIEWs
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------


-- Creating Materialized View kronos.file_metadata

DROP MATERIALIZED VIEW IF EXISTS kronos.file_metadata CASCADE;
CREATE MATERIALIZED VIEW kronos.file_metadata AS 
	SELECT * FROM kronos.n0_int
UNION ALL 
	SELECT * FROM kronos.n1_int 
UNION ALL 
	SELECT * FROM kronos.n2_int 
UNION ALL 
	SELECT * FROM kronos.n3b_int 
UNION ALL 
	SELECT * FROM kronos.n3c_int 
UNION ALL 
	SELECT * FROM kronos.n3d_int 
UNION ALL 
	SELECT * FROM kronos.n3e_int 
UNION ALL 
	SELECT * FROM kronos.n3g_int
UNION ALL 
	SELECT * FROM kronos.pdf_int;

-- Creating Materialized View kronos.mode_metadata

DROP MATERIALIZED VIEW IF EXISTS kronos.mode_metadata CASCADE;
CREATE MATERIALIZED VIEW kronos.mode_metadata AS 
	SELECT * FROM kronos.prep_epn;


-- Creating View kronos.epn_core
DROP TABLE IF EXISTS kronos.epn_core;   -- required if you've just issued the "gavo imp -m q.rd" command.
DROP MATERIALIZED VIEW IF EXISTS kronos.epn_core;
CREATE MATERIALIZED VIEW kronos.epn_core AS SELECT
	md.file 								AS granule_uid,
	md.gid									AS granule_gid,
	md.obsv 								AS obs_id,
	TEXT 'ds'  								AS dataproduct_type,
	CAST('#Saturn#Jupiter#Sun#Earth#Venus#' AS TEXT)	AS target_name,
	CAST('#planet#star#' AS TEXT)			AS target_class,
	CAST(to_char(MIN(pp.t_min::timestamp),'J') AS DOUBLE PRECISION) AS  time_min,
	CAST(to_char(MAX(pp.t_max::timestamp),'J') AS DOUBLE PRECISION) AS  time_max,
	CAST(NULL AS DOUBLE PRECISION)									AS time_sampling_step_min,
	CAST(NULL AS DOUBLE PRECISION)									AS time_sampling_step_max,
	CAST(MIN(pp.time_resol_min) AS DOUBLE PRECISION)/1000. 			AS  time_exp_min,
	CAST(MAX(pp.time_resol_max) AS DOUBLE PRECISION)/1000. 			AS  time_exp_max,
	CAST(MIN(pp.spec_range_min) AS DOUBLE PRECISION)*1000.			AS  spectral_range_min,
	CAST(MAX(pp.spec_range_max) AS DOUBLE PRECISION)*1000.			AS  spectral_range_max,
	CAST(MIN(pp.spec_sampl_min) AS DOUBLE PRECISION)*1000.			AS  spectral_sampling_step_min,
	CAST(MAX(pp.spec_sampl_max) AS DOUBLE PRECISION)*1000.			AS  spectral_sampling_step_max,
	CAST(MIN(pp.spec_resol_min) AS DOUBLE PRECISION)*1000.			AS spectral_resolution_min,
	CAST(MAX(pp.spec_resol_max) AS DOUBLE PRECISION)*1000.			AS spectral_resolution_max,
	CAST(NULL AS DOUBLE PRECISION)									AS c1min,
	CAST(NULL AS DOUBLE PRECISION)									AS c1max,
	CAST(NULL AS DOUBLE PRECISION)									AS c2min,
	CAST(NULL AS DOUBLE PRECISION)	 								AS c2max,
	CAST(NULL AS DOUBLE PRECISION)									AS c3min,
	CAST(NULL AS DOUBLE PRECISION)									AS c3max,
	CAST(NULL AS SPOLY)		 				AS s_region,	
	CAST(NULL AS DOUBLE PRECISION)									AS c1_resol_min,
 	CAST(NULL AS DOUBLE PRECISION)									AS c1_resol_max,
	CAST(NULL AS DOUBLE PRECISION)									AS c2_resol_min,
	CAST(NULL AS DOUBLE PRECISION)									AS c2_resol_max,
	CAST(NULL AS DOUBLE PRECISION)									AS c3_resol_min,
	CAST(NULL AS DOUBLE PRECISION)									AS c3_resol_max,
	CAST(NULL AS TEXT)									AS spatial_frame_type,
	CAST(NULL AS DOUBLE PRECISION) as incidence_min,
	CAST(NULL AS DOUBLE PRECISION) as incidence_max,
	CAST(NULL AS DOUBLE PRECISION) as emergence_min,
	CAST(NULL AS DOUBLE PRECISION) as emergence_max,
	CAST(NULL AS DOUBLE PRECISION) as phase_min,
	CAST(NULL AS DOUBLE PRECISION) as phase_max,
	CAST('Cassini Orbiter' AS TEXT)				AS  instrument_host_name,
	CAST('RPWS/HFR' AS TEXT)		 			AS  instrument_name,
	TEXT 'phys.flux.density'					AS measurement_type,
	md.mod_date								AS creation_date,
	md.mod_date								AS modification_date,
	md.mod_date								AS release_date,
	CAST('http://lesia.obspm.fr/kronos/data/' || md.p_url || md.file AS TEXT) AS access_url,
	CAST(NULL as DOUBLE PRECISION) 			AS access_estsize,
	md.format					 			AS access_format,
	CAST(NULL AS TEXT)		 				AS access_md5,
	CAST(NULL AS TEXT) 						AS thumbnail_url,
	md.lev									AS processing_level,
	CAST(NULL AS TEXT) 			AS reference,
	CAST('LESIA, Observatoire de Paris' AS TEXT) 			AS publisher,
	CAST(NULL AS TEXT) 			AS service_title,
	CAST('Magnetosphere' AS TEXT)			AS target_region,	
	CAST('SCET' AS TEXT)			AS time_scale,	
	CAST(NULL AS TEXT)			AS feature_name	
FROM kronos.file_metadata md INNER JOIN kronos.mode_metadata pp ON (pp.file LIKE '%' || md.obsv || '%' );


GRANT ALL PRIVILEGES ON SCHEMA public TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA public TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA kronos TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA kronos TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON kronos.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON kronos.epn_core to gavo WITH GRANT OPTION; 



