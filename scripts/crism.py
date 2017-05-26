# This script processes JSON file with L coverages only, 
# queries ODE REST for coverage description in xml (to get angles and dates),
# queries rasdaman to get S coverage dimensions,
# and writes out data file in csv to be loaded into GAVO using q.rd for CRISM
# for both L and S coverages.

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
    print(name)
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
    rowvals=[name,footprint,Easternmost_longitude,Maximum_latitude,Minimum_latitude,
             Westernmost_longitude,dimE,dimN,Incidence_angle,Emission_angle,Phase_angle,
             UTC_start_time,UTC_stop_time,Solar_longitude]
    row=','.join([str(i) for i in rowvals])
    return row+'\n'+makeRowS(name)

def makeRowS(name):
    nameS=name[:-6]+'S'+name[-5:]
    myDoc=parseString(requests.get(baseURL+nameS).text)
    myDoc.getNodeValue=lambda val: myDoc.getElementsByTagName(val)[0].firstChild.nodeValue
    rasdamanURL="http://access.planetserver.eu:8080/rasdaman/ows?service=WCS&version=2.0.1&request=DescribeCoverage&CoverageId="
    rasdamanDoc=parseString(requests.get(rasdamanURL+nameS.lower()).text)
    if str(myDoc.getNodeValue('Products'))=='No Products Found':
        print ('product not found')
        return ''
    if rasdamanDoc.getElementsByTagName('high')==[]:
        print ('rasdaman empty')
        return ''
    footprintRaw=myDoc.getNodeValue('Footprint_C0_geometry')
    footprintS='Polygon '+footprintRaw[10:-2].replace(',', '')
    Easternmost_longitude=myDoc.getNodeValue('Easternmost_longitude')
    Maximum_latitude=myDoc.getNodeValue('Maximum_latitude')
    Minimum_latitude=myDoc.getNodeValue('Minimum_latitude')
    Westernmost_longitude=myDoc.getNodeValue('Westernmost_longitude')
    rasdamanBox=rasdamanDoc.getElementsByTagName('high')[0].firstChild.nodeValue
    rasdamanEN=[int(x)+1 for x in rasdamanBox.split()]
    dimE=rasdamanEN[0]
    dimN=rasdamanEN[1]
    Incidence_angle=myDoc.getNodeValue('Solar_longitude')
    Emission_angle=myDoc.getNodeValue('Emission_angle')
    Phase_angle=myDoc.getNodeValue('Phase_angle')
    UTC_start_time=Time(myDoc.getNodeValue('UTC_start_time')).jd
    UTC_stop_time=Time(myDoc.getNodeValue('UTC_stop_time')).jd
    Solar_longitude=myDoc.getNodeValue('Solar_longitude')
    rowvals=[nameS,footprintS,Easternmost_longitude,Maximum_latitude,Minimum_latitude,
             Westernmost_longitude,dimE,dimN,Incidence_angle,Emission_angle,Phase_angle,
             UTC_start_time,UTC_stop_time,Solar_longitude]
    row=','.join([str(i) for i in rowvals])
    return row+'\n'
####

jsonData=json.load(open(InputFile))
output=open(OutputFile,'w')
headerRow=','.join([str(i) for i in fields])
output.writelines(headerRow+'\n')
lowerBound=0
upperBound=len(jsonData)
#for x in range(0,upperBound,100):
upperBound=lowerBound+10
n=10
for x in range(0,upperBound,n):
    print(str(x)+' out of '+str(upperBound))
    limit=[upperBound, x+n][upperBound>x]
    output.writelines([makeRow(j) for j in jsonData[x:limit]])

output.close()
