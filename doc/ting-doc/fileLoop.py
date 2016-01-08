from PIL import Image
from PIL.ExifTags import TAGS
import glob
import os

def get_exif(fn):
    print fn
    ret = {}
    i = Image.open(fn)
    info = i._getexif()
    for tag, value in info.items():
        decoded = TAGS.get(tag, tag)
        ret[decoded] = value
    return ret

def getGPS(fn):
    imgInfo = get_exif(fn)
    GPSInfo = imgInfo ['GPSInfo']
    north = float(GPSInfo [2][0][0])+ (float(GPSInfo [2][1][0])/60) + (float(GPSInfo [2][2][0])/3600)
    south = north-0.00008
    east = (-1*float(GPSInfo [4][0][0])- (float(GPSInfo [4][1][0])/60) - (float(GPSInfo [4][2][0])/3600))
    west = east - 0.0001

    return str(north)+','+str(south)+','+str(east)+','+str(west)

def getLoc(fn):
    imgInfo = get_exif(fn)
    GPSInfo = imgInfo ['GPSInfo']
    latitude = float(GPSInfo [2][0][0])+ (float(GPSInfo [2][1][0])/60) + (float(GPSInfo [2][2][0])/3600)
    longitude = (-1*float(GPSInfo [4][0][0])- (float(GPSInfo [4][1][0])/60) - (float(GPSInfo [4][2][0])/3600))
    return str(latitude)+','+str(longitude)

def makeGroundOverlayData(path,output):
    os.chdir(path)
    data = ""
    for files in glob.glob("*.jpg"):
                gps=getGPS(files)
                line = gps+',15.000000\n'
                data+=line
    f = open(output,'w')
    f.write(data)
    f.close()

def makeLoc(path,output):
    os.chdir(path)
    data = ""
    for files in glob.glob("*.jpg"):
                loc=getLoc(files)
                line = files+','+loc+'\n'
                data+=line
    f = open(output,'w')
    f.write(data)
    f.close()

def makePhotoOverlayData(path,output):
    os.chdir(path)
    data = ""
    for files in glob.glob("*.jpg"):
                loc=getLoc(files)
                line = loc+',15\n'
                data+=line
    f = open(output,'w')
    f.write(data)
    f.close()
    
makeGroundOverlayData()
makePhotoOverlayData()
