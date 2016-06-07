--
-- PostgreSQL database dump
--

--
-- Name: dam; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dam;

--
-- Name: routine_jup; Type: TABLE; Schema: dam; Owner: postgres; Tablespace: 
--

CREATE TABLE dam.routine_jup (
    time_min timestamp without time zone,
    time_max timestamp without time zone,
    f_rt1 character varying(8),
    f_url character varying(128),
    f_size integer,
    q_url character varying(128)
);


--
-- Name: epn_core; Type: VIEW; Schema: dam; Owner: postgres
--

CREATE VIEW dam.epn_core AS
 SELECT 'NDA Routine Jupiter CDF'::text AS granule_gid,
	routine_jup.f_rt1 || '-cdf'::text AS granule_uid,
	routine_jup.f_rt1 AS obs_id,
    'ds'::text AS dataproduct_type,
    'Jupiter'::text AS target_name,
    'planet'::text AS target_class,
    (((to_char(routine_jup.time_min, 'J'::text))::double precision + (date_part('epoch'::text, (routine_jup.time_min)::time without time zone) / (86400)::double precision)) - (0.5)::double precision) AS time_min,
    (((to_char(routine_jup.time_max, 'J'::text))::double precision + (date_part('epoch'::text, (routine_jup.time_max)::time without time zone) / (86400)::double precision)) - (0.5)::double precision) AS time_max,
    (1)::double precision AS time_sampling_step_min,
    (1)::double precision AS time_sampling_step_max,
    (0.5)::double precision AS time_exp_min,
    (0.5)::double precision AS time_exp_max,
    (10000000)::double precision AS spectral_range_min,
    (40000000)::double precision AS spectral_range_max,
    (75000)::double precision AS spectral_sampling_step_min,
    (75000)::double precision AS spectral_sampling_step_max,
    (30000)::double precision AS spectral_resolution_min,
    (30000)::double precision AS spectral_resolution_max,
    NULL::text AS c1min,
    NULL::text AS c1max,
    NULL::text AS c2min,
    NULL::text AS c2max,
    NULL::text AS c3min,
    NULL::text AS c3max,
    NULL::text AS c1_resol_min,
    NULL::text AS c1_resol_max,
    NULL::text AS c2_resol_min,
    NULL::text AS c2_resol_max,
    NULL::text AS c3_resol_min,
    NULL::text AS c3_resol_max,
    NULL::text AS spatial_frame_type,
    NULL::text AS incidence_min,
    NULL::text AS incidence_max,
    NULL::text AS emergence_min,
    NULL::text AS emergence_max,
    NULL::text AS phase_min,
    NULL::text AS phase_max,
    'Nancay Decameter Array'::text AS instrument_host_name,
    'Routine Receiver'::text AS instrument_name,
    'phot.flux.density;phys.polarisation.circular;em.radio'::text AS measurement_type,
    routine_jup.f_url AS access_url,
    'CDF'::text AS access_format,
    routine_jup.f_size AS access_estsize,
    5 AS processing_level,
    'VOParis Data Centre on behalf of the Station de radioastronomie de NANCAY and LESIA (CNRS, Observatoire de Paris)'::text AS publisher,
    'TBD'::text AS reference,
    'Jovian radio emission Routine observation from Nancay Decameter Array'::text AS title,
    'magnetosphere'::text AS target_region,
    routine_jup.q_url AS preview_url
   FROM routine_jup;


ALTER TABLE epn_core OWNER TO postgres;

--
-- Name: dam; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA dam FROM PUBLIC;
REVOKE ALL ON SCHEMA dam FROM postgres;
GRANT USAGE ON SCHEMA dam TO gavo;
GRANT ALL ON SCHEMA dam TO gavoadmin;


REVOKE ALL ON TABLE dam.routine_jup FROM PUBLIC;
REVOKE ALL ON TABLE dam.routine_jup FROM postgres;
GRANT ALL ON TABLE dam.routine_jup TO postgres;
GRANT ALL ON TABLE dam.routine_jup TO gavo WITH GRANT OPTION;
GRANT ALL ON TABLE dam.routine_jup TO gavoadmin WITH GRANT OPTION;


--
-- Name: epn_core; Type: ACL; Schema: dam; Owner: postgres
--

REVOKE ALL ON TABLE dam.epn_core FROM PUBLIC;
REVOKE ALL ON TABLE dam.epn_core FROM postgres;
GRANT SELECT ON TABLE dam.epn_core TO gavo;
GRANT ALL ON TABLE dam.epn_core TO gavoadmin;

