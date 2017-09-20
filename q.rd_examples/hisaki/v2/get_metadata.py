#!/usr/bin/python

import os
import platform 
import sys
import datetime 
import hashlib 
import json 
import pyfits
import numpy
import math

from gavo.grammars.customgrammar import CustomRowIterator

class RowIterator(CustomRowIterator):
  def _iterRows(self):
    file_types = ['fits', 'jpg']
    file_fits = self.sourceToken
    #import pdb;pdb.set_trace()
    if file_fits.endswith(".fits"):
        file_jpg = file_fits.replace(".fits",".jpg")
        yield hisaki_metadata(file_fits).copy()
        yield hisaki_metadata(file_jpg).copy()

def md5sum(filename, blocksize=65536):
    """
    compute MD5 hash for file
    :param filename: input filename
    :param blocksize: size of block for split computing
    :return digest: MD5 hash for input file
    """
    md5hash = hashlib.md5()
    with open(filename, "rb") as fhdl:
        for block in iter(lambda: fhdl.read(blocksize), b""):
            md5hash.update(block)
    return md5hash.hexdigest()


def creation_date(path_to_file):
    """
    Try to get the date that a file was created, falling back to when it was
    last modified if that isn't possible.
    See http://stackoverflow.com/a/39501288/1709587 for explanation.
    :param path_to_file: path to file
    :return datetime: creation date of file
    """

    if platform.system() == 'Windows':
        t = os.path.getctime(path_to_file)
    else:
        stat = os.stat(path_to_file)
        try:
            t = stat.st_birthtime
        except AttributeError:
            # We're probably on Linux. No easy way to get creation dates here,
            # so we'll settle for when its content was last modified.
            t = stat.st_mtime
    return datetime.datetime.fromtimestamp(t).isoformat()


def modification_date(filename):
    """
    extract modification date
    :param filename: path to file
    :return datetime: modification date
    """

    t = os.path.getmtime(filename)
    return datetime.datetime.fromtimestamp(t).isoformat()


def access_url(file_name):
    """
    assemble access URL
    :param file_name: file name (no path)
    :return url: access file url
    """
    
    file_type = file_name.split(".")[-1]
    if file_type == 'fits':
        return 'https://hisaki.darts.isas.jaxa.jp/euv/l2/{}'.format(os.path.basename(file_name))
    elif file_type == 'jpg':
        return 'https://hisaki.darts.isas.jaxa.jp/ql/euv/{}'.format(os.path.basename(file_name))
    else:
        raise Exception("Wrong input file name %s" % file_name)


def hisaki_metadata(file_name):
    """
    extract metadata from CDF and build metadata item for provided file type
    :param file_name: input file path
    """
    
    file_type = file_name.split(".")[-1]
    file=os.path.basename(file_name)
    data_path=os.path.dirname(file_name)+'/'
    if file_type == 'jpg':
        jpgfile=file
        fitsfile=file.replace('.jpg','.fits')
    elif file_type == 'fits':
        fitsfile=file
        jpgfile=file.replace('.fits','.jpg')
    print 'loading header from: '+data_path+fitsfile
    
    ####
    # Loading header info
    ####
    hdulist = pyfits.open(data_path+fitsfile,memmap=True)
    prim_hdr = hdulist[0].header
    imag_hdr = hdulist[1].header
    hdulist.close()
    
    ####
    # extra name, id and file
    ####
    # file name without fits extension
    # to be used as granule_uid in EPNcore table
    name = '.'.join(os.path.basename(file_name).split('.')[0:-1])
    
    obs_id = name
    # observation id to link between processing level
    #(if there is any other data level shared in the future)
    
    ####
    # building metadata
    ####
    metadata={}
    metadata['accref'] = file_name
