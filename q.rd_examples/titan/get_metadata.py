#!/usr/bin/env Python
# -*- coding: iso-8859-15 -*-

import datetime
import sys
import os
import os.path
import numpy as np
import matplotlib.pyplot as plt
from gavo.grammars.customgrammar import CustomRowIterator

max_index=[]
months = {'January': 1, 'February': 2, 'March': 3, 'April': 4, 'May': 5, 'June': 6, 'July': 7, 'August': 8,'September': 9, 'October': 10, 'November': 11, 'December': 12}

class RowIterator(CustomRowIterator):
  def _iterRows(self):
    file_types = ['profq','profT']
    file_titan = self.sourceToken
    #import pdb;pdb.set_trace()
    #not sure it is usefull to separate temp en density here
#    if file_titan.find("profq"):
#        file_jpg = file_fits.replace(".fits",".jpg")
    my_metadata = titan_metadata(file_titan)
    yield my_metadata.copy()
    my_metadata['access_url'] = my_metadata['access_url'].replace('http','http://voparis-srv-paris.obspm.fr/titan/to_vot_titan.py?fileurl=http')
    my_metadata['granule_uid'] = my_metadata['granule_uid'].replace('_ascii','_votable')
    my_metadata['access_format']='application/x-votable+xml'
    yield my_metadata.copy()
#        yield titan_metadata(file_jpg).copy()


#    make thumbnail image of the the file small size around 200x200 pixels
#    affich(alt,press,dens,ylabel, x1label,x2label, filename)
def affich(alt,press,dens, ylabel, x1label, x2label, filename):
    fig = plt.figure(figsize=(2.2, 2.2), dpi=80)
    new_tick_locations = np.array([.2, .5, .9])
    plt.locator_params(nbins=4)
    ay1 = fig.add_subplot(111)
    ay1.plot(press, alt, 'b')
    plt.xlabel(x1label.replace('"', ''), fontsize=6, color='b')
    for tl in ay1.get_xticklabels():  # color of label on X axes
        tl.set_color('b')
    ay2 = ay1.twiny()
    ay2.plot(dens, alt, 'r')
    plt.locator_params(nbins=3)
 #   ay2.set_xticks(new_tick_locations)
    plt.xlabel(x2label.replace('"', ''), fontsize=6, color='r')
    for tl in ay2.get_xticklabels():  # color of label on Y axes
        tl.set_color('r')
    plt.xticks(size=6)
    plt.yticks(size=6)
    ay1.set_ylabel(ylabel, fontsize = 8)
    #plt.ylabel(ylabel, fontsize = 8, labelpad=50)
    #ay1.ylabel(y1label.replace('"',''), fontsize = 6, color = 'b')
    #ay2.ylabel(y2label.replace('"', ''), fontsize=6, color = 'r')
    #plt.yscale('log')
    plt.tick_params(labelsize=8)
    plt.rc('font', size=8)
    ligne = filename.split('/')  # take only the molecule from the full path
    intermed = ligne[len(ligne) - 1]
    ligne = intermed.split('_')
    title = ligne[len(ligne) - 1]
    #plt.title(title.replace('.txt',''), fontsize = 8 )
    ay1.text(.5, .85, title.replace('.txt',''), horizontalalignment='center', transform=ay1.transAxes)
    # t = plt.axis.get_offset_text()
    # t.set_size(6)
    plt.tight_layout()
    plt.savefig(filename.replace('.txt','.png'))
    plt.close()
#    plt.show()
    return



def titan_metadata(file_name):
    file=os.path.basename(file_name)
    data_path=os.path.dirname(file_name)+'/'
    name = '.'.join(os.path.basename(file_name).split('.')[0:-1])
    
    fichier = open(file_name, "r")
    if 'profq' in file_name:
        type = 1
        label = 10
    if 'profT' in file_name:
        type = 2
        label = 11

    montab = fichier.readlines()

    # initiate varable
    molecule = None
    longitude = None
    Latitude = None
    theisotime = None
    bibcode = None
    subsolar_lon = None
    local_time = None
    alt = []
    press = []
    temp = []
    dens = []
    dens_min = []
    dens_max = []
    i=0

    # **************** read header containing metadata
    #test for empty line until end of file
    while montab[i].strip()!="" and i < len(montab)-1:
        ligne = montab[i].split()
        # species
        if "mixing" in ligne[0].lower():
            molecule = ligne[len(ligne) - 1]
            print 'species', molecule
        # latitude 
    # latitude from time to time orientation left coorected with orient_lat
        if "latitude" in ligne[0].lower() and "of" not in ligne[1].lower():
        # test consistency with what is on filename
            recup = name.split('_')
            if 'N' in recup[0]:
                orient_lat='N'
            if 'S' in recup[0]:
                orient_lat='S'
            latitude = float(ligne[1])
            if len(ligne)>2:
                signe=ligne[2]
            else:
                signe=orient_lat
            if "N" in signe:
                signe = 1.0
                latitude = latitude * signe
            elif "S" in signe:
                signe = -1.0
                latitude = latitude * signe
            else:
                print "problem sign of latitude in", file_name
            latitude = float(latitude)
            print "latitude", latitude
            if signe != orient_lat:
                print "inconsistency in orientation latitude in", file_name
        # longitude
        if "longitude" in ligne[0].lower():
            longitude = float(ligne[1])
            signe = ligne[2]
            if "E" in signe:
                signe = 1.0
                longitude = 360.0 + longitude * signe
            elif "W" in signe:
                signe = -1.0
                longitude = 360.0 + longitude * signe
            else:
                print "probleme on longitude orientation", file_name
            longitude = float(longitude) % 360
            print "longitude", longitude
