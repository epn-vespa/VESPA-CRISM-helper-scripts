#! /usr/bin/python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy 
import psycopg2
import os
#import datetime
#import mx.DateTime
#import math
import pyfits
import hashlib
#from PIL import Image

####
# md5_hash function that works on big files
####
def md5_for_file(path, block_size=256*128, hr=False):
	'''Block size directly depends on the block size of your filesystem
	to avoid performances issues Here I have blocks of 4096 octets (Default NTFS)
	'''
	md5 = hashlib.md5()
	with open(path,'rb') as f: 
		for chunk in iter(lambda: f.read(block_size), b''):
			md5.update(chunk)
	if hr:
		return md5.hexdigest()
	return md5.digest()
####
# export bare image function
####

def SaveFigureAsImage(fileName,fig=None,**kwargs):
	''' Save a Matplotlib figure as an image without borders or frames.
		Args:
			fileName (str): String that ends in .png etc.

			fig (Matplotlib figure instance): figure you want to save as the image
		Keyword Args:
			orig_size (tuple): width, height of the original image used to maintain 
			aspect ratio.
	'''
	fig_size = fig.get_size_inches()
	w,h = fig_size[0], fig_size[1]
	fig.patch.set_alpha(0)
	if kwargs.has_key('orig_size'): # Aspect ratio scaling if required
		w,h = kwargs['orig_size']
		w2,h2 = fig_size[0],fig_size[1]
		fig.set_size_inches([(w2/w)*w,(w2/w)*h])
		fig.set_dpi((w2/w)*fig.get_dpi())
	a=fig.gca()
	a.set_frame_on(False)
	a.set_xticks([]); a.set_yticks([])
	plt.axis('off')
	plt.xlim(0,h); plt.ylim(w,0)
	fig.savefig(fileName, transparent=True, bbox_inches='tight', pad_inches=0)

####
# Paths
####
data_path = 'data/'			# Path to the data directory
png_path = 'data/'			# Path to the directory where you want to place the quicklooks

root_url = 'http://locahost:8080/irtf_orton/'

####
# DB connection details
####
mdbhost='localhost'
mdb='gavo'
mdbuser='gavoadmin'
mdbpassword=''		# This password is located in /var/gavo/etc/feed
#dbschema='irtf_orton'
#tablename = 'metadata'


####
# Setting up DB connection
####
try:
	con = psycopg2.connect(database=mdb, user=mdbuser, host=mdbhost, password=mdbpassword)
	cur = con.cursor()
	con.commit()

except psycopg2.DatabaseError, e:
	print 'Error %s' % e
	sys.exit(1)

####
# Loop on files
####
files = os.listdir(data_path)
fits_files = []
for file in files:
	if (file[len(file)-5:] == '.fits'):
		fits_files.append(file)

for file in fits_files:
	
	print 'loading header from: '+data_path+file
	
	####
	# Loading header info
	####
	hdulist = pyfits.open(data_path+file)
	prim_hdr = hdulist[0].header
	
	####
	# Loading total data table
	####
	data = numpy.array(hdulist[0].data, dtype=float)
	hdulist.close()
	
	####
	# extra name, id and file
	####
	# file name without fits extension
	# to be used as granule_uid in EPNcore table
	name = file[0:len(file)-5]
	
	# Preview png file names
	png_file = name + '.png'
#	png_file_small = name + '-small.png'
	
	obs_id = name[0:len(name)-12]
	# observation id to link between processing level
	#(if there is any other data level shared in the future)
	
	####
	# building simple quicklook 
	####
	fig, ax = plt.subplots( nrows=1, ncols=1 )
	ax.imshow(data, cmap=plt.get_cmap('gray'))
	SaveFigureAsImage(png_path+png_file,fig,orig_size=(prim_hdr['NAXIS1'],prim_hdr['NAXIS2']))
#	ax.imshow(-numpy.minimum(data,5), cmap=plt.get_cmap('gray'))
#	SaveFigureAsImage(png_path+png_file,fig,orig_size=(1024,1024))
#	SaveFigureAsImage(png_path+png_file_small,fig,orig_size=(256,256))
	plt.close(fig)
	
	####
	# building metadata
	####
	metadata={}
	metadata['instrument_host_name'] = "'" + prim_hdr['TELESCOP'] + "'"
	metadata['instrument_name'] = "'" + prim_hdr['INSTRUME'] + "'"
	metadata['creation_date'] = "'" + prim_hdr['DATE_OBS'] + "'"
	metadata['iso_time'] = "'" + prim_hdr['DATE_OBS'] + "T" + prim_hdr['TIME_OBS'] + "'"
	metadata['target_name'] = "'" + prim_hdr['OBJECT']+ "'"
#	metadata['target_name'] = "'" + metadata['target_name'][0].upper() + metadata['target_name'][1:] + "'"   # Uncomment if you want to make sure the first letter is a capital one.
	if str(prim_hdr['GFLT'])[0:4] == 'Open':
		metadata['wavelength'] = "'" + str(prim_hdr['OSF'])+ "'"
	else:
		metadata['wavelength'] = "'" + str(prim_hdr['GFLT'])+ "'"
	metadata['exp_time'] = "'" + str(prim_hdr['ITIME']) +"'"
	metadata['access_url'] = "'" + root_url+data_path+file +"'"
	metadata['access_estsize'] = os.path.getsize(data_path+file)/1024.
	metadata['access_md5'] = "'" + md5_for_file(data_path+file, hr=True) + "'"
	metadata['thumb_url'] = "'" + root_url+png_path+png_file + "'"
	metadata['file'] = "'" + name + "'"
	metadata['target_dist'] = "'" + str(prim_hdr['DISTOBJ']) + "'"
	metadata['solar_longitude'] = "'" + str(prim_hdr['HLON']) + "'"
	metadata['longitude_sysIII'] = "'" + str(prim_hdr['LCMIII']) + "'"
	
	####
	# uploading metadata
	####
	print 'uploading metadata from: '+file
	cur.execute("SELECT COUNT(*) FROM irtf_orton.metadata WHERE file = %s" % metadata['file'])
	(number_of_rows,) = cur.fetchone()
	number_of_rows = 0
	print 'nrows',number_of_rows
	if number_of_rows == 0:
		sql_command  = """INSERT INTO irtf_orton.metadata ("""
		sql_com1 = []
		sql_com2 = []
		for key,val in metadata.iteritems():
			print key,val
			sql_com1.append(key)
			sql_com2.append(val)
		sql_command += ', '.join(['%s' % item for item in sql_com1])
		sql_command += """) VALUES ("""
		sql_command += ', '.join(["%s" % item for item in sql_com2])
		sql_command += """);"""
		print 'Executing SQL command:'
		print sql_command
		cur.execute(sql_command)
	else:
		sql_command  = """UPDATE irtf_orton.metadata SET """
		sql_command += ', '.join(["%s=%s" % (key,val) for key,val in metadata.iteritems()])
		sql_command += """ WHERE file=%s;""" % metadata['file']
		print 'Executing SQL command:'
		print sql_command
		cur.execute(sql_command)

if con:
	con.commit()
	con.close()
else:
	print "something's broken..."

