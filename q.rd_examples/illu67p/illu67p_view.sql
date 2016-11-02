-- SQL procedure to define illu67p datatable.
-- Name: illu67p; Type: SCHEMA; Schema: illu67p; Owner: postgres

SET client_encoding = 'UTF8';
-- We create the epn_core view from illu67p.data_table.
-- In this last is stored all (and only) the significant data, in order to save disk space.
-- Other data which can be hard-coded or processed from other parameters are created in the epn_core view.
DROP VIEW IF EXISTS illu67p.epn_core CASCADE;
CREATE VIEW illu67p.epn_core AS WITH cte AS
(
  -- For each map, we want to create a line on the epn_core view, corresponding to each file type we want to serve.
  -- For this, we could create 4 views (one by file type) and then create the epn_core view as the union of theses 4 views.
  -- But this method have fiew drawbacks:
  --   - data redundancy: ie, `target_name` is '67P' for all the view, so this hard-coded data will be repeted 4 times in the code;
  --   - data inconsistency: ie, if we want to modify the value of `target_name`, it is possible to inadvertently forget to apply the new value on all views.
  -- That's why we use here a CTE (Common Table Expression), which will store all the parameters that have the same value for each view.
  -- Since this is a CTE, we don't have to put the parameters in the same ordre as the q.rd file yet.
  SELECT
  -- variable parameters
  subs_longit AS subsolar_longitude,
  subs_colat AS subsolar_colatitude,
  RIGHT('000' || CAST(subs_longit AS VARCHAR), 3) || '-' || RIGHT('000' || CAST(subs_colat AS VARCHAR), 3) AS obs_id,
  'http://cdpp2.cesr.fr/data/illu67p/thumbnails/thumbnail-' || RIGHT('000' || CAST(subs_longit AS VARCHAR), 3) || '-' || RIGHT('000' || CAST(subs_colat AS VARCHAR), 3) || '.png' AS thumbnail_url,
  raw_size,
  image_size,
  preview_size,
  votable_size,

  -- hard-coded parameters
  CAST('sv' AS TEXT) AS dataproduct_type,
  -- CAST('xx' AS TEXT) is used here to avoid the PSQL error "Could not determine the collation to use for the column xxx."
  CAST('67P' AS TEXT) AS target_name,
  CAST('http://imagearchives.esac.esa.int/index.php?/page/navcam_3d_models' AS TEXT) AS shape_model_url,
  CAST('Rosetta' AS TEXT) AS instrument_host_name,
  CAST('navigation camera' AS TEXT) AS instrument_name,
  CAST('comet' AS TEXT) AS target_class,
  CAST(6 AS INTEGER) AS processing_level,
  DATE '2016-04-07T10:41:00.00+00:00' AS creation_date,
  DATE '2016-04-07T10:41:00.00+00:00' AS modification_date,
  DATE '2016-04-07T10:41:00.00+00:00' AS release_date,
  CAST('CDPP-AMDA' AS TEXT) AS service_title,
  CAST('CDPP' AS TEXT) AS publisher,
  CAST('UTC' AS TEXT) AS time_scale,

  -- null, but required parameters
  CAST(NULL AS DOUBLE PRECISION) AS time_min,
  CAST(NULL AS DOUBLE PRECISION) AS time_max,
  CAST(NULL AS DOUBLE PRECISION) AS time_sampling_step_min,
  CAST(NULL AS DOUBLE PRECISION) AS time_sampling_step_max,
  CAST(NULL AS TEXT) AS spatial_frame_type,
  CAST(NULL AS DOUBLE PRECISION) AS time_exp_min,
  CAST(NULL AS DOUBLE PRECISION) AS time_exp_max,
  CAST(NULL AS TEXT) AS measurement_type,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_range_min,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_range_max,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_sampling_step_min,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_sampling_step_max,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_resolution_min,
  CAST(NULL AS DOUBLE PRECISION) AS spectral_resolution_max,
  CAST(NULL AS DOUBLE PRECISION) AS c1min,
  CAST(NULL AS DOUBLE PRECISION) AS c1max,
  CAST(NULL AS DOUBLE PRECISION) AS c2min,
  CAST(NULL AS DOUBLE PRECISION) AS c2max,
  CAST(NULL AS DOUBLE PRECISION) AS c3min,
  CAST(NULL AS DOUBLE PRECISION) AS c3max,
  CAST(NULL AS TEXT) AS s_region,
  CAST(NULL AS DOUBLE PRECISION) AS c1_resol_min,
  CAST(NULL AS DOUBLE PRECISION) AS c1_resol_max,
  CAST(NULL AS DOUBLE PRECISION) AS c2_resol_min,
  CAST(NULL AS DOUBLE PRECISION) AS c2_resol_max,
  CAST(NULL AS DOUBLE PRECISION) AS c3_resol_min,
  CAST(NULL AS DOUBLE PRECISION) AS c3_resol_max,
  CAST(NULL AS DOUBLE PRECISION) AS incidence_min,
  CAST(NULL AS DOUBLE PRECISION) AS incidence_max,
  CAST(NULL AS DOUBLE PRECISION) AS emergence_min,
  CAST(NULL AS DOUBLE PRECISION) AS emergence_max,
  CAST(NULL AS DOUBLE PRECISION) AS phase_min,
  CAST(NULL AS DOUBLE PRECISION) AS phase_max,
  CAST(NULL AS TEXT) AS species,
  CAST(NULL AS TEXT) AS feature_name,
  CAST(NULL AS TEXT) AS bib_reference
  FROM illu67p.data_table
)
-- Now we build the epn_core view, union of 4 SELECTS (raw, image, preview, votable).
-- The columns order must be the same as the q.rd here.
SELECT
  'raw-' || obs_id AS granule_uid,
  dataproduct_type, target_name, time_min, time_max, subsolar_longitude, subsolar_colatitude,
  'http://cdpp2.cesr.fr/data/illu67p/raws/raw-' || obs_id || '.txt' AS access_url,
  thumbnail_url, shape_model_url, instrument_host_name, instrument_name, target_class, processing_level,
  raw_size AS access_estsize,
  'raw' AS granule_gid,
  obs_id,
  'text/plain' AS access_format,
  'raw-' || obs_id || '.txt' AS file_name,
  creation_date, modification_date, release_date, service_title, publisher, time_scale, time_sampling_step_min, time_sampling_step_max, spatial_frame_type, time_exp_min, time_exp_max, measurement_type, spectral_range_min, spectral_range_max, spectral_sampling_step_min, spectral_sampling_step_max, spectral_resolution_min, spectral_resolution_max, c1min, c1max, c2min, c2max, c3min, c3max, s_region, c1_resol_min, c1_resol_max, c2_resol_min, c2_resol_max, c3_resol_min, c3_resol_max, incidence_min, incidence_max, emergence_min, emergence_max, phase_min, phase_max, species, feature_name, bib_reference