# date
        if "observation" in ligne[0].lower():
            mois = ligne[2]
            mois = int(months[mois])
            jour = ligne[3]
            jour = int(jour.replace(',', ''))
            annee = int(ligne[4])
            theisotime = datetime.date(annee, mois, jour).isoformat()
            print 'theisotime',theisotime
# reference
        if "reference" in ligne[0].lower():
            taille=len(ligne)-1
#            print 'tutu',taille
            for ii in range(taille):
                if '2015' in ligne[ii]:
                    bibcode="2015Icar..250...95V"
                    date_crea= '2014-06-10T15:00:00+0200'
                    modif_date = '2015-06-10T15:00:00+0200'
                if '2010' in ligne[ii]:
                    bibcode="2010Icar..205..559V"
                    date_crea= '2009-06-10T15:00:00+0200'
                    modif_date = '2015-06-10T15:00:00+0200'
# solar longitude
        if "Solar" in ligne[0]:
            subsolar_lon = ligne[2]
            print "longitude solaire", subsolar_lon

# local time conver from sexagesimal to decimal
        if "Local" in ligne[0]:

            ltime = ligne[2].split(':',3)
#            print ligne[2],ltime[0],float(ltime[0])+float(ltime[1])/60.0
            try:
                local_time = float(ltime[0])+float(ltime[1])/60.0+float(ltime[2])/3600.0
            except:
                try:
                    local_time = float(ltime[0])+float(ltime[1])/60.0
                except:
                    local_time = float(ltime[0])


            print local_time,'local time'

        #print 'increment',i

        i += 1 
    i += 1 # pass blnck line beween metadata and data
    separate = montab[i].split()
    x1label = separate[1]
    ylabel = separate[0]
    if type == 1: # profq
       x2label = 'density'
    if type == 2:  # profT
       x2label = separate[2]

    # get altitude min and max
    indice_altitude=0
    j=i+1
    altmin = 10000000.0
    altmax = 0.0
    while j < len(montab) and montab[j].strip()!="":
        ligne = montab[j].split()
        if 'NA' in ligne[1]:
            j += 1
            continue
        if type == 1: # profq
            alt.append(float(ligne[0]))
            press.append(float(ligne[1]))
            dens.append(float(ligne[3]))
        if type == 2:  # profT
            if len(ligne) == 2:  # not all data in the table
                j += 1
                continue
            dens.append(float(ligne[2]))
            press.append(float(ligne[1]))
            alt.append(float(ligne[0]))
        if len(ligne) > 3:
            altmin = min(altmin,float(ligne[indice_altitude]))
            altmax = max(altmax,float(ligne[indice_altitude]))
        j += 1
    print 'altitude',altmin, altmax
    affich(alt,press,dens,ylabel, x1label,x2label, file_name)
      
    
    ####
    # building metadata
    ####
    stat = os.stat(file_name)
    metadata={}
    metadata['accref'] = file_name
    metadata['granule_uid'] = file
    if type == 1: # profq
       metadata['granule_uid'] =  file.replace('.txt','_q_ascii')
       metadata['granule_gid'] =  'denity_profile'
    if type == 2:  # profT
       metadata['granule_uid'] =  file.replace('.txt','_t_ascii')
       metadata['granule_gid'] =  'temp_profile'
#    metadata['instrument_host_name'] = "HISAKI"
#    metadata['instrument_name'] = "EXCEED"
    metadata['creation_date'] = theisotime 
    metadata['modification_date'] = datetime.datetime.fromtimestamp(stat.st_mtime).isoformat() 
    metadata['release_date'] = theisotime 
    metadata['time_scale'] =  'UTC'
    metadata['theisotime'] = theisotime 
#    metadata['target_name'] = imag_hdr['OBJECT'] 
#    metadata['target_class'] = imag_hdr['OBJECT'] 
    metadata['access_url'] =  'http://voparis-srv.obspm.fr/vo/planeto/titan/profil/'+file #access_url(file_name)
    metadata['access_estsize'] = 12 #os.path.getsize(file_name)/1024.
    metadata['access_format'] = 'text/plain'
    metadata['thumbnail_url'] =  'http://voparis-srv.obspm.fr/vo/planeto/titan/thumbnail/'+file.replace('.txt','.png')             
    metadata['processing_level'] =  5
    metadata['publisher'] =  'Lesia/PADC/Observatoire de Paris'
    metadata['service_title'] =  'titan'
    metadata['target_region'] =  'Magnetosphere#Ionosphere'
    if type == 1: # profq
       metadata['measurement_type'] =  'phys.pressure phys.temperature phys.abund'
    if type == 2:  # profT
       metadata['measurement_type'] =  'phys.pressure phys.temperature'
    metadata['obs_id'] =  file.replace('.txt','')
    metadata['longitude'] =  longitude
    metadata['latitude'] =  latitude
    metadata['c3min'] =  altmin
    metadata['c3max'] =  altmax
    metadata['species'] = molecule 
    metadata['bib_reference'] = bibcode
    metadata['solar_longitude'] = subsolar_lon
    metadata['local_time'] = local_time
    return metadata



