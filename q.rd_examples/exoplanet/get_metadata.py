import psycopg2
import datetime

from gavo.grammars.customgrammar import CustomRowIterator


class RowIterator(CustomRowIterator):
    def _iterRows(self):
        ####
        # DB connection details
        ####
        mdbhost = 'localhost'
#        mdbhost = 'voparis-django-m.obspm.fr'
        mdb = 'exoplanet'
        mdbuser = 'lesidaner'
        mdbpassword = 'home_passwd'  # change password !
#        mdbuser = 'exoplanet_user'
#        mdbpassword = 'server_paswd'  # change password !
        dbschema = 'public'
        mytable = 'epn_vue'
        try:
            con = psycopg2.connect(database=mdb, user=mdbuser, host=mdbhost, password=mdbpassword)
            cur = con.cursor()
            con.commit()

        ####
        #import pdb;pdb.set_trace()
            with open(self.sourceToken, 'r') as f:
                input_tables = f.readlines()
        	sql_command  = "SELECT obs_id, target_name, c1min, c2min, release_date, creation_date, modification_date, species, detection_type, publication_status, mass, mass_error_min, mass_error_max, radius, radius_error_min, radius_error_max, semi_major_axis, semi_major_axis_error_min, semi_major_axis_error_max, period, period_error_min, period_error_max, eccentricity, eccentricity_error_min, eccentricity_error_max, periastron, periastron_error_min, periastron_error_max, tzero_tr, tzero_tr_error_min, tzero_tr_error_max, tzero_vr, tzero_vr_error_min, tzero_vr_error_max, t_peri, t_peri_error_min, t_peri_error_max, t_conj, t_conj_error_min, t_conj_error_max, inclination, inclination_error_min, inclination_error_max, tzero_tr_sec, tzero_tr_sec_error_min, tzero_tr_sec_error_max, lambda_angle, lambda_angle_error_min, lambda_angle_error_max, discovered, updated, remarks, other_web, angular_distance, temp_calculated, temp_measured, hot_point_lon, log_g, created, modified, albedo, albedo_error_min, albedo_error_max, mass_detection_type, radius_detection_type, mass_sin_i, mass_sin_i_error_min, mass_sin_i_error_max, impact_parameter, impact_parameter_error_min, impact_parameter_error_max, k, k_error_min, k_error_max, alternate_name, star_name, star_distance, star_distance_error_min, star_distance_error_max, star_spec_type, mag_v, mag_i, mag_j, mag_h, mag_k, star_metallicity, star_mass, star_radius, star_age, star_teff, magnetic_field, detected_disc FROM {}.{};".format(dbschema,mytable)
        #	print 'Executing SQL command:'
       #		print sql_command
        	cur.execute(sql_command)
        	row = cur.fetchone()
    	    	my_md = list()
        	while row is not None:
                    my_md = my_metadata(row)
                    for md in my_md:
                       yield md
                    row = cur.fetchone()
        except psycopg2.DatabaseError, e:
            print 'Error %s' % e
            sys.exit(1)
    
        finally:
            con.close()

                

def my_metadata(row):
    md = dict()
    my_md = list()
    md["granule_uid"] = row[1]
    md["c1min"] = row[2]
    md["c1max"] = row[2]
    md["ra"] = row[2]
    md["c2min"] = row[3]
    md["c2max"] = row[3]
