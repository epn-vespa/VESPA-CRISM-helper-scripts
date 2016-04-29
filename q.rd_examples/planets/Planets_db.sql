 
-- SQL procedure to define the planets service datatable  
-- Stephane Erard, LESIA/OVPDC, May 2015 (written by IDL routine dbmassesv2.pro)
-- Can be used as a template for other light services 
 
-- DATABASE "Planets", must be created first;       
 
-- Name: Planets; Type: SCHEMA; Schema: Planets; Owner: postgres

DROP SCHEMA IF EXISTS planets cascade;
-- line above to be commented for tests only
CREATE SCHEMA planets;
SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

-- Name: data_table; Type: TABLE; Schema: planets; Owner: postgres; Tablespace: 

CREATE TABLE planets.data_table (
    id integer NOT NULL,
    target character varying(10),
    Mean_rad 		double precision,
    Mean_rad_unc 	double precision,
    Eq_rad 		double precision,
    Eq_rad_unc 	double precision,
    Polar_Rad      double precision ,
    Polar_Rad_Unc  double precision ,
    Rms_Dev        double precision ,
    Max_Elev       double precision ,
    Min_Elev       double precision ,
    Mass           double precision ,
    Mean_Dist	    double precision ,
    Rotation	    double precision 
);
 
COPY planets.data_table (id, target, mean_rad, mean_rad_unc, eq_rad, eq_rad_unc, polar_rad, polar_rad_unc, rms_dev, max_elev, min_elev, mass, mean_dist, rotation) FROM stdin;
1	Mercury	2439.7000	1.0000000	2439.7000	1.0000000	2439.7000	1.0000000	1.0000000	4.6000000	2.5000000	3.3014000e+23	57909227.	1407.5040
2	Venus	6051.8000	1.0000000	6051.8000	1.0000000	6051.8000	1.0000000	1.0000000	11.000000	2.0000000	4.8673200e+24	1.0820948e+08	-5832.4320
3	Earth	6371.0000	0.010000000	6378.1400	0.010000000	6356.7500	0.010000000	3.5700000	8.8500000	11.520000	5.9721900e+24	1.4959826e+08	23.934472
4	Mars	3389.5000	0.20000000	3396.1900	0.10000000	3376.0000	0.10000000	3.0000000	22.640000	7.5500000	6.4169300e+23	2.2794382e+08	24.624000
5	Jupiter	69911.000	6.0000000	71492.000	4.0000000	66854.000	10.000000	62.100000	31.000000	102.00000	1.8981300e+27	7.7834082e+08	9.9249600
6	Saturn	58232.000	6.0000000	60268.000	4.0000000	54364.000	10.000000	102.90000	8.0000000	205.00000	5.6831900e+26	1.4266664e+09	10.656000
7	Uranus	25362.000	7.0000000	25559.000	4.0000000	24973.000	20.000000	16.800000	28.000000	0.0000000	8.6810300e+25	2.8706582e+09	-17.232000
8	Neptune	24622.000	19.000000	24764.000	15.000000	24341.000	30.000000	8.0000000	14.000000	0.0000000	1.0241000e+26	4.4983964e+09	16.104000
\.
 
ALTER TABLE ONLY planets.data_table
        ADD CONSTRAINT data_table_pkey PRIMARY KEY (id);

-- Set access/ownership of schema and table  
REVOKE ALL ON SCHEMA "planets" FROM PUBLIC;  
REVOKE ALL ON SCHEMA "planets" FROM postgres;  
GRANT ALL ON SCHEMA "planets" TO postgres;  
GRANT ALL PRIVILEGES ON SCHEMA planets TO gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON SCHEMA planets TO gavoadmin WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON planets.data_table TO gavo WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON planets.data_table TO gavoadmin WITH GRANT OPTION; 
 
