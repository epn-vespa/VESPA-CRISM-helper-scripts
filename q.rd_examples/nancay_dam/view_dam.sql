DROP VIEW IF EXISTS dam.epn_core ;
CREATE or REPLACE VIEW dam.epn_core AS SELECT 
text 'Routine Jupiter' AS granule_gid,
text rt1_file || '-cdf' AS granule_uid,
text rt1_file AS obs_uid,
text 'ds' AS dataproduct_type, 
text 'Jupiter' AS target_name, 
text 'planet' AS target_class, 
cast(to_char(time_min::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_min::time)/86400 - 0.5 AS time_min,
cast(to_char(time_max::timestamp,'J') as double precision) + EXTRACT(EPOCH FROM time_max::time)/86400 - 0.5 AS time_max,
double precision '1' AS time_sampling_step_min,
double precision '1' AS time_sampling_step_max,
NULL AS time_exp_min,
NULL AS time_exp_max,
double precision '1E7' AS spectral_range_min,
double precision '4E7' AS spectral_range_max,
double precision '75E3' AS spectral_sampling_step_min,
double precision '75E3' AS spectral_sampling_step_max,
double precision '3E4' AS spectral_resolution_min,
double precision '3E4' AS spectral_resolution_max,
null AS c1min,
null AS c1max,
null AS c2min,
null AS c2max,
NULL as c3min,
NULL as c3max,
NULL as c1_resol_min,
NULL as c1_resol_max,
NULL as c2_resol_min,
NULL as c2_resol_max,
NULL as c3_resol_min,
NULL as c3_resol_max,
null  AS spatial_frame_type,
NULL as incidence_min,
NULL as incidence_max,
NULL as emergence_min,
NULL as emergence_max,
NULL as phase_min,
NULL as phase_max,
text 'Nancay Decameter Array' AS instrument_host_name,
text 'Routine Receiver' AS instrument_name, 
text 'phot.flux.density;phys.polarisation.circular;em.radio' AS measurement_type,
url_cdf AS access_url,
text 'CDF' AS access_format,
size_cdf AS access_estsize,
integer '5' AS processing_level,
text 'VOParis Data Centre on behalf of the Station de radioastronomie de NANCAY and LESIA (CNRS, Observatoire de Paris)' AS publisher,
text 'TBD' AS reference,
text 'Jovian radio emission Routine observation from Nancay Decameter Array' AS title,
text 'magnetosphere' AS target_region,
url_quicklook as preview_url
FROM dam.routine_jup;

GRANT ALL PRIVILEGES ON SCHEMA dam TO gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON SCHEMA dam TO gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.routine_jup to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.routine_jup to gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.routine_jup to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.routine_jup to gavo WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.epn_core to gavoadmin WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON dam.epn_core to gavo WITH GRANT OPTION;

