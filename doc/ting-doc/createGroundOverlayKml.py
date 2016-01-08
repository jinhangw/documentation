import glob
import os

def createPicDict(path):
    os.chdir(path)
    picDict = {}
    for files in glob.glob("*.txt"):
        f = open(files,'r')
        for lines in f:
            filename=lines[0:lines.find(".jpg")+4]
            data = lines.split('||')
            filedata={}
            filedata['location']=data[1].split(',')
            filedata['orientation']=data[2].split(',')
            filedata['focalLength']=data[3].split(',')
            filedata['acceleration']=data[4].split(',')
            filedata['acceleration'][2]=filedata['acceleration'][2][0:len(filedata['acceleration'][2])-2]
            picDict[filename]=filedata
    return picDict
    
def createGroundOverlay(path,kmlPath):
    os.chdir(path)
    picDict=createPicDict(path)
    name = "Ground Overlays"
    description = "Overlay shows road surface conditions"
    kmlMain = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
        '<Folder>\n'
        '<name>Network Links</name>\n'
        )
    for pic in picDict:
        print "Processing picture: "+pic
        kmlFileAddr = kmlPath+"/"+str(pic[0:len(pic)-4])+".kml"
        href = path+"/"+pic
        kmlHeader = (
            '<NetworkLink>\n'
            '<Link>\n'
            '<href>'+ kmlFileAddr+ '</href>\n'
            '</Link>'
            '</NetworkLink>')
        kmlMain += kmlHeader
        # Creates latLonBox data
        north=float(picDict[pic]['location'][1])
        south=north-0.00008
        east=float(picDict[pic]['location'][0])
        west=east-0.0001
        rotation = float(picDict[pic]['orientation'][0])
    # Standard kml header
        kml = (
           '<?xml version="1.0" encoding="UTF-8"?>\n'
           '<kml xmlns="http://www.opengis.net/kml/2.2">\n'
           '<Folder>\n'
           '<name>%s</name>\n'
           '<description>Examples of ground overlays</description>\n'
           '<GroundOverlay>\n'
           '<name>Small-scale overlay on terrain' + str(pic[0:len(pic)-4]) + '</name>\n'
           '<description>%s</description>\n'
           '<Icon>\n'
           '<href>%s</href>\n'
           '</Icon>\n'
           '<LatLonBox>\n'
           '<north>%f</north>\n'
           '<south>%f</south>\n'
           '<east>%f</east>\n'
           '<west>%f</west>\n'
           '<rotation>%f</rotation>\n'
           '</LatLonBox>\n'
           '</GroundOverlay>\n'
           '</Folder>\n'
           '</kml>\n'
           ) %(name, description, href, north, south, east, west, rotation)
    # Creates kml file for individual photo
        try:
            f = open(kmlFileAddr, 'w')
            f.write(kml)
            f.close()
            print "New kml file created: "
            print kmlFileAddr
            print "\n"
        except:
            print "Path not found!"
            os.mkdir(kmlPath)
            print "New path created: \n"
            print kmlPath
            f = open(kmlFileAddr, 'w')
            f.write(kml)
            f.close()
            print "New kml file created: "+kmlFileAddr
            print "\n"
    # Creates top level kml file   
    kmlMain += (
        '</Folder>\n'
        '</kml>\n')
    f =  open(kmlPath+"/openMultipleGroundKml.kml",'w')
    f.write(kmlMain)
    f.close()
    
createGroundOverlay("D:/Research/Images/2012-06-07/Bridge/surface","D:/Research/Images/2012-06-07/Bridge/kml")