#  convert star distance in PC to C3 in meter and take error min and max 
#  handle NaN, infinity and None
    if row[77] == 'Infinity':
        md["c3min"] = 0.0
    elif row[76]  is None:
        md["c3min"] = None
    elif row[77] == 'NaN' or  row[77] is None:
        md["c3min"] = (float(row[76])) * 96939420213600000.0
    else :
        md["c3min"] = (float(row[76])-float(row[77])) * 96939420213600000.0
    if row[78] == 'Infinity':
        md["c3max"] = row[78]
    elif row[76]  is None:
        md["c3min"] = None
    elif row[78] == 'NaN' or  row[78] is None:
        md["c3max"] = (float(row[76])) * 96939420213600000.0
    else :
        md["c3max"] = (float(row[76])+float(row[78])) * 96939420213600000.0
    md["dec"] = row[3]
    md["obs_id"] = row[0]
    md["target_name"] = row[1]
    md["modification_date"] = row[6]
    md["creation_date"] = row[58]
    md["release_date"] = row[58]
    md["species"] = row[7]
    md["detection_type"] = row[8]
    md["publication_status"] = row[9]
    md["mass"] = row[10]
    md["mass_error_min"] = row[11]
    md["mass_error_max"] = row[12]
    md["radius"] = row[13]
    md["radius_error_min"] = row[14]
    md["radius_error_max"] = row[15]
    md["semi_major_axis"] = row[16]
    md["semi_major_axis_error_min"] = row[17]
    md["semi_major_axis_error_max"] = row[18]
    md["period"] = row[19]
    md["period_error_min"] = row[20]
    md["period_error_max"] = row[21]
    md["eccentricity"] = row[22]
    md["eccentricity_error_min"] = row[23]
    md["eccentricity_error_max"] = row[24]
    md["periastron"] = row[25]
    md["periastron_error_min"] = row[26]
    md["periastron_error_max"] = row[27]
    md["tzero_tr"] = row[28]
    md["tzero_tr_error_min"] = row[29]
    md["tzero_tr_error_max"] = row[30]
    md["tzero_vr"] = row[31]
    md["tzero_vr_error_min"] = row[32]
    md["tzero_vr_error_max"] = row[33]
    md["t_peri"] = row[34]
    md["t_peri_error_min"] = row[35]
    md["t_peri_error_max"] = row[36]
    md["t_conj"] = row[37]
    md["t_conj_error_min"] = row[38]
    md["t_conj_error_max"] = row[39]
    md["inclination"] = row[40]
    md["inclination_error_min"] = row[41]
    md["inclination_error_max"] = row[42]
    md["tzero_tr"] = row[43]
    md["tzero_tr_error_min"] = row[44]
    md["tzero_tr_error_max"] = row[45]
    md["lambda_angle"] = row[46]
    md["lambda_angle_error_min"] = row[47]
    md["lambda_angle_error_max"] = row[48]
    if row[49] is None:
         md["discovered"] = int(0)
    else:
         md["discovered"] = int(row[49])
#    md["updated"] = row[50]
    md["remarks"] = row[51]
#    md["other_web"] = row[52]
    md["angular_distance"] = row[53]
    md["temp_calculated"] = row[54]
    md["temp_measured"] = row[55]
    md["hot_point_lon"] = row[56]
    md["log_g"] = row[57]
#    md["created"] = row[58]
#    md["modified"] = row[59]
    md["albedo"] = row[60]
    md["albedo_error_min"] = row[61]
    md["albedo_error_max"] = row[62]
    md["mass_detection_type"] = row[63]
    md["radius_detection_type"] = row[64]
    md["mass_sin_i"] = row[65]
    md["mass_sin_i_error_min"] = row[66]
    md["mass_sin_i_error_max"] = row[67]
    md["impact_parameter"] = row[68]
    md["impact_parameter_error_min"] = row[69]
    md["impact_parameter_error_max"] = row[70]
    md["k"] = row[71]
    md["k_error_min"] = row[72]
    md["k_error_max"] = row[73]
    md["alternate_name"] = row[74]
    md["star_name"] = row[75]
    md["star_distance"] = row[76]
    md["star_distance_error_min"] = row[77]
    md["star_distance_error_max"] = row[78]
    md["star_spec_type"] = row[79]
    md["mag_v"] = row[80]
    md["mag_i"] = row[81]
    md["mag_j"] = row[82]
    md["mag_h"] = row[83]
    md["mag_k"] = row[84]
    md["star_metallicity"] = row[85]
    md["star_mass"] = row[86]
    md["star_radius"] = row[87]
    md["star_age"] = row[88]
    md["star_teff"] = row[89]
    md["magnetic_field"] = row[90]
    md["detected_disc"] = row[91]
    md["external_link"] = "http://exoplanet.eu/catalog/"+str(row[1]).replace(' ','_').lower()
    my_md.append(md)

    return my_md
