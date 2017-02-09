'''This parses WMS, ad hoc for planetarymaps.usgs.gov
To use - download and run from command line terminal:
python wms_parser.py Object System
e.g.
python wms_parser.py Deimos Mars
or
python wms_parser.py Mars Mars
This should print out a dictionary of all 
simple cylindrical astrogeology maps available from USGS.
'''
#
#
#
#################################
#mObject="Mars"#input field DEBUG
#mSystem="Mars"#input field DEBUG
import sys
mObject=sys.argv[1]#command line parameter
mSystem=sys.argv[2]#command line parameter
import json
import urllib
from xml.dom.minidom import parseString
from astropy.time import Time
import requests
from astropy.time import Time
baseURL="https://planetarymaps.usgs.gov/cgi-bin/mapserv?map=/maps/"
suffixURL="_simp_cyl.map&"
requestGetCapURL="service=WMS&request=GetCapabilities"
requestDescCovURL="service=WCS&version=1.1.0&request=DescribeCoverage"
mTargetClass=["planet","satellite"][mObject!=mSystem]
mOnlineResource=baseURL+mSystem.lower()+'/'+mObject.lower()+suffixURL
getCapURL=mOnlineResource+requestGetCapURL
descCovURL=mOnlineResource+requestDescCovURL
#print(mOnlineResource)
#print(getCapURL)
#mInstrumentHostName="Spacecraft name? see abstract"# this should come from PIA
#mInstrumentName="Imaging device? see abstract" # http://photojournal.jpl.nasa.gov/catalog/PIA14908
#mReference="Reference? see abstract"
#mReleaseDate="Release date? see abstract"
myDoc=parseString(requests.get(getCapURL).text)
cap=myDoc.getElementsByTagName("Capability")[0] # assuming there is only one capability
getChildrenByTagName=lambda parent,name:[child for child \
                                          in parent.childNodes if child.nodeName==name]
#groupLayers=[x for x in cap.childNodes if x.nodeName=="Layer"]
groupLayers=getChildrenByTagName(cap,"Layer")
layerList=groupLayers[0].getElementsByTagName("Layer")#then all the nested layers, assuming there's only one group layer
myLayer=layerList[0]
getCapDict={}
for myLayer in layerList:
    mLayerTitle=myLayer.getElementsByTagName("Title")[0].childNodes[0].data
    mLayerLayerName=myLayer.getElementsByTagName("Name")[0].childNodes[0].data
    mminx=myLayer.getElementsByTagName("westBoundLongitude")[0].childNodes[0].data
    mmaxx=myLayer.getElementsByTagName("eastBoundLongitude")[0].childNodes[0].data
    mminy=myLayer.getElementsByTagName("southBoundLatitude")[0].childNodes[0].data
    mmaxy=myLayer.getElementsByTagName("northBoundLatitude")[0].childNodes[0].data
    mabstract=myLayer.getElementsByTagName("Abstract")[0].childNodes[0].data #this will be useful to fill out missing data
    getCapDict[mLayerLayerName]={'LayerTitle':mLayerTitle,
                            'LayerLayerName':mLayerLayerName,
                            'minx':mminx,
                            'maxx':mmaxx,
                            'miny':mminy,
                            'maxy':mmaxy,
                            'abstract':mabstract}
#print(','.join([minx, maxx, miny, maxy]))
myDesc=parseString(requests.get(descCovURL).text)
CovDecList=myDesc.getElementsByTagName("CoverageDescription")
CovDec=CovDecList[0] # pick the first one, in final version do this for all
CovDecDict={}

for CovDec in CovDecList:
    CovDecTitle=CovDec.getElementsByTagName("ows:Title")[0].childNodes[0].data
    GrOfsts=CovDec.getElementsByTagName("GridOffsets")[0].childNodes[0].data.split(" ")
    CovDecDict[CovDecTitle]=GrOfsts
    
#getCapDict
#CovDecDict

q=list(CovDecDict.keys())
qa=q[0]
for qa in q:
    getCapDict[qa]['c1res']=CovDecDict[qa][0]
    getCapDict[qa]['c2res']=CovDecDict[qa][1]
#CovDecDict[]
print(getCapDict) #this is the output
