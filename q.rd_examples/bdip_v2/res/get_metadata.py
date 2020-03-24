import psycopg2
import datetime

from gavo.grammars.customgrammar import CustomRowIterator


class RowIterator(CustomRowIterator):
    def _iterRows(self):
        #import pdb;pdb.set_trace()
        with open(self.sourceToken, 'r') as f:
            input_tables = f.readlines()
        for table in input_tables:
            bdip_table = table.strip()
            print "Loading data from {}".format(bdip_table)
            yield bdip_metadata(bdip_table)
            
                

def bdip_metadata(bdip_table):
    #import pdb;pdb.set_trace()
    
    ####
    # DB connection details
    ####
    mdbhost = 'voparis-tap'
    mdb = 'gavo'
    mdbuser = 'lesia'
    mdbpassword = 'xxxxxxxx'  # change password !
    dbschema = 'bdip'
    
    ####
    # Setting up DB connection
    ####
    try:
        con = psycopg2.connect(database=mdb, user=mdbuser, host=mdbhost, password=mdbpassword)
        cur = con.cursor(name="cursor")
        con.commit()

        sql_command  = "SELECT * FROM {}.{};".format(dbschema,bdip_table)
        print 'Executing SQL command:'
        print sql_command
        cur.execute(sql_command)
    
        row = cur.fetchone()
        
        bdip_md = list()
        while row is not None:
            md = dict()
            if bdip_table == "bdip_files":
                md["index"] = row[0]
                md["format"] = row[1]
                md["filename"] = row[2]
                md["filesize"] = row[3]
            elif bdip_table.startswith("bdip_"):
                md["index"] = row[0]
                md["observatoire"] = row[1]
                md["code_obs"] = row[2]
                md["incertitude_obs"] = row[3]
                md["date_heure"] = datetime.datetime.combine(row[4],row[5])
                md["observateurs"] = row[6]
                md["instrument"] = row[7]
                md["diametre"] = row[8]
                md["LCM1"] = row[9]
                md["LCM2"] = row[10]
                md["DE"] = row[11]
                md["PHA"] = row[12]
                md["L"] = row[13]
                md["filtre"] = row[14]
                md["nb_images"] = row[15]
                md["commentaire"] = row[16]
                md["lien_image"] = row[17]
                md["RA"] = row[18]
                md["dec"] = row[19]
                md["target_dist"] = row[20]
                md["phase"] = row[21]
                md["solar_elongation"] = row[22]
                md["julian_date"] = row[23]
            elif bdip_table == "observatoires":
                md["id"] = row[0]
                md["code_obs"] = row[1]
                md["nom_obs"] = row[2]
                md["siteweb"] = row[3]
                md["code_uai"] = row[4]
            else:
                print "wrong table name" 

            yield md
            row = cur.fetchone()
    
        cur.close()

    except psycopg2.DatabaseError, e:
        print 'Error %s' % e
        sys.exit(1)
    
    finally:
        con.close()

    return bdip_md
