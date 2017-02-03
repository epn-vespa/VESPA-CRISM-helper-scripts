# This script processes JSON file with coverages, 
# queries ODE REST for coverage description in xml (to get angles and dates), 
# and writes out data file in csv to be loaded into GAVO using q.rd for CRISM.

import sys
import json
import urllib
from xml.dom.minidom import parseString
from astropy.time import Time
import requests
from astropy.time import Time

InputFile=sys.argv[1]
OutputFile=sys.argv[2]

baseURL="http://oderest.rsl.wustl.edu/live2/?target=mars&query=product&results=m&output=XML&pt=TRDRDDR&iid=CRISM&ihid=MRO&proj=c0&westlon=0&eastlon=360&minlat=-90&maxlat=90&pdsid="
fields=['name','footprint','Easternmost_longitude','Maximum_latitude','Minimum_latitude','Westernmost_longitude','dimE','dimN','Incidence_angle','Emission_angle','Phase_angle','UTC_start_time','UTC_stop_time','Solar_longitude']

def makeRow(r):
    name=r['coverageID']
    strList= lambda l:[str(a) for a in l]
    footprint='Polygon '+' '.join([' '.join(i) for i in zip(strList(r['longList']),strList(r['latList']))])
    Easternmost_longitude=r['Easternmost_longitude']
    Maximum_latitude=r['Maximum_latitude']
    Minimum_latitude=r['Minimum_latitude']
    Westernmost_longitude=r['Westernmost_longitude']
    dimE=r['width']
    dimN=r['height']
    myDoc=parseString(requests.get(baseURL+name).text)
    myDoc.getNodeValue=lambda val: myDoc.getElementsByTagName(val)[0].firstChild.nodeValue
    Incidence_angle=myDoc.getNodeValue('Solar_longitude')
    Emission_angle=myDoc.getNodeValue('Emission_angle')
    Phase_angle=myDoc.getNodeValue('Phase_angle')
    UTC_start_time=Time(myDoc.getNodeValue('UTC_start_time')).jd
    UTC_stop_time=Time(myDoc.getNodeValue('UTC_stop_time')).jd
    Solar_longitude=myDoc.getNodeValue('Solar_longitude')
    rowvals=[name,footprint,Easternmost_longitude,Maximum_latitude,Minimum_latitude,             Westernmost_longitude,dimE,dimN,Incidence_angle,Emission_angle,Phase_angle,             UTC_start_time,UTC_stop_time,Solar_longitude]
    row=','.join([str(i) for i in rowvals])
    return row

jsonData=json.load(open(InputFile))
output=open(OutputFile,'w')
headerRow=','.join([str(i) for i in fields])
output.writelines(headerRow)
upperBound=len(jsonData)
for x in range(0,upperBound,100):
    print(str(x)+' out of '+str(upperBound))
    limit=[upperBound, x+100][upperBound>x]
    output.writelines([makeRow(j) for j in jsonData[x:limit]])
output.close()