FROM cte
UNION ALL
SELECT
  'image-' || obs_id AS granule_uid,
  dataproduct_type, target_name, time_min, time_max, subsolar_longitude, subsolar_colatitude,
  'http://cdpp2.cesr.fr/data/illu67p/images/image-' || obs_id || '.jpg' AS access_url,
  thumbnail_url, shape_model_url, instrument_host_name, instrument_name, target_class, processing_level,
  image_size AS access_estsize,
  'image' AS granule_gid,
  obs_id,
  'image/jpg' AS access_format,
  'image-' || obs_id || '.jpg' AS file_name,
  creation_date, modification_date, release_date, service_title, publisher, time_scale, time_sampling_step_min, time_sampling_step_max, spatial_frame_type, time_exp_min, time_exp_max, measurement_type, spectral_range_min, spectral_range_max, spectral_sampling_step_min, spectral_sampling_step_max, spectral_resolution_min, spectral_resolution_max, c1min, c1max, c2min, c2max, c3min, c3max, s_region, c1_resol_min, c1_resol_max, c2_resol_min, c2_resol_max, c3_resol_min, c3_resol_max, incidence_min, incidence_max, emergence_min, emergence_max, phase_min, phase_max, species, feature_name, bib_reference
FROM cte
UNION ALL
SELECT
  'preview-' || obs_id AS granule_uid,
  dataproduct_type, target_name, time_min, time_max, subsolar_longitude, subsolar_colatitude,
  'http://cdpp2.cesr.fr/data/illu67p/previews/preview-' || obs_id || '.jpg' AS access_url,
  thumbnail_url, shape_model_url, instrument_host_name, instrument_name, target_class, processing_level,
  preview_size AS access_estsize,
  'preview' AS granule_gid,
  obs_id,
  'image/jpg' AS access_format,
  'preview-' || obs_id || '.jpg' AS file_name,
  creation_date, modification_date, release_date, service_title, publisher, time_scale, time_sampling_step_min, time_sampling_step_max, spatial_frame_type, time_exp_min, time_exp_max, measurement_type, spectral_range_min, spectral_range_max, spectral_sampling_step_min, spectral_sampling_step_max, spectral_resolution_min, spectral_resolution_max, c1min, c1max, c2min, c2max, c3min, c3max, s_region, c1_resol_min, c1_resol_max, c2_resol_min, c2_resol_max, c3_resol_min, c3_resol_max, incidence_min, incidence_max, emergence_min, emergence_max, phase_min, phase_max, species, feature_name, bib_reference
FROM cte
UNION ALL
SELECT
  'votable-' || obs_id AS granule_uid,
  dataproduct_type, target_name, time_min, time_max, subsolar_longitude, subsolar_colatitude,
  'http://cdpp2.cesr.fr/data/illu67p/votables/votable-' || obs_id || '.xml' AS access_url,
  thumbnail_url, shape_model_url, instrument_host_name, instrument_name, target_class, processing_level,
  votable_size AS access_estsize,
  'votable' AS granule_gid,
  obs_id,
  'application/x-votable+xml' AS access_format,
  'votable-' || obs_id || '.xml' AS file_name,
  creation_date, modification_date, release_date, service_title, publisher, time_scale, time_sampling_step_min, time_sampling_step_max, spatial_frame_type, time_exp_min, time_exp_max, measurement_type, spectral_range_min, spectral_range_max, spectral_sampling_step_min, spectral_sampling_step_max, spectral_resolution_min, spectral_resolution_max, c1min, c1max, c2min, c2max, c3min, c3max, s_region, c1_resol_min, c1_resol_max, c2_resol_min, c2_resol_max, c3_resol_min, c3_resol_max, incidence_min, incidence_max, emergence_min, emergence_max, phase_min, phase_max, species, feature_name, bib_reference
FROM cte