#    metadata['dataproduct_type'] = "sc"
    if file_type == 'fits':
        metadata['granule_uid'] = obs_id
        metadata['granule_gid'] = "partially_processed"
    elif file_type == 'jpg':
        metadata['granule_uid'] = obs_id+'-preview'
        metadata['granule_gid'] = "partially_processed-preview"
    metadata['instrument_host_name'] = "HISAKI"
    metadata['instrument_name'] = "EXCEED"
    metadata['creation_date'] =  prim_hdr['DATE'] 
    metadata['modification_date'] =  prim_hdr['DATE'] 
    metadata['release_date'] =  "2020-01-01T00:00:00"
    metadata['time_scale'] =  'UTC'
    metadata['iso_time_min'] =  imag_hdr['DATE-OBS'] 
    metadata['iso_time_max'] =  imag_hdr['DATE-END'] 
    metadata['time_sampling_step_min'] =  60.
    metadata['time_sampling_step_max'] =  60.
    metadata['time_exp_min'] =  60.
    metadata['time_exp_max'] =  60.
    metadata['target_name'] = imag_hdr['OBJECT'] 
    metadata['target_name'] =  metadata['target_name'][0].upper() + metadata['target_name'][1:] 
    metadata['region'] = "Polygon J2000 %s %s %s %s %s %s %s %s" % (imag_hdr['SLX1RA'],imag_hdr['SLX1DEC'],imag_hdr['SLX2RA'],imag_hdr['SLX2DEC'],imag_hdr['SLX3RA'],imag_hdr['SLX3DEC'],imag_hdr['SLX4RA'],imag_hdr['SLX4DEC'])
    metadata['spectral_range_min'] = 299792458.*1.e+10/imag_hdr['EU_WMAX']
    metadata['spectral_range_max'] = 299792458.*1.e+10/imag_hdr['EU_WMIN']
    metadata['access_url'] =  access_url(file_name)
    metadata['access_estsize'] = os.path.getsize(file_name)/1024.
    metadata['access_md5'] =  md5sum(file_name)
    if file_type == 'fits':
        metadata['access_format'] = 'image/fits'
    elif file_type == 'jpg':
        metadata['access_format'] = 'image/jpeg'

    metadata['thumbnail_url'] =  access_url(jpgfile)
    metadata['processing_level'] =  4
    metadata['bib_reference'] =  '2013P&SS...85..250Y'
    metadata['publisher'] =  'JAXA/ISAS'
    metadata['service_title'] =  'Hisaki'
    metadata['target_region'] =  'Magnetosphere#Ionosphere'
    metadata['measurement_type'] =  'phot.count;em.UV'
    metadata['c1_resol_min'] =  17./3600.
    metadata['c1_resol_max'] =  17./3600.
    metadata['c2_resol_min'] =  17./3600.
    metadata['c2_resol_max'] =  17./3600.
    metadata['file'] = os.path.basename(file_name)
    metadata['obs_id'] =  obs_id
    metadata['phase'] = -999.
    if 'N/A' in  str(imag_hdr['XSCPLA']):
            metadata['phase'] = -999.
    else:
            v_pe= (-imag_hdr['XSCPLA'],-imag_hdr['YSCPLA'],-imag_hdr['ZSCPLA'])
            v_pe= v_pe/numpy.linalg.norm(v_pe)
            v_ps= ( imag_hdr['XSCSUN']+v_pe[0], imag_hdr['YSCSUN']+v_pe[1], imag_hdr['ZSCSUN']+v_pe[2])
            v_ps= v_ps/numpy.linalg.norm(v_ps)
            metadata['phase'] = math.degrees(numpy.arccos(numpy.dot(v_pe,v_ps)))
    metadata['ra'] = imag_hdr['TARRA']
    metadata['dec'] = imag_hdr['TARDEC']
    if 'N/A' in str(imag_hdr['SLATPSC']):
            metadata['subobserver_latitude'] = -999.
    else:
            metadata['subobserver_latitude'] = imag_hdr['SLATPSC']
    if 'N/A' in str(imag_hdr['SLONPSC']):
            metadata['subobserver_longitude'] = -999.
    else:
            metadata['subobserver_longitude'] = imag_hdr['SLONPSC']
    if 'N/A' in str(imag_hdr['SLATPSU']):
            metadata['subsolar_latitude'] = -999.
    else:
            metadata['subsolar_latitude'] = imag_hdr['SLATPSU']
    if 'N/A' in str(imag_hdr['SLONPSU']):
            metadata['subsolar_longitude'] = -999.
    else:
            metadata['subsolar_longitude'] = imag_hdr['SLONPSU']
    if 'N/A' in str(imag_hdr['RADIPSC']):
            metadata['target_distance'] = -999.
    else:
            metadata['target_distance'] = imag_hdr['RADIPSC']
    if 'N/A' in str(imag_hdr['RADIPSU']):
            metadata['sun_distance'] = -999.
    else:
            metadata['sun_distance'] = imag_hdr['RADIPSU']/149597870.7
    metadata['obs_mode'] = "TIME-TAG"
    metadata['detector_name'] = "EXCEED MCP"
    metadata['opt_elem'] = "EXCEED Grating"
    metadata['filter'] = "NO FILTER"
    metadata['filter'] = "360asec x " +imag_hdr['SLITMODE'] + ' slit'
    if '140asec' in imag_hdr['SLITMODE'].lower():
            metadata['filter'] = 'dumbbell'
            metadata['spectral_resolution_min'] = 299792458./5.e-10
            metadata['spectral_resolution_max'] = 299792458./5.e-10
    elif '60asec' in imag_hdr['SLITMODE'].lower():
            metadata['filter'] = 'midium'
            metadata['spectral_resolution_min'] = 299792458./3.e-10
            metadata['spectral_resolution_max'] = 299792458./3.e-10
    elif '10asec' in imag_hdr['SLITMODE'].lower():
            metadata['filter'] = 'thin'
            metadata['spectral_resolution_min'] = 299792458./1.e-10
            metadata['spectral_resolution_max'] = 299792458./1.e-10
    else:
            metadata['filter'] = 'dumbbell'
            metadata['spectral_resolution_min'] = 299792458./5.e-10
            metadata['spectral_resolution_max'] = 299792458./5.e-10
    
    metadata['orientation'] = 0.
    metadata['unit'] = "counts/min"
    metadata['proposal_id'] = None 
    metadata['proposal_pi'] = None 
    metadata['proposal_title'] = None 
    metadata['platesc'] = 4.1
    metadata['campaign'] = imag_hdr['OBJECT'] + " long-term " + imag_hdr['DATE-OBS'][0:4]
    metadata['target_apparent_radius'] = imag_hdr['APPDIA']
    metadata['north_pole_position'] = 0.
    metadata['target_secondary_hemisphere'] = None
    if 'north' in imag_hdr['TARGET'].lower():
            metadata['target_primary_hemisphere'] = "north"
    elif 'south' in imag_hdr['TARGET'].lower():
            metadata['target_primary_hemisphere'] = "south"
    else:
            metadata['target_primary_hemisphere'] = None
    metadata['proposal_title'] = "Long-term monitoring of Jovian aurorae and Io torus"
    metadata['proposal_pi'] = "Yamazaki"
    metadata['origin'] = "JAXA Hisaki Reformatter System"
    metadata['spectral_sampling_step_min'] = 299792458./1.e-10
    metadata['spectral_sampling_step_max'] = 299792458./1.e-10
    metadata['time_exp_min'] = 60.
    metadata['time_exp_max'] = 60.*prim_hdr['NEXTEND']
    return metadata


#if __name__ == '__main__':
#    from gavo.grammars.customgrammar import CustomGrammar
#    ri = RowIterator(CustomGrammar(None), "/var/gavo/inputs/nda/data/2017/01/srn_nda_routine_jup_edr_201701010227_201701011025_V12.cdf")
#    print ri.getParameters()
#    for file_cdf in ri:
#        if file_cdf.endswith(".cdf"):
#        file_pdf = build_pdf_from_cdf(file_cdf)
#        for ftype in file_types:
#            yield nda_metadata(file_cdf, file_pdf, ftype)
