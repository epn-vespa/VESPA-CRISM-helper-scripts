# Import this module to a python script adding a new column to data.csv
# to be able to compute DJI drone footprints (to rotate a polygon given yaw).
import math
import numpy as np
class droneRectangle():
    """Class to compute a DJI drone footprint from drone yaw, FoV diameter, and center coordinates"""
    def __init__(self):
        self.cornersOrdered=[(a,b) for a in [4/5,-4/5] for b in [3/5,-3/5]] # create corners of a unit rectangle
        self.cornersCircle=np.asarray(self.cornersOrdered[:2]+self.cornersOrdered[2:][::-1]) # rearrange coordinates clockwise
        self.cornersDeg=np.arctan2(*np.split(self.cornersCircle.T,2))[0]*180/np.pi # calculate degrees
        self.getCornerCoords=lambda q: np.stack([np.sin(q*np.pi/180),np.cos(q*np.pi/180)]).T #convert from degrees to coords
        #math definitions end
        self.CoordConverter=lambda t: (str((-t[3])+(t[1]*((t[2]) / 2.0))/(math.pi*3390.0*math.cos(((t[4])+(t[0]*((t[2]) / 2.0))/    \
            (math.pi*3390.0 / 180.0))*math.pi/180.0) / 180.0)),str((t[4])+t[0]*((t[2]) / 2.0)/(math.pi*3390.0 / 180.0)))
        #converter definitions end
    def giveRotFootprint(self, Rotation: float, Diameter: float, c1mid: float, c2mid: float) -> str:
        """rectangle ratio of 3:4 is assumed"""
        cornersDegRot=self.cornersDeg+Rotation # add rotation from Yaw
        coords=self.getCornerCoords(cornersDegRot) 
        coordsClosed=coords.tolist()+[coords.tolist()[0]]
        coordsMap=[self.CoordConverter([*coordClosed,10,25,35]) for coordClosed in coordsClosed]
        coordsList=[' '.join(i) for i in coordsMap]
        coordsStr=' '.join(coordsList)
        footprint= 'Polygon '+coordsStr
        return footprint
