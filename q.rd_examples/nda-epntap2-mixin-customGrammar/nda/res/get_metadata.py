#!/usr/bin/python

import os

os.environ["CDF_LIB"] = '/home/user/dev/cdf36_2-dist/lib'
from spacepy import pycdf
import platform 
import sys
import datetime 
import hashlib 
import json 

from gavo.grammars.customgrammar import CustomRowIterator

class RowIterator(CustomRowIterator):
  def _iterRows(self):
    file_types = ['cdf', 'pdf', 'rt1']
    file_cdf = self.sourceToken
    #import pdb;pdb.set_trace()
    if file_cdf.endswith(".cdf"):
        file_pdf = build_pdf_from_cdf(file_cdf)
        for ftype in file_types:
            yield nda_metadata(file_cdf, file_pdf, ftype)


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


def access_url(file_name, parent_name, file_type):
    """
    assemble access URL
    :param file_name: file name (no path)
    :param parent_name: name of parent file
    :param file_type: type of access url to be built
    :return url: access file url
    """
    
    yy = int(parent_name[1:3])
    if yy > 70:
        yy += 1900
    else: 
        yy += 2000
    mm = int(parent_name[3:5])
    if file_type == 'cdf':
        root_url = 'http://realtime.obs-nancay.fr/routine_jupiter'
        return '{}/{:04d}/{:02d}/{}'.format(root_url, yy, mm, file_name)
    elif file_type == 'pdf':
        root_url = 'http://realtime.obs-nancay.fr/ql_routine_jupiter/B-W'
        return '{}/{:04d}/{:02d}/{}'.format(root_url, yy, mm, parent_name+'.pdf')
    elif file_type == 'rt1':
        root_url = 'http://realtime.obs-nancay.fr/routine_jupiter'
        return '{}/{:04d}/{:02d}/{}'.format(root_url, yy, mm, parent_name+'.RT1')
    elif file_type == 'png':
        root_url = 'http://realtime.obs-nancay.fr/ql_routine_jupiter/B-W'
        return '{}/{:04d}/{:02d}/{}'.format(root_url, yy, mm, 'T_'+parent_name+'.png')
    else:
        print 'Illegal file type... Aborting'
        return '' 


def build_pdf_from_cdf(file_cdf):
    """
    builds pdf file name from cdf
    :param: input cdf file path
    :return: pdf file path
    """
    
    cdf = pycdf.CDF(file_cdf)
    file_pdf = '{}.pdf'.format(os.path.join(os.path.dirname(file_cdf.replace('/data/','/ql/B-W/')), cdf.attrs['Parents'][0].split('.')[0]))
    cdf.close()
    
    return file_pdf


def nda_metadata(file_cdf, file_pdf, file_type):
    """
    extract metadata from CDF and build metadata item for provided file type
    :param file_cdf: input CDF file path
    :param file_pdf: input PDF file path
    :param file_type: file type
    :return metadata: metadata for file
    :return status: 0 if success; -1 if error
    """
    
    cdf = pycdf.CDF(file_cdf)
    md = dict()
    md['obs_id'] = cdf.attrs['Parents'][0].split('.')[0]

    if file_type == 'cdf':
        cur_file = file_cdf
        md['granule_uid'] = '{}_cdf'.format(md['obs_id'])
        md['granule_gid'] = 'SRN NDA EDR Routine Data'
        md['creation_date'] = creation_date(cur_file)
        md['access_format'] = cdf.attrs['VESPA_access_format'][0]
        md['processing_level'] = 2
    elif file_type == 'pdf':
        cur_file = file_pdf
        md['granule_uid'] = '{}_pdf'.format(md['obs_id']) 
        md['granule_gid'] = 'SRN NDA PDF Routine Summary Plots'
        md['creation_date'] = cdf.attrs['PDS_Observation_stop_time'][0]
        md['access_format'] = 'application/pdf'
        md['processing_level'] = 4
    elif file_type == 'rt1':
        cur_file = os.path.join(os.path.dirname(file_cdf), cdf.attrs['Parents'][0])
        md['granule_uid'] = '{}_rt1'.format(md['obs_id'])
        md['granule_gid'] = 'SRN NDA RT1 Routine Raw Data'
        md['creation_date'] = cdf.attrs['PDS_Observation_stop_time'][0]
        md['access_format'] = 'application/binary'
        md['processing_level'] = 1
    else:
        print 'Illegal file type... Aborting'
        return md, -1

    md['target_name'] = '#'.join(cdf.attrs['PDS_Observation_target'])
    md['target_class'] = '#'.join(cdf.attrs['VESPA_target_class'])
    md['time_min'] = cdf.attrs['PDS_Observation_start_time'][0]
    md['time_max'] = cdf.attrs['PDS_Observation_stop_time'][0]
    md['time_sampling_step_min'] = float(cdf.attrs['VESPA_time_sampling_step'][0])
    md['time_sampling_step_max'] = float(cdf.attrs['VESPA_time_sampling_step'][0])
    md['time_exp_min'] = float(cdf.attrs['VESPA_time_exp'][0])
    md['time_exp_max'] = float(cdf.attrs['VESPA_time_exp'][0])
    md['spectral_range_min'] = float(cdf.attrs['VESPA_spectral_range_min'][0])
    md['spectral_range_max'] = float(cdf.attrs['VESPA_spectral_range_max'][0])
    md['spectral_sampling_step_min'] = float(cdf.attrs['VESPA_spectral_sampling_step'][0])
    md['spectral_sampling_step_max'] = float(cdf.attrs['VESPA_spectral_sampling_step'][0])
    md['spectral_resolution_min'] = float(cdf.attrs['VESPA_spectral_resolution'][0])
    md['spectral_resolution_max'] = float(cdf.attrs['VESPA_spectral_resolution'][0])
    md['measurement_type'] = '#'.join(cdf.attrs['VESPA_measurement_type'])
    md['receiver_name'] = cdf.attrs['VESPA_receiver_name'][0].split('>')[0]
    md['modification_date'] = modification_date(cur_file)
    md['release_date'] = datetime.datetime.now().isoformat()
    md['access_md5'] = md5sum(cur_file)
    md['thumbnail_url'] = access_url(os.path.basename(file_cdf), md['obs_id'], 'png')
    md['target_region'] = '#'.join(cdf.attrs['VESPA_target_region'])
    md['feature_name'] = '#'.join(cdf.attrs['VESPA_feature_name'])
    md['bib_reference'] = '#'.join(cdf.attrs['VESPA_bib_reference'])
    md['access_url'] = access_url(os.path.basename(file_cdf), md['obs_id'], file_type)
    md['filename'] = os.path.basename(cur_file)
    md['access_estsize'] = os.path.getsize(cur_file)/1024
    cdf.close()

    return md

if __name__ == '__main__':
    from gavo.grammars.customgrammar import CustomGrammar
    ri = RowIterator(CustomGrammar(None), "/var/gavo/inputs/nda/data/2017/01/srn_nda_routine_jup_edr_201701010227_201701011025_V12.cdf")
    print ri.getParameters()
    for file_cdf in ri:
        if file_cdf.endswith(".cdf"):
        file_pdf = build_pdf_from_cdf(file_cdf)
        for ftype in file_types:
            yield nda_metadata(file_cdf, file_pdf, ftype)
